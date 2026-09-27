#!/usr/bin/env python3
"""
Shipd.ai Challenge Fetcher — one command, one review directory.

Fetches everything needed to review a Shipd challenge and writes it into a
directory named after the task title:

    <Task-Name>/
      description.md      title, category, problem description
      base_commit.txt     commit hash + repo link
      dockerfile          the challenge Dockerfile
      solution.patch      solution patch
      test.patch          test patch
      quick-setup.sh      the Quick Setup script (byte-identical to the UI's)
      prechecks.md        task type + numbers, plagiarism review, test fairness,
                          every warning/failing check (raw JSON), shipd-bot
                          description warnings + conciseness, env quality
                          (+ agent trajectory on failure)
      auto-review.json    the COMPLETE auto-review data (only when present and NOT
                          stale) — for the new multi-agent format this is the full
                          orchestrator payload (scope gate, per-dimension
                          sub-reviews, agents evidence, synthesis, execution log)
      previous-reviews.md timeline of past reviews + manager feedback (when any);
                          shipd-bot JSON reasoning rendered as JSON blocks
      false-positive-evaluation.md
                          the false-positive review panel, one section per
                          evaluated passing run (adjudicator + every judge)
      repo-fit.md         the Scope Gate: originality + repo-alignment verdict,
                          reasoning, the full gh investigation log, and run
                          history (when the scope gate has run)
      verifier-audit/     the Verifier Completeness Audit (new pre-rollout check
                          that replaced the post-rollout FP check): verdict, every
                          demonstrated gap (broken impl, probe, evidence),
                          requirements coverage, and proposed-patch validation —
                          verifier-audit.md (complete report) + proposed-changes.diff
                          (git-style; apply on top of test.patch for the full fix)
      <repo>/             the task repository — after all artifacts are written
                          you are ASKED whether to clone (y/n; checked out at
                          the base commit; --clone = always, --no-clone = never)

Usage:
    python3 fetch-info.py --login                 # once, to save the session
    python3 fetch-info.py --url <challenge URL>   # fetch a task
    python3 fetch-info.py --url <URL> --name My-Dir   # optional dir override

How it works (fast path — a single page fetch, no UI clicking):
  1. Playwright fetches the raw SSR HTML (before hydration) with the saved
     auth state. The server embeds the full TanStack Query state (Seroval $R)
     with the problem, patches, validation results and dynamic checks.
  2. Node evaluates the Seroval scripts in a vm sandbox and dumps the
     dehydrated query state as JSON.
  3. The few things not in the SSR state (shipd-bot inline comments, the
     env-quality agent trajectory artifact) are fetched straight from the
     Convex HTTP API using the convex token embedded in the same state.

Dependencies: playwright (chromium or local Chrome/Edge), node.
"""

import argparse
import json
import os
import re
import subprocess
import sys
import tempfile
import time
import urllib.request
import urllib.error
from pathlib import Path

from playwright.sync_api import sync_playwright

if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")

SCRIPT_DIR = Path(__file__).resolve().parent
AUTH_FILE = SCRIPT_DIR.parent / "shipd_auth_state.json"

# Convex deployment behind shipd.ai. Not present in the HTML (only in the JS
# bundle), so it is pinned here and re-discovered from the bundle if it moves.
CONVEX_URL_DEFAULT = "https://academic-jellyfish-943.convex.cloud"

CATEGORY_LABELS = {
    "feature_request": "Feature Request",
    "optimization": "Optimization",
    "refactor": "Refactor",
    "bugfix": "Bugfix",
    "enhancement": "Enhancement",
}

DYNAMIC_CHECK_TITLES = {
    "verifyFairness": "Test Fairness",
    "verifySolution": "Verify Solution",
    "verifyTests": "Verify Tests",
    "verifyFlakiness": "Verify Flakiness",
    "taskQuality": "Task Quality",
    "solutionQuality": "Solution Quality",
    "descriptionQuality": "Description Quality",
    "environmentQuality": "Env Quality",
}

PLAGIARISM_CHECK_ID = "llm_dedup"
CONCISENESS_CHECK_ID = "description_conciseness"

# ─── Node.js extractor ───
# Evaluates the Seroval-serialized $R state from the SSR HTML and dumps the
# dehydrated TanStack Query client (every convex query the page was rendered
# with) as plain JSON.
#
# NOTE: scripts are run UNMODIFIED first; the `import(...)` stripping is only
# applied as a retry when a script fails. Stripping unconditionally corrupts
# DATA (e.g. a solution patch containing Python's `from x import (...)`).
EXTRACT_JS = r"""
const fs = require('fs');
const vm = require('vm');
const { ReadableStream, WritableStream, TransformStream } = require('stream/web');

// Hydration glue may call dynamic import(), which rejects asynchronously in
// the vm sandbox and would otherwise crash the process.
process.on('unhandledRejection', () => {});

const htmlPath = process.argv[2];
const outPath = process.argv[3];
const html = fs.readFileSync(htmlPath, 'utf-8');

const scripts = [];
const re = /<script[^>]*>([\s\S]*?)<\/script>/gi;
let m;
while ((m = re.exec(html)) !== null) {
  const code = m[1].trim();
  if (code) scripts.push(code);
}

const sandbox = {
  self: {}, window: {},
  document: { querySelectorAll: () => [] },
  $_TSR: { c() {}, p(e) {}, buffer: [], router: () => {} },
  ReadableStream, WritableStream, TransformStream,
  TextEncoder, TextDecoder, URL, URLSearchParams,
  AbortController, Headers: globalThis.Headers || class Headers {},
  Request: globalThis.Request || class Request {},
  Response: globalThis.Response || class Response {},
  console: { log(){}, warn(){}, error(){} },
  setTimeout, clearTimeout, Promise, queueMicrotask,
  Uint8Array, ArrayBuffer, DataView, Map, Set, WeakMap, WeakSet,
  Symbol, Proxy, Reflect, JSON, Math, Date, RegExp, Error,
  TypeError, RangeError, SyntaxError, Number, String, Boolean, Object, Array,
  parseInt, parseFloat, isNaN, isFinite, encodeURIComponent, decodeURIComponent,
  encodeURI, decodeURI, atob: globalThis.atob, btoa: globalThis.btoa,
};
sandbox.self.$R = {};
sandbox.$R = sandbox.self.$R;
vm.createContext(sandbox);

for (const code of scripts) {
  try {
    vm.runInContext(code, sandbox, { timeout: 15000 });
  } catch (e) {
    // Retry with dynamic import() stubbed out — only for scripts that fail,
    // so string data containing "import (...)" is never touched.
    try {
      const stripped = code.replace(/\bimport\s*\([^)]*\)/g, "'__stripped__'");
      vm.runInContext(stripped, sandbox, { timeout: 15000 });
    } catch (e2) { /* expected for hydration glue */ }
  }
}

const $R = sandbox.self.$R || sandbox.$R || {};

function deepClean(obj, seen) {
  if (obj === null || typeof obj !== 'object') {
    return typeof obj === 'function' ? undefined : obj;
  }
  if (seen.has(obj)) return '[circular]';
  seen.add(obj);
  let result;
  if (Array.isArray(obj)) {
    result = obj.map(v => deepClean(v, seen));
  } else {
    const cn = obj.constructor?.name;
    if (cn && !['Object', 'Array'].includes(cn)) { seen.delete(obj); return undefined; }
    result = {};
    for (const [k, v] of Object.entries(obj)) {
      if (typeof v === 'function') continue;
      if (v && typeof v === 'object' && v.__SEROVAL_STREAM__) continue;
      const cleaned = deepClean(v, seen);
      if (cleaned !== undefined) result[k] = cleaned;
    }
  }
  seen.delete(obj);  // path-based, so shared (non-cyclic) objects serialize everywhere
  return result;
}

// Find the dehydrated query client anywhere in $R.
let queries = null;
function findQueries(obj, depth) {
  if (!obj || typeof obj !== 'object' || depth > 6 || queries) return;
  if (obj.dehydratedData?.dehydratedQueryClient?.queries) {
    queries = obj.dehydratedData.dehydratedQueryClient.queries;
    return;
  }
  const vals = Array.isArray(obj) ? obj : Object.values(obj);
  for (const v of vals) findQueries(v, depth + 1);
}
findQueries($R, 0);

if (!queries) {
  console.error('No dehydrated query client found in the page state.');
  process.exit(2);
}

const out = [];
for (const q of queries) {
  try {
    out.push({
      key: deepClean(q.queryKey, new WeakSet()),
      data: deepClean(q.state?.data, new WeakSet()),
    });
  } catch (e) { /* skip broken entry */ }
}
fs.writeFileSync(outPath, JSON.stringify(out), 'utf-8');
console.log(JSON.stringify({ ok: true, queries: out.length }));
"""


# ──────────────────────────────────────────────────────────────────────────
# Browser / fetching
# ──────────────────────────────────────────────────────────────────────────

def launch_browser(playwright, *, headless: bool):
    attempts = [
        ("Playwright Chromium", {}),
        ("Microsoft Edge", {"channel": "msedge"}),
        ("Google Chrome", {"channel": "chrome"}),
    ]
    errors = []
    for label, options in attempts:
        try:
            return playwright.chromium.launch(headless=headless, **options)
        except Exception as exc:
            errors.append(f"  - {label}: {exc}")
    raise RuntimeError(
        "Could not launch a Chromium browser. Install Playwright Chromium with "
        "`playwright install chromium`, or make sure Edge or Chrome is installed.\n"
        + "\n".join(errors)
    )


def login(url: str | None):
    print("Launching browser for authentication...")
    with sync_playwright() as p:
        browser = launch_browser(p, headless=False)
        context = browser.new_context()
        page = context.new_page()
        page.goto(url or "https://shipd.ai/quests/olympus")
        print("-" * 60)
        print("  Please log in to your account in the browser.")
        print("  Then come back here and press ENTER.")
        print("-" * 60)
        input("Press ENTER after you have successfully logged in... ")
        AUTH_FILE.parent.mkdir(parents=True, exist_ok=True)
        context.storage_state(path=str(AUTH_FILE))
        print(f"✅ Session saved to {AUTH_FILE}")
        browser.close()


def fetch_html(url: str) -> str:
    """Fetch the raw SSR HTML (before hydration) with the saved auth state."""
    if not AUTH_FILE.exists():
        sys.exit(f"❌ Auth file not found: {AUTH_FILE}\n   Run: python3 fetch-info.py --login")

    with sync_playwright() as p:
        browser = launch_browser(p, headless=True)
        context = browser.new_context(storage_state=str(AUTH_FILE))
        page = context.new_page()
        try:
            response = page.goto(url, wait_until="commit", timeout=45000)
            if response is None:
                sys.exit("❌ No response received from the page.")
            html = response.text()
        finally:
            try:
                context.storage_state(path=str(AUTH_FILE))  # keep cookies fresh
            except Exception:
                pass
            browser.close()

    if len(html) < 5000 or "dehydratedData" not in html:
        sys.exit(
            f"❌ Response looks unauthenticated ({len(html):,} bytes). "
            "Re-run: python3 fetch-info.py --login"
        )
    return html


def extract_queries(html: str) -> dict:
    """Run the Node extractor and return {udfName: data} for all page queries."""
    tmp_html = tmp_js = tmp_json = None
    try:
        with tempfile.NamedTemporaryFile("w", suffix=".html", delete=False, encoding="utf-8") as f:
            f.write(html); tmp_html = f.name
        with tempfile.NamedTemporaryFile("w", suffix=".js", delete=False, encoding="utf-8") as f:
            f.write(EXTRACT_JS); tmp_js = f.name
        tmp_json = tmp_html + ".json"

        result = subprocess.run(
            ["node", tmp_js, tmp_html, tmp_json],
            capture_output=True, text=True, timeout=60, encoding="utf-8",
        )
        if result.returncode != 0:
            sys.exit(f"❌ Node extraction failed:\n{result.stderr.strip()}")
        with open(tmp_json, encoding="utf-8") as f:
            raw = json.load(f)
    finally:
        for pth in (tmp_html, tmp_js, tmp_json):
            if pth:
                try: os.unlink(pth)
                except OSError: pass

    queries = {}
    for entry in raw:
        key = entry.get("key")
        if not isinstance(key, list) or not key:
            continue
        name = key[1] if key[0] == "convexQuery" and len(key) > 1 else key[0]
        queries.setdefault(name, entry.get("data"))
    return queries


# ──────────────────────────────────────────────────────────────────────────
# Convex HTTP API (for the few things not in the SSR state)
# ──────────────────────────────────────────────────────────────────────────

class Convex:
    def __init__(self, token: str | None, html: str):
        self.token = token
        self.html = html
        self.base = CONVEX_URL_DEFAULT

    def _post(self, path: str, args: dict):
        body = json.dumps({"path": path, "args": args, "format": "json"}).encode()
        req = urllib.request.Request(
            f"{self.base}/api/query", data=body,
            headers={"Content-Type": "application/json",
                     "Authorization": f"Bearer {self.token}"},
        )
        with urllib.request.urlopen(req, timeout=30) as r:
            return json.loads(r.read())

    def query(self, path: str, args: dict):
        """Run a convex query; returns the value or None on any failure."""
        if not self.token:
            return None
        try:
            res = self._post(path, args)
        except (urllib.error.URLError, urllib.error.HTTPError, OSError):
            if not self._rediscover_base():
                return None
            try:
                res = self._post(path, args)
            except Exception:
                return None
        if res.get("status") != "success":
            print(f"  ⚠️ convex {path}: {str(res)[:150]}")
            return None
        return res.get("value")

    def _rediscover_base(self) -> bool:
        """Find the convex deployment URL from the app's main JS bundle."""
        m = re.search(r'src="(/quests/olympus/assets/main-[^"]+\.js)"', self.html)
        if not m:
            return False
        try:
            with urllib.request.urlopen("https://shipd.ai" + m.group(1), timeout=30) as r:
                bundle = r.read().decode("utf-8", "replace")
        except Exception:
            return False
        m2 = re.search(r'https://[a-z0-9-]+\.convex\.cloud', bundle)
        if m2 and m2.group(0) != self.base:
            self.base = m2.group(0)
            print(f"  ℹ️ convex deployment moved -> {self.base}")
            return True
        return False

    def fetch_artifact(self, artifact_key: str, job_id: str):
        """Resolve an artifact URL (e.g. a trajectory) and download it."""
        url = self.query("artifactProxy:getArtifactUrl",
                         {"artifactKey": artifact_key, "jobId": job_id})
        if isinstance(url, dict):
            url = url.get("url")
        if not url:
            return None
        try:
            with urllib.request.urlopen(url, timeout=90) as r:
                return r.read().decode("utf-8", "replace")
        except Exception as exc:
            print(f"  ⚠️ artifact download failed: {exc}")
            return None


# ──────────────────────────────────────────────────────────────────────────
# Rendering helpers
# ──────────────────────────────────────────────────────────────────────────

def json_block(obj, min_fence: int = 3) -> str:
    text = obj if isinstance(obj, str) else json.dumps(obj, indent=2, ensure_ascii=False)
    fence_len = min_fence
    for m in re.finditer(r"`{3,}", text):
        fence_len = max(fence_len, len(m.group(0)) + 1)
    fence = "`" * fence_len
    return f"{fence}json\n{text}\n{fence}"


def dir_name_from_title(title: str, max_len: int = 25) -> str:
    words = [re.sub(r"[^A-Za-z0-9._-]", "", w) for w in title.split()]
    words = [w for w in words if w]
    if not words:
        return "shipd-task"
    name = words[0]
    for w in words[1:]:
        if len(name) + 1 + len(w) > max_len:
            break
        name += "-" + w
    return name


def write_file(out_dir: Path, name: str, content: str):
    if content and not content.endswith("\n"):
        content += "\n"
    (out_dir / name).write_text(content, encoding="utf-8")
    print(f"  ✅ {name} ({len(content):,} bytes)")


# ──────────────────────────────────────────────────────────────────────────
# Section builders
# ──────────────────────────────────────────────────────────────────────────

def build_quick_setup(problem: dict) -> str:
    """Byte-identical replica of the UI's Quick Setup script generator."""
    v = problem["version"]
    repo = v["githubRepoUrl"]
    pid = problem["_id"]
    version = v["version"]
    folder = (repo.split("/")[-1].replace(".git", "") or "repo") + f"-{pid}"

    d = [
        "cat <<'EOSCRIPT' | bash",
        "#!/bin/bash",
        "",
        "# Clone repository and checkout commit",
        f"git clone {repo} {folder} --recurse-submodules",
        f"cd {folder}",
        f"git checkout {v['githubCommitHash']}",
        "",
        "# Create challenge branch",
        f"git checkout -b shipd-challenge/{pid}-v{version}",
    ]
    if v.get("description"):
        d += ["", "# Write problem description (reference only)",
              "cat > problem.md << '__SHIPD_PROBLEM_CONTENT__'",
              v["description"], "__SHIPD_PROBLEM_CONTENT__"]
    if v.get("testPatch"):
        d += ["", "# Create and apply test patch",
              "cat > test.patch << '__SHIPD_PATCH_CONTENT__'",
              v["testPatch"], "__SHIPD_PATCH_CONTENT__", "git apply test.patch"]
    if v.get("dockerfile"):
        d += ["", "# Create Dockerfile",
              "cat > Dockerfile << '__SHIPD_DOCKERFILE_CONTENT__'",
              v["dockerfile"], "__SHIPD_DOCKERFILE_CONTENT__"]
    if v.get("solutionPatch"):
        d += ["", "# Write solution patch (reference only — not applied)",
              "cat > solution.patch << '__SHIPD_SOLUTION_CONTENT__'",
              v["solutionPatch"], "__SHIPD_SOLUTION_CONTENT__"]
    d += ["", "EOSCRIPT", "", "# Navigate to project directory", f"cd {folder}",
          "", "# Build and run Docker container (uncomment to use)",
          "# docker build -t olympus-challenge .",
          "# docker run -it --network=none olympus-challenge"]
    return "\n".join(d)


def find_check(validation: dict, check_id: str):
    for group in (validation or {}).values():
        if not isinstance(group, dict):
            continue
        for check in group.get("checks") or []:
            if check.get("id") == check_id:
                return check, bool(group.get("stale"))
    return None, False


def task_type_block(criteria_data: dict) -> str:
    task_type = (criteria_data or {}).get("currentSubmissionType") or "unknown"
    task_type = {"olympus": "Olympus", "mars": "Mars"}.get(task_type, task_type.title())

    def long_horizon(items):
        for it in items or []:
            if it.get("id") == "longHorizon":
                return it
        return {}

    olympus_lh = long_horizon((criteria_data or {}).get("criteria"))
    mars_lh = long_horizon((criteria_data or {}).get("marsCriteria"))
    numbers = (mars_lh if task_type == "Mars" else olympus_lh).get("detail") \
        or olympus_lh.get("detail") or mars_lh.get("detail") or "n/a"

    return (
        f"**Task Type**: {task_type}\n\n"
        f"Mars criteria: {mars_lh.get('description', 'n/a')}\n\n"
        f"Olympus criteria: {olympus_lh.get('description', 'n/a')}\n\n"
        f"This task numbers: {numbers}"
    )


def plagiarism_section(validation: dict) -> str:
    check, _stale = find_check(validation, PLAGIARISM_CHECK_ID)
    if not check:
        return "**Plagiarism Review**:\n\nCheck not found / did not run."
    return "**Plagiarism Review**:\n\n" + json_block(check.get("details") or
                                                     {k: v for k, v in check.items() if k != "details"})


def fairness_section(dyn: dict) -> str:
    lines = ["**Test Fairness**", ""]
    vf = (dyn or {}).get("verifyFairness")
    if not vf:
        lines.append("Check not run.")
        return "\n".join(lines)
    out = vf.get("output") or {}
    if vf.get("stale"):
        lines += ["_Note: this Test Fairness result is marked STALE by the platform._", ""]
    suggestions = out.get("coverageSuggestions") or []
    if suggestions:
        lines += [f"Coverage Suggestions ({len(suggestions)}) - Not Blockers", "",
                  "Advisory only — these don't affect the check result.", ""]
        for s in suggestions:
            lines += [s.get("area", ""), s.get("suggestion", ""), ""]
    elif out.get("message"):
        lines += [out["message"], ""]
    lines += ["Raw output:", "", json_block(out)]
    return "\n".join(lines)


def initial_check_warning_sections(validation: dict) -> list[str]:
    """Every initial/precheck with a non-PASS status, raw JSON included."""
    sections = []
    for group_name, group in (validation or {}).items():
        if not isinstance(group, dict):
            continue
        for check in group.get("checks") or []:
            status = (check.get("status") or "").upper()
            if status in ("PASS", "RUNNING", "PENDING", "QUEUED", "IN_PROGRESS") \
                    or check.get("id") in (PLAGIARISM_CHECK_ID, CONCISENESS_CHECK_ID):
                continue
            if not status and not check.get("details") and not check.get("message"):
                continue  # not run yet / nothing to report
            title = check.get("description") or check.get("id") or group_name
            lines = [f"**{title}**", "", f"Status: {status or 'UNKNOWN'}"]
            if group.get("stale"):
                lines.append("_Note: this check group is marked STALE by the platform._")
            if check.get("message"):
                lines += ["", check["message"]]
            payload = check.get("details")
            if payload is None:
                payload = {k: v for k, v in check.items() if k not in ("description",)}
            lines += ["", json_block(payload)]
            sections.append("\n".join(lines))
    return sections


def shipd_bot_section(comments: list | None, description: str,
                      validation: dict) -> str | None:
    """Shipd-bot description warnings + the conciseness check.

    A comment is shown when it is still open (unresolved), or when it was
    "resolved" but its flagged sentence is still present in the description.
    """
    parts = []

    picked, seen_anchors = [], set()
    for c in comments or []:
        if c.get("targetType") not in (None, "description"):
            continue
        anchor = (c.get("anchorContent") or "").strip()
        if anchor in seen_anchors:
            continue
        still_present = anchor and anchor.rstrip(";.,") in description
        if not c.get("resolved") or still_present:
            seen_anchors.add(anchor)
            picked.append(c)
    picked.sort(key=lambda c: c.get("selectionStart") or 0)

    if picked:
        lines = ["**Shipd Bot Description Warnings**", ""]
        for c in picked:
            quote = (c.get("anchorContent") or "").strip()
            lines.append(f'> "{quote}"')
            lines += ["", (c.get("body") or "").strip()]
            for reply in c.get("replies") or []:
                who = reply.get("authorName") or "reply"
                body = (reply.get("body") or "").strip()
                if body:
                    lines += ["", f"Reply ({who}): {body}"]
            resolved_note = " _(marked resolved, but the sentence is still in the description)_" \
                if c.get("resolved") else ""
            if resolved_note:
                lines[-1] = lines[-1] + resolved_note
            lines.append("")
        parts.append("\n".join(lines).rstrip())

    check, _ = find_check(validation, CONCISENESS_CHECK_ID)
    if check and (check.get("status") or "").upper() != "PASS":
        parts.append("**Conciseness Warnings**\n\n" + json_block(check.get("details") or {}))

    if not parts:
        return None
    return "\n\n".join(parts)


def dynamic_check_sections(dyn: dict, convex: Convex) -> list[str]:
    """Env Quality (+ trajectory) and any other failing dynamic check."""
    sections = []
    skip = {"verifyFairness", "crossRunAnalysis", "autoReview"}
    for key, title in DYNAMIC_CHECK_TITLES.items():
        if key in skip:
            continue
        check = (dyn or {}).get(key)
        if not check:
            continue
        out = check.get("output") or {}
        verdict = str(out.get("verdict") or "").upper()
        failed = (verdict and verdict not in ("PASS", "OK")) or out.get("pass") is False
        if not failed:
            continue

        lines = [f"**{title}**", ""]
        if check.get("stale"):
            lines += ["_Note: this check is marked STALE by the platform._", ""]
        lines.append(json_block(out))
        sections.append("\n".join(lines))

        if key == "environmentQuality" and check.get("jobId"):
            traj = convex.fetch_artifact("trajectory", check["jobId"])
            body = None
            if traj:
                try:
                    body = json_block(json.dumps(json.loads(traj), indent=2,
                                                 ensure_ascii=False), min_fence=4)
                except json.JSONDecodeError:
                    body = json_block(traj, min_fence=4)
            else:
                body = "_Trajectory artifact could not be fetched._"
            sections.append("**Agent Trajectory - Env Quality**\n\n" + body)
    return sections


# ─── previous-reviews.md ───

BAND_LABELS = {0: "Failing", 1: "Weak", 2: "Minor", 3: "Clean"}
FIELD_BAND_ORDER = [
    ("description", "Problem Description"),
    ("tests", "Tests"),
    ("solution", "Solution & Code"),
]


def _fmt_ts(ts) -> str:
    if not ts:
        return "unknown date"
    from datetime import datetime
    try:
        return datetime.fromtimestamp(ts / 1000).strftime("%Y-%m-%d %H:%M")
    except (ValueError, TypeError, OSError):
        return str(ts)


def _render_review_entry(r: dict) -> str:
    reviewer = r.get("reviewerName") or "Unknown reviewer"
    is_bot = reviewer.strip().lower() == "shipd bot"
    version = r.get("versionNumber")
    vlabel = f"v{int(version)}" if isinstance(version, (int, float)) else "v?"
    outcome = r.get("outcome") or "unknown"
    head = f"## {vlabel} — {reviewer}{' (Auto Review)' if is_bot else ''} — {outcome} — {_fmt_ts(r.get('submittedAt'))}"

    lines = [head, ""]
    if r.get("qualityScore") is not None:
        lines += [f"Quality score: {r['qualityScore']:g}", ""]

    bands = r.get("fieldBands")
    if isinstance(bands, dict) and bands:
        # New review layout: per-dimension bands (the old checklist is gone).
        for key, label in FIELD_BAND_ORDER:
            b = bands.get(key)
            if not isinstance(b, dict):
                continue
            band = b.get("band")
            band_i = int(band) if isinstance(band, (int, float)) else None
            band_label = BAND_LABELS.get(band_i, "")
            conf = (b.get("confidence") or "").title()
            header = f"{label} - ({band_i if band_i is not None else '?'}/3)"
            if band_label:
                header += f" {band_label}"
            if conf:
                header += f" · {conf} confidence"
            lines.append(header)
            if b.get("reasoning"):
                lines.append(b["reasoning"].strip())
            lines.append("")
        # Any band key outside the known order
        for key, b in bands.items():
            if key in dict(FIELD_BAND_ORDER) or not isinstance(b, dict):
                continue
            lines.append(f"{key} - ({b.get('band')}/3) · {(b.get('confidence') or '').title()} confidence")
            if b.get("reasoning"):
                lines.append(str(b["reasoning"]).strip())
            lines.append("")
        if r.get("otherNotes"):
            tags = r.get("otherNotesTags") or []
            lines.append("Other notes:" + (f" [{', '.join(tags)}]" if tags else ""))
            lines += ["", str(r["otherNotes"]).strip(), ""]
    elif r.get("feedback"):
        lines += [str(r["feedback"]).strip(), ""]

    # Reasoning: the shipd bot puts JSON here — render it as a JSON block.
    reasoning = r.get("reasoning")
    if isinstance(reasoning, str) and reasoning.strip():
        parsed = None
        try:
            parsed = json.loads(reasoning)
        except json.JSONDecodeError:
            pass
        if isinstance(parsed, (dict, list)):
            lines += [json_block(parsed), ""]
        elif not bands and reasoning.strip() != (r.get("feedback") or "").strip():
            lines += [f"Reasoning: {reasoning.strip()}", ""]

    if r.get("internalNotes"):
        lines += [f"Internal notes: {str(r['internalNotes']).strip()}", ""]
    return "\n".join(lines).rstrip()


def _render_manager_entry(m: dict) -> str:
    head = (f"## Manager — {m.get('managerName') or 'Unknown'} — "
            f"{m.get('verdict') or 'feedback'} — {_fmt_ts(m.get('createdAt'))}")
    meta = []
    if m.get("affectsScore"):
        meta.append("affects score")
    if m.get("previousStatus"):
        meta.append(f"previous status: {m['previousStatus']}")
    lines = [head, ""]
    if meta:
        lines += [f"({', '.join(meta)})", ""]
    lines += [str(m.get("comment") or "").strip()]
    return "\n".join(lines).rstrip()


def build_previous_reviews(convex: Convex, problem_id: str) -> str | None:
    """Merged timeline (oldest first) of past reviews + manager feedback."""
    reviews = convex.query("reviews:getReviewHistory", {"problemId": problem_id})
    manager = convex.query("managerReview:getManagerFeedbackHistory", {"problemId": problem_id})
    if reviews is None and manager is None:
        print("  ⚠️ review history could not be fetched")
        return None

    timeline = []
    for r in reviews or []:
        if isinstance(r, dict):
            timeline.append((r.get("submittedAt") or 0, "review", r))
    for m in manager or []:
        if isinstance(m, dict):
            timeline.append((m.get("createdAt") or 0, "manager", m))
    if not timeline:
        return None
    timeline.sort(key=lambda t: t[0])

    sections = [_render_review_entry(item) if kind == "review" else _render_manager_entry(item)
                for _ts, kind, item in timeline]
    return "# Previous Reviews\n\n" + "\n\n---\n\n".join(sections)


# ─── auto-review (new multi-agent orchestrator format) ───

def write_auto_review(out_dir: Path, convex: Convex, queries: dict):
    """auto-review.json — the complete auto-review data.

    The new auto review is a multi-agent orchestrator; its full payload
    (scope gate, per-dimension sub-reviews, agents evidence, synthesis) comes
    from orchestratorReview:getOrchestratorReview — new versions no longer
    expose an autoReview entry in runDynamicChecks at all, so the orchestrator
    is queried FIRST. Older versions fall back to the legacy output object.
    """
    dyn = queries.get("runDynamicChecks:getDynamicChecks") or {}
    auto = dyn.get("autoReview")  # legacy mirror; absent on new-format versions

    version_id = ((queries.get("problems:getWithVersion") or {}).get("version") or {}).get("_id")
    orch = convex.query("orchestratorReview:getOrchestratorReview",
                        {"versionId": version_id}) if version_id else None
    slots = (orch or {}).get("slots") or {}
    has_slots = any(isinstance(s, dict) for s in slots.values())

    if has_slots:
        synth = slots.get("synthesis") if isinstance(slots.get("synthesis"), dict) else {}
        stale = synth.get("stale")
        if stale is None and auto:
            stale = auto.get("stale")
        if stale:
            print("  ℹ️ auto-review: present but STALE — skipped (per policy)")
            return
        payload = {k: v for k, v in orch.items() if k != "isAdmin"}
        write_file(out_dir, "auto-review.json",
                   json.dumps(payload, indent=2, ensure_ascii=False))
        if not synth.get("output"):
            print(f"  ℹ️ auto-review: synthesis not finished yet "
                  f"(status={synth.get('status')}) — partial data written")
        stale_md = out_dir / "auto-review.md"
        if stale_md.exists():
            stale_md.unlink()
            print("  ℹ️ removed auto-review.md (merged into auto-review.json)")
        return

    # Legacy single-output format.
    if not auto:
        print("  ℹ️ auto-review: not run — skipped")
        return
    if auto.get("stale"):
        print("  ℹ️ auto-review: present but STALE — skipped (per policy)")
        return
    if auto.get("output"):
        legacy = (orch or {}).get("legacyAutoReview") or auto["output"]
        write_file(out_dir, "auto-review.json",
                   json.dumps(legacy, indent=2, ensure_ascii=False))
    else:
        print(f"  ℹ️ auto-review: status={auto.get('status')} with no output yet — skipped")


# ─── false-positive-evaluation.md ───

def _fp_verdict(signal: str | None) -> str:
    return {"false_positive": "❌ False positive",
            "true_positive": "✅ Genuine pass"}.get(signal or "", signal or "unknown")


def _fmt_duration(seconds) -> str:
    if not isinstance(seconds, (int, float)):
        return "?"
    seconds = int(seconds)
    return f"{seconds // 60}m {seconds % 60:02d}s" if seconds >= 60 else f"{seconds}s"


def _yes_no(val) -> str:
    return "Yes" if val else "No"


def _render_fp_adjudication(adj: dict) -> list[str]:
    head = f"### Adjudicator — {_fp_verdict(adj.get('signal'))}"
    if adj.get("confidence"):
        head += f" · {adj['confidence']} confidence"
    if adj.get("changedByPanel"):
        head += " · verdict changed by panel evidence"
    lines = [head, ""]
    if adj.get("skipped"):
        lines += ["_Adjudication was skipped._", ""]
        return lines
    if adj.get("feedback"):
        lines += [str(adj["feedback"]).strip(), ""]
    if adj.get("reasoning"):
        lines += ["**Probe re-run reasoning:**" if adj.get("reran") else "**Reasoning:**",
                  "", str(adj["reasoning"]).strip(), ""]
    if adj.get("independentReasoning") or adj.get("independentSignal"):
        lines += [f"**Independent read (before panel evidence):** "
                  f"{_fp_verdict(adj.get('independentSignal'))}", ""]
        if adj.get("independentReasoning"):
            lines += [str(adj["independentReasoning"]).strip(), ""]

    panel = adj.get("panelAssessment")
    if isinstance(panel, dict) and panel:
        trusted = set(adj.get("trustedRuns") or [])
        distrusted = set(adj.get("distrustedRuns") or [])
        lines += ["**Panel assessment (adjudicator's view of each judge):**", ""]
        for judge_label in sorted(panel):
            p = panel[judge_label] or {}
            trust = ("trusted" if judge_label in trusted
                     else "distrusted" if judge_label in distrusted else "—")
            bits = [f"trust: {trust}"]
            if "fairProbe" in p:
                bits.append(f"fair probe: {_yes_no(p['fairProbe'])}")
            if "discriminates" in p:
                bits.append(f"discriminates: {_yes_no(p['discriminates'])}")
            lines.append(f"- **{judge_label}** ({', '.join(bits)}) — "
                         f"{str(p.get('notes') or '').strip()}")
        lines.append("")
    if adj.get("tags"):
        lines += ["**Tags:** " + ", ".join(f"`{t}`" for t in adj["tags"]), ""]
    return lines


def _render_fp_judge(j: dict) -> list[str]:
    head = f"### {j.get('label') or 'judge'} — {_fp_verdict(j.get('signal'))}"
    if j.get("confidence"):
        head += f" · {j['confidence']} confidence"
    if j.get("fairness"):
        head += f" · probe fairness: {j['fairness']}"
    lines = [head, ""]
    if j.get("skipped"):
        lines += ["_This judge was skipped._", ""]
        return lines
    if j.get("quickSummary"):
        lines += [str(j["quickSummary"]).strip(), ""]
    feedback = str(j.get("feedback") or "").strip()
    if feedback and feedback != str(j.get("quickSummary") or "").strip():
        lines += ["**Details / suggested hardening:**", "", feedback, ""]

    facts = [f"**Discriminator found:** {_yes_no(j.get('foundDiscriminator'))}"]
    if j.get("discriminatingTestNames"):
        facts[-1] += " — " + ", ".join(f"`{t}`" for t in j["discriminatingTestNames"])
    if j.get("nFalsificationAttempts") is not None:
        facts.append(f"**Falsification attempts:** {int(j['nFalsificationAttempts'])}")
    if j.get("nRequirements") is not None:
        failed = int(j.get("nRequirementsFailed") or 0)
        facts.append(f"**Requirements checked:** {int(j['nRequirements'])} ({failed} failed)")
    if j.get("durationSeconds") is not None:
        facts.append(f"**Duration:** {_fmt_duration(j['durationSeconds'])}")
    lines += ["- " + " | ".join(facts[:1]),
              *(f"- {f}" for f in facts[1:]), ""]
    return lines


def build_false_positive_evaluation(convex: Convex, queries: dict) -> str | None:
    """Per-passing-run false-positive panel report (adjudicator + judges)."""
    problem = queries.get("problems:getWithVersion") or {}
    version_id = (problem.get("version") or {}).get("_id")
    if not version_id:
        return None
    fp = convex.query("fpReview:getFpCheckForVersion", {"versionId": version_id})
    if not isinstance(fp, dict):
        print("  ℹ️ false-positive check: not available — skipped")
        return None
    results = [r for r in fp.get("resultSummary") or [] if isinstance(r, dict)]
    if not results:
        print("  ℹ️ false-positive check: no evaluated runs yet — skipped")
        return None

    # Map runId -> UI run label ("Nova #7") from the rollouts list.
    label_by_id = {}
    for r in queries.get("runAgentRuns:getAgentRuns") or []:
        if isinstance(r, dict) and r.get("id"):
            label_by_id[r["id"]] = r.get("label")

    fp_count = sum(1 for r in results if r.get("finalSignal") == "false_positive")
    ok_icon = "✅" if fp.get("passed") else "❌"
    lines = [f"# {ok_icon} False-Positive Review Report", "",
             "> Passing runs must hold up under the false-positive review panel: each",
             "> evaluated passing run is probed by a judge panel plus an adjudicator.", "",
             "## Check Summary", ""]
    lines.append(f"- **Result:** `{(fp.get('state') or 'unknown').upper()}`"
                 + (" — a passing run was flagged as a false positive" if fp_count else ""))
    lines.append(f"- **Runs evaluated:** {len(results)} — "
                 f"false positives: {fp_count}, genuine passes: {len(results) - fp_count}")
    if fp.get("requestedAt"):
        lines.append(f"- **Requested:** {_fmt_ts(fp['requestedAt'])}")
    if fp.get("completedAt"):
        lines.append(f"- **Completed:** {_fmt_ts(fp['completedAt'])}")
    if fp.get("tokenCost") is not None:
        lines.append(f"- **Token cost:** {fp['tokenCost']:g}")

    # Current platform criterion (also flags staleness after task edits).
    for crit in (queries.get("runAgentRuns:getAgentRunCriteria") or {}).get("criteria") or []:
        if crit.get("id") == "noFalsePositives":
            lines.append(f"- **Criterion status:** {crit.get('status')} — {crit.get('detail')}")
            if crit.get("guidance"):
                lines.append(f"  - {crit['guidance']}")
            break
    lines.append("")

    for idx, r in enumerate(results, 1):
        run_id = r.get("runId") or ""
        label = label_by_id.get(run_id) or f"Agent #{idx}"
        head = f"## {label} — {_fp_verdict(r.get('finalSignal'))}"
        if r.get("finalConfidence"):
            head += f" · {r['finalConfidence']} confidence"
        lines += ["---", "", head, ""]
        meta = [f"**Run:** `{run_id}`"]
        if r.get("taskAgentCodename"):
            meta.append(f"**Agent:** {r['taskAgentCodename']}")
        meta.append(f"**Judge dissent:** {_yes_no(r.get('judgeDissent'))}")
        if r.get("durationSeconds") is not None:
            meta.append(f"**Panel duration:** {_fmt_duration(r['durationSeconds'])}")
        lines += ["- " + " | ".join(meta), ""]
        if r.get("skipped"):
            lines += ["_This run's evaluation was skipped._", ""]
            continue
        if isinstance(r.get("adjudication"), dict):
            lines += _render_fp_adjudication(r["adjudication"])
        for j in r.get("judges") or []:
            if isinstance(j, dict):
                lines += _render_fp_judge(j)

    return "\n".join(lines).rstrip()


# ─── repo-fit.md (Scope Gate) ───

def _scope_icon(verdict: str | None) -> str:
    return {"pass": "✅", "fail": "❌"}.get((verdict or "").lower(), "•")


def _render_gate_findings(findings: list) -> list[str]:
    findings = [f for f in findings or [] if isinstance(f, dict)]
    if not findings:
        return []
    lines = [f"## Findings ({len(findings)})", ""]
    for f in findings:
        head = f"### {f.get('category', 'finding')}"
        if f.get("severity"):
            head += f" — {f['severity']} severity"
        lines += [head, ""]
        claim = f.get("claim") or f.get("description")
        if claim:
            lines.append(f"- **Claim:** {claim}")
        ev = f.get("evidence")
        if isinstance(ev, dict):
            where = ev.get("repoPath") or ev.get("artifactFile") or ev.get("runId") or ""
            if ev.get("line") is not None:
                where += f" line {int(ev['line'])}"
            quote = (ev.get("quote") or "").strip()
            bits = [b for b in (where.strip(), f'"{quote}"' if quote else "") if b]
            if bits:
                lines.append(f"- **Evidence:** {' — '.join(bits)}")
        elif isinstance(ev, str) and ev.strip():
            lines.append(f"- **Evidence:** {ev.strip()}")
        if f.get("expected"):
            lines.append(f"- **Expected:** {f['expected']}")
        if f.get("whyItMatters"):
            lines.append(f"- **Why it matters:** {f['whyItMatters']}")
        lines.append("")
    return lines


def _render_execution_log(log: list) -> list[str]:
    """The gh commands the gate ran to check originality / repo alignment."""
    entries = [e for e in log or [] if isinstance(e, dict)]
    if not entries:
        return []
    lines = [f"## Investigation Log ({len(entries)} commands)", ""]
    for e in sorted(entries, key=lambda x: x.get("seq", 0)):
        seq = int(e["seq"]) if isinstance(e.get("seq"), (int, float)) else "-"
        meta = [str(e.get("bucket") or "?")]
        if e.get("ok") is not None:
            meta.append("ok" if e.get("ok") else "FAILED")
        if isinstance(e.get("durationMs"), (int, float)):
            meta.append(f"{int(e['durationMs'])} ms")
        if e.get("rateLimited"):
            meta.append("rate-limited")
        command = (e.get("command") or "").strip()
        lines.append(f"**#{seq}** · {' · '.join(meta)} — `{command}`")
        out = (e.get("outputSummary") or "").strip()
        if out:
            if "\n" in out or len(out) > 120:
                lines += ["", "```", out, "```"]
            else:
                lines.append(f"→ `{out}`")
        lines.append("")
    return lines


def build_repo_fit(convex: Convex, queries: dict) -> str | None:
    """Scope Gate / repo-fit report: is the task original and repo-aligned?"""
    problem = queries.get("problems:getWithVersion") or {}
    version_id = (problem.get("version") or {}).get("_id")
    if not version_id:
        return None
    sg = convex.query("scopeGate:getScopeGate", {"versionId": version_id})
    if not isinstance(sg, dict):
        print("  ℹ️ repo-fit / scope gate: not available — skipped")
        return None

    # Prefer the run that produced the standing verdict; fall back to current.
    run = sg.get("verdictRun") if isinstance(sg.get("verdictRun"), dict) else None
    if not run or not isinstance(run.get("output"), dict):
        run = sg.get("current") if isinstance(sg.get("current"), dict) else None
    out = (run or {}).get("output")
    if not isinstance(out, dict):
        if sg.get("inFlight"):
            print("  ℹ️ repo-fit / scope gate: currently running — skipped")
        else:
            print("  ℹ️ repo-fit / scope gate: no completed run — skipped")
        return None

    verdict = out.get("verdict") or sg.get("latestVerdict")
    conf = f" · {out['confidence']} confidence" if out.get("confidence") else ""
    lines = [f"# {_scope_icon(verdict)} Repo-Fit / Scope Gate — {(verdict or 'unknown').upper()}", "",
             "> Verifies your task is original and fits the repo before the rest of the funnel opens.",
             "", "## Summary", "",
             f"- **Verdict:** `{(verdict or 'unknown').upper()}`{conf}"]
    if sg.get("fresh") is False:
        lines.append("- **⚠️ STALE:** the task changed since this scope-gate ran")
    elif sg.get("fresh") is True:
        lines.append("- **Fresh:** Yes (reflects the current task version)")
    if sg.get("inFlight"):
        lines.append("- **Note:** a newer scope-gate run is currently in flight")
    if run.get("completedAt"):
        lines.append(f"- **Completed:** {_fmt_ts(run['completedAt'])}")
    stats = [f"{int(out[k])} {lbl}" for k, lbl in
             [("ghCallCount", "gh calls"), ("ghSearchCount", "gh searches"),
              ("upstreamRequestCount", "upstream requests")]
             if isinstance(out.get(k), (int, float))]
    if isinstance(out.get("executionTimeSeconds"), (int, float)):
        stats.append(f"{out['executionTimeSeconds']:g}s")
    if stats:
        lines.append(f"- **Investigation:** {' · '.join(stats)}")
    lines.append("")

    if out.get("summary"):
        lines += [str(out["summary"]).strip(), ""]
    if out.get("reasoning"):
        lines += ["## Reasoning", "", str(out["reasoning"]).strip(), ""]
    lines += _render_gate_findings(out.get("findings"))
    lines += _render_execution_log(out.get("executionLog"))

    history = [h for h in sg.get("history") or [] if isinstance(h, dict)]
    if history:
        lines += [f"## Run History ({len(history)})", "",
                  "| # | Verdict | Status | Completed | Refunded | Job |",
                  "|---|---------|--------|-----------|----------|-----|"]
        for i, h in enumerate(sorted(history, key=lambda x: x.get("createdAt") or 0), 1):
            lines.append(f"| {i} | {h.get('verdict', '-')} | {h.get('status', '-')} | "
                         f"{_fmt_ts(h.get('completedAt'))} | {_yes_no(h.get('refunded'))} | "
                         f"`{h.get('jobId', '-')}` |")
        lines.append("")

    return "\n".join(lines).rstrip()


# ─── verifier-audit/ (Verifier Completeness Audit) ───
#
# The new pre-rollout check that replaced the old post-rollout FP check. It
# probes whether a broken-but-plausible solution could still pass the current
# tests and, if so, proposes a fix to the test patch. Everything lives in the
# SSR runDynamicChecks blob under `verifierIncompleteness` plus the original and
# proposed test-patch strings — so no extra fetching is needed.

_GAP_SEVERITY = {"crash": "CRASH", "wrong_result": "WRONG RESULT", "cosmetic": "COSMETIC"}


def _patch_added_content(patch: str) -> dict:
    """Map file path -> the '+' (added) lines of its diff.

    The verifier test patches add new fixture/test files, so the added lines are
    the full resulting file content. Comparing this per file reproduces the UI's
    new / modified / carried-over classification (which is content-based, not
    raw-patch-text based, so index hashes and line numbers don't create noise).
    """
    files = {}
    for m in re.finditer(r"diff --git a/(\S+) b/(\S+)\n(.*?)(?=\ndiff --git |\Z)", patch or "", re.S):
        path = m.group(2)
        content = [ln[1:] for ln in m.group(3).splitlines()
                   if ln.startswith("+") and not ln.startswith("+++")]
        files[path] = "\n".join(content)
    return files


def _verifier_patch_delta(orig_patch: str, prop_patch: str):
    """Classify proposed files as new/modified/carried and build a git-style diff.

    The diff is a standard unified diff of the resulting test-file contents, so
    applying it on top of the task's test.patch reproduces the full proposed test
    patch — that is why the two full patches are not stored separately.
    """
    import difflib
    o = _patch_added_content(orig_patch)
    p = _patch_added_content(prop_patch)
    new = sorted(f for f in p if f not in o)
    modified = sorted(f for f in p if f in o and p[f] != o[f])
    carried = sorted(f for f in p if f in o and p[f] == o[f])

    diff_lines = []
    for f in sorted(new + modified):
        before = o.get(f, "").splitlines()
        after = p[f].splitlines()
        hunks = list(difflib.unified_diff(before, after, lineterm=""))[2:]  # drop ---/+++ stubs
        diff_lines.append(f"diff --git a/{f} b/{f}")
        if f in new:
            diff_lines += ["new file mode 100644", "--- /dev/null", f"+++ b/{f}"]
        else:
            diff_lines += [f"--- a/{f}", f"+++ b/{f}"]
        diff_lines += hunks
    return new, modified, carried, "\n".join(diff_lines)


def _render_verifier_audit(vi: dict, new: list, modified: list, carried: list) -> str:
    out = vi.get("output") or {}
    verdict = (out.get("verdict") or "unknown").upper()
    icon = {"INCOMPLETE": "⚠️", "COMPLETE": "✅"}.get(verdict, "•")
    gaps = [g for g in out.get("gaps") or [] if isinstance(g, dict)]
    demonstrated = [g for g in gaps if g.get("demonstrated")]

    lines = [f"# {icon} Verifier Completeness Audit — {verdict}", "",
             "> Probes whether a broken-but-plausible solution could still pass the current",
             "> tests — BEFORE any rollouts. When it finds gaps it also proposes a fix to the",
             "> test patch. (This check replaced the old post-rollout false-positive check.)",
             "", "## Verdict & Summary", ""]
    lines.append(f"- **Verdict:** {verdict}"
                 + (f" — {len(demonstrated)} demonstrated gap(s)" if demonstrated else ""))
    if vi.get("stale"):
        lines.append("- **⚠️ STALE:** the task changed since this audit ran")
    if vi.get("completedAt"):
        lines.append(f"- **Completed:** {_fmt_ts(vi['completedAt'])}")
    effort = []
    if out.get("agentSteps") is not None:
        effort.append(f"{out['agentSteps']} steps")
    if out.get("agentMessages") is not None:
        effort.append(f"{out['agentMessages']} messages")
    if isinstance(out.get("executionTimeSeconds"), (int, float)):
        effort.append(f"{out['executionTimeSeconds']:.0f}s")
    if effort:
        lines.append(f"- **Audit effort:** {' · '.join(effort)}")
    if vi.get("jobId"):
        lines.append(f"- **Job:** `{vi['jobId']}`")
    lines.append("")
    if out.get("summary"):
        lines += [str(out["summary"]).strip(), ""]

    # ── Decision guide (for the task-crafting agent) ──
    lines += ["## What to do with this (decision guide)", ""]
    if demonstrated:
        lines += [
            f"The audit demonstrated **{len(demonstrated)} gap(s)** where a plausible but broken "
            "solution still passes the current tests. On the platform you can:", "",
            "- **Accept as-is** — apply the audit's proposed test patch verbatim. "
            "`proposed-changes.diff` shows exactly what it adds/changes on top of the task's "
            "`test.patch`. ⚠️ Accepting re-stales your other checks, so do it early.",
            "- **Accept with edits** — take `proposed-changes.diff` as the starting point, adjust it, "
            "then apply. Best when the proposed tests are close but over- or under-shoot the contract.",
            "- **Bypass** — keep your current tests; the reviewer is notified. Choose this only if a "
            "gap targets behavior the task deliberately leaves unspecified — justify it in the note.", "",
            "**How to judge each gap:** weigh its severity (crash > wrong result > cosmetic) and "
            "plausibility (how likely a real solver writes that broken code), then read its "
            "broken-implementation and probe. A high-plausibility crash/wrong-result gap on a stated "
            "requirement is a real hole — prefer accept (or accept-with-edits). A gap that only bites "
            "genuinely unspecified behavior is a candidate for bypass.", ""]
    else:
        lines += ["The audit found no demonstrated gaps — the current verifier looks complete. "
                  "No action needed.", ""]

    lines += ["Files here:",
              "- `verifier-audit.md` — this report (complete; use it as the source of truth)"]
    if modified or new:
        lines.append(f"- `proposed-changes.diff` — a git-style diff of exactly what the platform "
                     f"proposes to change ({len(new)} new, {len(modified)} modified, "
                     f"{len(carried)} carried over). Apply it on top of the task's `test.patch` "
                     "to get the full proposed test suite.")
    lines.append("")

    # ── Proposed-patch validation ──
    pv = out.get("patchValidation")
    if isinstance(pv, dict):
        lines += ["## Proposed-Patch Validation", "",
                  "The platform verified the proposed patch before offering it:", ""]
        for key, label in [("appliesCleanly", "Applies cleanly"),
                           ("baseTestsPass", "Base tests pass (without solution)"),
                           ("updatedNewTestsFailOnCleanRepo", "New tests fail on clean repo (without solution)"),
                           ("referencePassesUpdatedSuite", "Reference passes the updated suite")]:
            if key in pv:
                lines.append(f"- {'✅' if pv[key] else '❌'} {label}")
        if pv.get("log"):
            lines += ["", "```", str(pv["log"]).strip(), "```"]
        lines.append("")

    # ── Demonstrated gaps ──
    reqs_by_id = {r.get("id"): r for r in out.get("requirements") or [] if isinstance(r, dict)}
    if gaps:
        lines += [f"## Demonstrated Gaps ({len(gaps)})", ""]
        for i, g in enumerate(gaps, 1):
            sev = (g.get("severity") or "").lower()
            badges = [_GAP_SEVERITY.get(sev, sev.upper() or "GAP")]
            if g.get("plausibility"):
                badges.append(f"{g['plausibility']} plausibility")
            badges.append("demonstrated" if g.get("demonstrated") else "not demonstrated")
            lines += [f"### Gap {i} — " + " · ".join(badges), ""]
            if g.get("title"):
                lines += [f"**{g['title']}**", ""]
            if g.get("description"):
                lines += [str(g["description"]).strip(), ""]
            rids = g.get("requirementIds") or []
            if rids:
                lines.append("**Violates:**")
                for rid in rids:
                    r = reqs_by_id.get(rid)
                    lines.append(f"- `{rid}`" + (f" — {r.get('text')}" if r and r.get("text") else ""))
                lines.append("")
            if g.get("remedyTestNames"):
                lines += ["**Remedy tests (added/updated to close it):** "
                          + ", ".join(f"`{t}`" for t in g["remedyTestNames"]), ""]
            if g.get("wrongImplDescription"):
                lines += ["**Broken implementation (what a plausible solver does wrong):**", "",
                          str(g["wrongImplDescription"]).strip(), ""]
            if g.get("probeDescription"):
                lines += ["**Probe (how the audit demonstrated the gap):**", "",
                          str(g["probeDescription"]).strip(), ""]
            if g.get("evidence"):
                lines += ["**Evidence:**", "", str(g["evidence"]).strip(), ""]
            lines += ["---", ""]

    # ── Requirements coverage ──
    reqs = [r for r in out.get("requirements") or [] if isinstance(r, dict)]
    if reqs:
        gapped = {}  # requirement id -> [gap numbers]
        for i, g in enumerate(gaps, 1):
            for rid in g.get("requirementIds") or []:
                gapped.setdefault(rid, []).append(i)
        n_gapped = sum(1 for r in reqs if r.get("id") in gapped)
        lines += [f"## Requirements Coverage ({len(reqs)} total — "
                  f"{len(reqs) - n_gapped} covered, {n_gapped} gapped)", ""]
        tiers = {}
        for r in reqs:
            tiers.setdefault(r.get("tier"), []).append(r)
        for tier in sorted(tiers, key=lambda t: (t is None, t)):
            trs = tiers[tier]
            tg = sum(1 for r in trs if r.get("id") in gapped)
            tier_lbl = f"Tier {tier}" if tier is not None else "Untiered"
            lines += [f"### {tier_lbl} — {len(trs) - tg} covered, {tg} gapped", ""]
            for r in trs:
                rid = r.get("id")
                if rid in gapped:
                    mark = f"⚠️ **{rid}** (gap {', '.join(map(str, gapped[rid]))})"
                else:
                    mark = f"✅ {rid}"
                lines.append(f"- {mark} — {r.get('text', '')}")
                if r.get("sourceQuote"):
                    lines.append(f"  - _spec: \"{str(r['sourceQuote']).strip()}\"_")
            lines.append("")

    return "\n".join(lines).rstrip()


def write_verifier_audit(out_dir: Path, queries: dict):
    """Write the Verifier Completeness Audit into a verifier-audit/ subdirectory.

    Everything comes from the SSR runDynamicChecks blob: the `verifierIncompleteness`
    slot plus the original and proposed test-patch strings.
    """
    dyn = queries.get("runDynamicChecks:getDynamicChecks") or {}
    vi = dyn.get("verifierIncompleteness")
    if not isinstance(vi, dict) or not isinstance(vi.get("output"), dict):
        print("  ℹ️ verifier completeness audit: not run — skipped")
        return
    if vi.get("stale"):
        print("  ℹ️ verifier completeness audit: present but STALE — skipped (per policy)")
        return

    out = vi["output"]
    orig_patch = dyn.get("_verifierIncompletenessOriginalTestPatch") or ""
    prop_patch = dyn.get("_verifierIncompletenessProposedTestPatch") or ""

    sub = out_dir / "verifier-audit"
    sub.mkdir(parents=True, exist_ok=True)

    # Store only the proposed CHANGES: the task's test.patch already holds the
    # original, and applying this diff on top of it reproduces the full proposed
    # test patch — so keeping the two full patches would be redundant.
    new = modified = carried = []
    if prop_patch and orig_patch:
        new, modified, carried, diff_text = _verifier_patch_delta(orig_patch, prop_patch)
        if diff_text.strip():
            write_file(sub, "proposed-changes.diff", diff_text)

    write_file(sub, "verifier-audit.md",
               _render_verifier_audit(vi, list(new), list(modified), list(carried)))


# ──────────────────────────────────────────────────────────────────────────
# Main pipeline
# ──────────────────────────────────────────────────────────────────────────

def run(url: str, dir_override: str | None, clone_mode: str = "ask"):
    t0 = time.time()

    print("Step 1: Fetching page (SSR state) ...")
    html = fetch_html(url)
    print(f"  ✅ {len(html):,} bytes in {time.time() - t0:.1f}s")

    print("Step 2: Extracting embedded query state via Node ...")
    queries = extract_queries(html)
    problem = queries.get("problems:getWithVersion")
    if not isinstance(problem, dict) or not problem.get("version"):
        sys.exit("❌ Challenge data missing from the page state — the URL may be "
                 "wrong, you may no longer have access to this challenge, or the "
                 "session expired (try --login)")
    version = problem["version"]
    title = (problem.get("title") or "Untitled task").strip()
    print(f"  ✅ {len(queries)} queries | title: {title}")

    validation = queries.get("stages:getValidationResults") or {}
    dyn = queries.get("runDynamicChecks:getDynamicChecks") or {}
    criteria_data = queries.get("runAgentRuns:getAgentRunCriteria") or {}
    convex = Convex(queries.get("convexToken"), html)

    out_dir = Path.cwd() / (dir_override or dir_name_from_title(title))
    out_dir.mkdir(parents=True, exist_ok=True)
    print(f"\nWriting into: {out_dir}/")

    # ── simple artifacts ──
    category = version.get("category") or problem.get("category") or ""
    write_file(out_dir, "description.md",
               f"# {title}\n\n**Category**: {CATEGORY_LABELS.get(category, category)}\n\n"
               + (version.get("description") or "").rstrip())
    write_file(out_dir, "base_commit.txt",
               f"{version.get('githubCommitHash', '')}\n{version.get('githubRepoUrl', '')}")
    write_file(out_dir, "dockerfile", version.get("dockerfile") or "")
    write_file(out_dir, "solution.patch", version.get("solutionPatch") or "")
    write_file(out_dir, "test.patch", version.get("testPatch") or "")
    write_file(out_dir, "quick-setup.sh", build_quick_setup(problem))

    # ── prechecks.md ──
    print("Step 3: Building prechecks.md ...")
    comments = convex.query("inlineComments:getForProblem",
                            {"problemId": problem["_id"]})
    if comments is None:
        print("  ⚠️ shipd-bot inline comments could not be fetched")

    sections = [task_type_block(criteria_data),
                plagiarism_section(validation),
                fairness_section(dyn)]
    sections += initial_check_warning_sections(validation)
    bot = shipd_bot_section(comments, version.get("description") or "", validation)
    if bot:
        sections.append(bot)
    sections += dynamic_check_sections(dyn, convex)
    write_file(out_dir, "prechecks.md", "\n\n---\n\n".join(sections))

    # ── previous-reviews.md ──
    print("Step 4: Building previous-reviews.md ...")
    prev = build_previous_reviews(convex, problem["_id"])
    if prev:
        write_file(out_dir, "previous-reviews.md", prev)
    else:
        print("  ℹ️ no previous reviews — skipped")

    # ── auto-review (non-stale only; full orchestrator payload) ──
    write_auto_review(out_dir, convex, queries)

    # ── false-positive-evaluation.md (legacy FP check — kept while it still runs) ──
    print("Step 5: Building false-positive-evaluation.md ...")
    fp_report = build_false_positive_evaluation(convex, queries)
    if fp_report:
        write_file(out_dir, "false-positive-evaluation.md", fp_report)

    # ── repo-fit.md (Scope Gate) ──
    print("Step 6: Building repo-fit.md ...")
    repo_fit = build_repo_fit(convex, queries)
    if repo_fit:
        write_file(out_dir, "repo-fit.md", repo_fit)

    # ── verifier-audit/ (Verifier Completeness Audit — the new pre-rollout check) ──
    print("Step 7: Building verifier-audit/ ...")
    write_verifier_audit(out_dir, queries)

    print(f"\n✅ Artifacts done in {time.time() - t0:.1f}s -> {out_dir}")

    clone_repo(out_dir, version, mode=clone_mode)


def clone_repo(out_dir: Path, version: dict, mode: str = "ask"):
    """Clone the task repo into the review directory (foreground, Ctrl+C-able).

    mode: "ask" (y/n prompt), "always" (--clone), or "never" (--no-clone).
    """
    if mode == "never":
        return
    repo_url = version.get("githubRepoUrl")
    commit = version.get("githubCommitHash")
    if not repo_url:
        return
    repo_name = repo_url.rstrip("/").split("/")[-1].removesuffix(".git") or "repo"
    repo_dir = out_dir / repo_name
    if repo_dir.exists():
        print(f"ℹ️ repo directory already exists ({repo_name}/) — clone skipped")
        return

    if mode == "ask":
        if not sys.stdin.isatty():
            print(f"ℹ️ non-interactive run — clone skipped "
                  f"(use --clone to clone {repo_name}/ automatically)")
            return
        try:
            answer = input(f"\nClone {repo_url} into {repo_name}/ now? [Y/n] ")
        except (EOFError, KeyboardInterrupt):
            print("\nℹ️ clone skipped")
            return
        if answer.strip().lower() in ("n", "no"):
            print("ℹ️ clone skipped")
            return

    print(f"\nCloning {repo_url} -> {repo_name}/ (Ctrl+C to skip) ...")
    t0 = time.time()
    try:
        subprocess.run(["git", "clone", "--recurse-submodules", repo_url, repo_name],
                       cwd=out_dir, check=True)
        if commit:
            subprocess.run(["git", "-C", repo_name, "checkout", "--detach", commit],
                           cwd=out_dir, check=True)
        print(f"✅ Repo cloned at base commit in {time.time() - t0:.1f}s")
    except KeyboardInterrupt:
        print("\n⚠️ Clone interrupted — all other artifacts are already written. "
              f"Remove the partial {repo_name}/ directory (if any) before re-cloning.")
    except subprocess.CalledProcessError as exc:
        print(f"⚠️ Clone failed (exit {exc.returncode}) — all other artifacts are "
              "already written.")


def main():
    parser = argparse.ArgumentParser(description="Shipd.ai challenge fetcher")
    parser.add_argument("--url", type=str, help="Shipd challenge URL")
    parser.add_argument("--name", type=str, help="Override the output directory name")
    parser.add_argument("--clone", action="store_true",
                        help="Clone the task repo without asking")
    parser.add_argument("--no-clone", action="store_true",
                        help="Never clone the task repo (no question asked)")
    parser.add_argument("--login", action="store_true", help="Open a browser to log in")
    args = parser.parse_args()

    if args.login:
        login(args.url)
    elif args.url:
        mode = "never" if args.no_clone else "always" if args.clone else "ask"
        run(args.url, args.name, clone_mode=mode)
    else:
        parser.print_help()


if __name__ == "__main__":
    main()
