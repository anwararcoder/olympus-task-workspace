# Hybrid Cloud Workflow — Multi-Account Codespace Forge Pool

> Companion to `WORKFLOW.md`. Editing, git history, task artifacts, AI sessions,
> and durable evidence remain local. Only expensive Docker builds and tests run
> remotely.
>
> **Status: LIVE and verified on 2026-07-31.** Three authorized GitHub identities
> each have a separately owned `standardLinux32gb` primary Codespace. Use
> `scripts/verify-remote.sh <task-dir> --account <login>` from the
> `Shipd - Olympus` root.

---

## Agent handoff — start here

When you ask an agent to verify, reproduce, or debug a task, give it this file.
The agent must read it completely, then:

1. keep all edits and durable evidence local;
2. choose `Zeyad2003`, `Zeyad-Nasef`, or `ZeyadNasef` explicitly;
3. choose the `primary` slot unless a documented additional slot is needed, and
   check that forge is not running another task;
4. use `scripts/verify-remote.sh` for a normal four-state run, or the documented
   interactive flow for a special reproduction;
5. inspect and copy results locally;
6. clean only its own remote namespace and stop the forge only when no other
   container is running.

There are only two operational files behind this guide:

- `scripts/verify-remote.sh` — performs the clean-room four-state run;
- `scripts/codespaces.conf` — maps each authorized account to its owned forge.

There is no separate per-account verifier or legacy name file. Do not invent a
third source of truth.

## The one-line mental model

**Work locally; explicitly choose a mapped account-owned Codespace when real
Docker horsepower is needed.**

```text
LOCAL LAPTOP (authoritative)                 GITHUB CODESPACE FORGE POOL (disposable)
────────────────────────────                 ─────────────────────────────────────────
task history, patches, reviews      ┌──────► Zeyad2003 pool
Codex/Claude session and memory ── gh ├──────► Zeyad-Nasef pool
source editing and reasoning        └──────► ZeyadNasef pool
result XMLs and final evidence ◄──────────── clean clone + Docker + four-state
```

All mapped forges perform the same job. They do not sync remote files with each
other, and none is a source of truth. Every run starts from the task's local
base SHA and patches; any result worth keeping comes back to the local task
directory.

This workflow deliberately remains on GitHub Codespaces. It does not add an
Azure or DigitalOcean VM, so the established `gh` commands and remote behavior
stay the same.

## What stays local

- Olympus task and review directories, including their git history.
- Source snapshots, solution/test edits, patches, and Dockerfiles.
- Descriptions, plans, reviews, false-positive evaluations, and lessons.
- Codex/Claude configuration, sessions, and memory.
- Final four-state XMLs under `<task-dir>/.verify/out/`.

Only `docker build`, container execution, and targeted environment debugging
need to run on a forge.

## Forge pool — current facts

The private repository is `Zeyad2003/olympus-forge`. It intentionally has no
custom devcontainer: the default Codespaces image supplies Docker and SSH. Do
not add a Docker-in-Docker devcontainer feature; the earlier attempt fell back
to a recovery container without the required Docker environment.

The non-secret source of truth is `scripts/codespaces.conf`. Its columns are
`GitHub account`, `slot`, and `Codespace name`; each account/slot pair and each
Codespace name must be unique:

| GitHub account | Slot | Owned Codespace | Machine | Normal state |
| --- | --- | --- | --- | --- |
| `Zeyad2003` | `primary` | `curly-adventure-wpjp69v54j2gx9` | `standardLinux32gb` | stopped |
| `Zeyad-Nasef` | `primary` | `olympus-forge---zeyad-nasef-g44vv9gxpgxg29r69` | `standardLinux32gb` | stopped |
| `ZeyadNasef` | `primary` | `olympus-forge---zeyadnasef-4qgw4qvq9qpgf7p7g` | `standardLinux32gb` | stopped |

The `Zeyad-Nasef` and `ZeyadNasef` primary forges were verified with Docker
server `29.3.0-1` and warmed with
`public.ecr.aws/d3j8x8q7/olympus-base-jvm:latest`, digest
`sha256:95a2911ffba3923dd92f7f03b0abbd803993ceb8d895d74ad23272d86e099999`.
The new `ZeyadNasef` forge had 15 GB free after warming.

`Zeyad2003` also owns the stopped, unmapped
`solid-space-invention-wjvpgj5pwqjh9r6w`. It was deliberately not deleted:
deletion destroys its remote filesystem and is not required for this setup.
Inspect it separately before deciding whether to delete it.

## Identity and credential model

Each Codespace belongs to the account that created it. Use that same account's
credential to list, start, SSH to, copy files to, stop, or delete it.

All three logins are stored in the local GitHub CLI keyring. The verifier does not
run `gh auth switch`. Instead, for each GitHub command it:

1. selects a login;
2. retrieves that login's stored credential with `gh auth token --user`;
3. scopes the credential to that one `gh` process through `GH_TOKEN`;
4. confirms `gh api user` resolves to the selected login;
5. uses only the Codespace mapped to that login.

No credential is stored in `scripts/codespaces.conf`, printed by the verifier,
or exported globally. This also prevents one terminal's interactive account
switch from silently redirecting an automated run in another terminal.

Prerequisites for every mapped account:

- GitHub CLI authenticated with the `codespace` scope.
- Access to the private `Zeyad2003/olympus-forge` repository.
- Codespaces enabled for that account.

Check the stored accounts without exposing credentials:

```bash
gh auth status --hostname github.com
```

Never use `gh auth status --show-token`, and never place a token in a task file,
shell history, configuration map, or review artifact.

## Automated daily use

### Select a forge explicitly

The clearest form is `--account`:

```bash
scripts/verify-remote.sh <task-dir> --account Zeyad-Nasef
scripts/verify-remote.sh <task-dir> --account Zeyad2003
scripts/verify-remote.sh <task-dir> --account ZeyadNasef
```

For several consecutive commands, select once in the environment:

```bash
export FORGE_ACCOUNT=Zeyad-Nasef
scripts/verify-remote.sh <task-dir>
```

Account selection precedence is:

1. `--account <login>`
2. `FORGE_ACCOUNT=<login>`
3. the currently active GitHub CLI account

Slot selection precedence is:

1. `--slot <name>`
2. `FORGE_SLOT=<name>`
3. `primary`

The CLI flag therefore safely overrides a stale environment selection. An
unknown account, a missing credential, a duplicate map row, or an identity
mismatch stops before any Codespace command.

### When one account's allowance is unavailable

Do not silently fail over: the failed command and its account are evidence.
Select the other mapped account explicitly and rerun the same local task:

```bash
scripts/verify-remote.sh <task-dir> --account Zeyad2003
# If GitHub rejects that account's usage:
scripts/verify-remote.sh <task-dir> --account Zeyad-Nasef
# If that account is also unavailable:
scripts/verify-remote.sh <task-dir> --account ZeyadNasef
```

Nothing needs to be copied between remote machines. The verifier sends
the same local patches to a fresh clone at the same base SHA, so switching the
selected forge does not change the task state.

### Supported verifier flags

```bash
scripts/verify-remote.sh <task-dir> \
  [--account <github-login>] [--slot <slot-name>] \
  [--url <repo-url>] [--legacy]
```

- `<task-dir>` contains `test-*.patch`, `solution-*.patch`, `Dockerfile-*`, and
  `BASE_COMMIT-*.txt`.
- `--url` supplies the upstream repository URL when line 2 of the base-commit
  file does not contain it.
- `--legacy` uses the old positional `./test.sh base|new` interface.
- `--account` selects the account-owned forge without changing global `gh`
  state.
- `--slot` selects a named forge for that account; omission means `primary`.

The verifier:

1. validates the selected identity and account mapping;
2. starts the selected Codespace on the first SSH command if needed;
3. copies only the patches and Dockerfile;
4. fresh-clones the upstream repository at the exact base SHA;
5. builds and runs the four states with `--network none`;
6. copies available XMLs to `<task-dir>/.verify/out/`.

The expected states are:

| State | Expected result |
| --- | --- |
| base + test patch | PASS |
| new + test patch | FAIL for the intended missing behavior |
| base + test + solution patches | PASS |
| new + test + solution patches | PASS |

## The normal task loop

1. Analyze history and edit the task locally.
2. Generate or update the test and solution patches locally.
3. Select one account and normally its `primary` slot, then run
   `verify-remote.sh`.
4. Read the returned output/XML locally, reason about the failure, and edit
   locally again.
5. Repeat on the same forge while iterating, select another account when quota
   is unavailable, or select another slot when the account still has quota but
   its primary is occupied.
6. Confirm no other task container is running, then stop the used forge when
   the verification/debugging batch is finished.
7. Keep all durable evidence, lessons, and final patches locally.

Run only one verification for the same task name on a given forge at a time;
the runs would otherwise share `~/verify/<task-name>`. Mapped forges are
independent, but every running forge consumes its owning account's compute
allowance.

## Shared-forge safety

Before a heavy run or interactive debugging session, switch to the intended
account, resolve its mapped forge, and inspect activity and disk state:

```bash
ACCOUNT=Zeyad-Nasef
SLOT=primary
gh auth switch --hostname github.com --user "$ACCOUNT"
test "$(gh api user --jq .login)" = "$ACCOUNT"
CS=$(awk -v account="$ACCOUNT" -v slot="$SLOT" \
  '$1 == account && $2 == slot { print $3 }' scripts/codespaces.conf)
gh codespace ssh -c "$CS" -- 'docker ps; df -h /; docker system df'
```

- If another task's container is running, choose an idle primary from another
  account first. If parallel isolation is still needed and the selected account
  has quota, create a named temporary slot using the procedure below.
- Touch only `~/verify/<your-task>`, `olympus-verify-<your-task>-*` images, and
  volumes created for that task.
- Never run `docker system prune -a`; it destroys shared warm images. Consider
  builder-cache cleanup only when disk is critical and no other task is active.
- Keep long work in the foreground under a live SSH session. Do not leave a
  detached job whose Codespace may idle-stop underneath it.
- After preserving the local output, remove only your finished remote task
  directory/images. Run `docker ps` again and stop the forge only when it is
  empty.

## Multiple Codespaces per account

GitHub supports more than one Codespace for the same repository or branch, but
the maximum number created and running is not one universal published value;
it varies by account and policy. GitHub reports when a creation or start limit
has been reached. See GitHub's
[Codespaces lifecycle](https://docs.github.com/en/codespaces/about-codespaces/understanding-the-codespace-lifecycle)
and [included-usage guidance](https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-included-usage).

Use this policy:

- Keep one warmed `primary` slot per account.
- Use another account's idle primary before creating more storage.
- Create a temporary named slot only to avoid interrupting concurrent work.
- An extra slot uses the same account's compute/storage allowance. It cannot
  help when that account is out of hours; switch accounts instead.
- Do not pre-create an arbitrary fixed number. Stopped spaces still consume
  storage, so delete temporary slots after their local evidence is safe.

To create an additional slot, switch and verify the owning account, select a
short unique slot name, and create the space:

```bash
ACCOUNT=ZeyadNasef
SLOT=task-short-name
gh auth switch --hostname github.com --user "$ACCOUNT"
test "$(gh api user --jq .login)" = "$ACCOUNT"

gh codespace create \
  -R Zeyad2003/olympus-forge \
  -m standardLinux32gb \
  --default-permissions \
  --idle-timeout 30m \
  --display-name "Olympus forge - $ACCOUNT - $SLOT"
```

Set `NEW_CS` to the exact returned name, verify Docker, stop it, and wait for
`Shutdown`. Only then add this unique tab-separated row to
`scripts/codespaces.conf`:

```text
ZeyadNasef<TAB>task-short-name<TAB><exact-codespace-name>
```

Use it explicitly:

```bash
scripts/verify-remote.sh <task-dir> --account ZeyadNasef --slot task-short-name
```

When the parallel task finishes, preserve its local output and confirm it owns
no needed remote-only state. With the same account active, delete only that
temporary Codespace, confirm it is gone, then remove its config row:

```bash
gh codespace delete -c "$NEW_CS"
```

Deletion is permanent; never use `--all`, never delete another task's slot, and
do not use `--force` unless you have independently proved no remote change is
needed.

## Interactive debugging and manual account switching

Automated runs should use `--account`. For a human interactive SSH session,
switch global GitHub CLI state deliberately and prove the identity before
touching the mapped Codespace:

```bash
ACCOUNT=Zeyad-Nasef
SLOT=primary
gh auth switch --hostname github.com --user "$ACCOUNT"
gh api user --jq .login
CS=$(awk -v account="$ACCOUNT" -v slot="$SLOT" \
  '$1 == account && $2 == slot { print $3 }' scripts/codespaces.conf)
test -n "$CS"
gh codespace ssh -c "$CS"
```

Switch back the same way:

```bash
ACCOUNT=Zeyad2003
gh auth switch --hostname github.com --user "$ACCOUNT"
gh api user --jq .login
```

The login printed by `gh api user` must match `ACCOUNT`. Do not SSH if it does
not. Anything discovered interactively must be applied to the local snapshot
and recorded in the local task evidence because the forge is disposable.

### Start, inspect, and stop one forge manually

After switching and verifying the intended account:

```bash
CS=$(awk -v account="$ACCOUNT" -v slot="$SLOT" \
  '$1 == account && $2 == slot { print $3 }' scripts/codespaces.conf)
gh codespace ssh -c "$CS" -- true
gh codespace list --json name,state,machineName,owner \
  --jq ".[] | select(.name == \"$CS\")"
gh codespace stop -c "$CS"
```

`gh codespace ssh` auto-starts a stopped Codespace. `gh codespace stop` keeps
its filesystem and warm image cache; deletion does not.

## Recreating a mapped forge

Recreate only the missing account/slot pair. Do not overwrite another mapping.

```bash
ACCOUNT=Zeyad-Nasef
SLOT=primary
gh auth switch --hostname github.com --user "$ACCOUNT"
test "$(gh api user --jq .login)" = "$ACCOUNT"

gh codespace create \
  -R Zeyad2003/olympus-forge \
  -m standardLinux32gb \
  --default-permissions \
  --idle-timeout 30m \
  --display-name "Olympus forge - $ACCOUNT - $SLOT"
```

Copy the exact new name returned by GitHub into `NEW_CS`, then prove Docker and
warm the JVM image:

```bash
NEW_CS=<exact-name-returned-by-GitHub>
gh codespace ssh -c "$NEW_CS" -- \
  "set -e; docker version; \
   docker pull public.ecr.aws/d3j8x8q7/olympus-base-jvm:latest; \
   docker image inspect public.ecr.aws/d3j8x8q7/olympus-base-jvm:latest"
gh codespace stop -c "$NEW_CS"
gh codespace list --json name,state,machineName,owner \
  --jq ".[] | select(.name == \"$NEW_CS\")"
```

Wait for `state: Shutdown`. Only then replace that account/slot row in
`scripts/codespaces.conf`. Keep exactly one row per account/slot pair and one
owner per Codespace name.

If creation or warm-up fails, stop the partially created space and do not
publish it as ready in the map.

## How manual commands move results

The verifier is preferred because it routes credentials correctly. After an
interactive `gh auth switch` and identity check, the underlying primitives are:

```bash
CS=$(awk -v account="$ACCOUNT" -v slot="$SLOT" \
  '$1 == account && $2 == slot { print $3 }' scripts/codespaces.conf)

gh codespace ssh -c "$CS" -- '<remote-command>'
gh codespace cp -e -c "$CS" ./solution.patch remote:verify/
gh codespace cp -e -r -c "$CS" remote:verify/task/out ./my-work/task/.verify/
```

Remote paths are relative to the Codespace home directory. Every SSH/copy call
must include `-c "$CS"`; otherwise `gh` may try to prompt and fail with
`no terminal`.

## Failures and recovery

| Symptom | Meaning and response |
| --- | --- |
| No stored credential for the account | Authenticate that login with `gh auth login`, including the `codespace` scope. |
| Credential resolves as another login | Stop. Repair the stored account; do not use the other account's Codespace name. |
| No or duplicate mapping | Fix `scripts/codespaces.conf`; never guess a Codespace. |
| Unknown slot | Use `primary`, choose an existing named slot, or provision it fully before adding its row. |
| Usage/allowance rejected | Preserve the error, then explicitly rerun with the other mapped account. |
| `no terminal` | Ensure every `gh codespace ssh/cp` call has `-c "$CS"`. |
| Recovery container / Docker missing | Recreate without a custom Docker-in-Docker devcontainer feature. |
| Docker build or tests fail | Treat the remote output as evidence; fix locally and rerun. |
| Result copy fails | Inspect `~/verify/<task>/out` interactively before cleaning the remote task directory. |
| Codespace deleted | Recreate only its account/slot row using the procedure above. Local task state is unaffected. |

The verifier intentionally does not silently switch accounts, automatically
delete a Codespace, or globally change `gh` authentication state.

## Cost, quota, and housekeeping

- Each account owns its mapped Codespace and GitHub attributes its usage to
  that owner. Check each account's current Codespaces billing/usage page for
  remaining allowance; do not assume yesterday's remaining hours are current.
- Stop the selected forge after a work batch. A 30-minute idle timeout is a
  backstop, not the normal shutdown method.
- Do not start multiple forges for one sequential job. Each running slot spends
  its owning account's compute allowance.
- Prefer one persistent warmed primary per account. Additional stopped slots
  consume storage, so keep them temporary unless repeated concurrency justifies
  the cost.
- Warm images and remote clones consume storage even when stopped. Inspect with
  `docker system df` before deciding to prune anything.
- Do not automate destructive cleanup. Remove finished `~/verify/<task>` data
  or old images only after confirming their evidence/cache is no longer useful.
- Deleting a forge loses its remote filesystem and warm cache. It never deletes
  the authoritative local task artifacts, but it should still be intentional.
- The older `solid-space-invention-wjvpgj5pwqjh9r6w` remains stopped and
  unmapped until separately inspected.

## Why this setup

- It preserves the familiar GitHub CLI and Codespaces environment.
- It supports reproduction, patch verification, Dockerfile debugging, and
  environment-quality investigation interactively or unattended.
- It leaves the laptop responsible for light, durable work and uses remote
  resources only for the heavy step.
- It keeps one verifier implementation, so the four-state behavior cannot drift
  between account-specific script copies.
- Per-command credential scoping makes automated runs independent of a human
  `gh auth switch` in another shell.
- Explicit selection makes quota fallback visible and auditable.

## Rule of thumb

Reading, editing, `git diff`, review writing, and durable learning stay local.
Docker builds, container tests, and environment reproduction go to one selected
forge. Stop that forge when the batch is complete. Change accounts for quota
fallback; use another named slot only for concurrent-work isolation.
