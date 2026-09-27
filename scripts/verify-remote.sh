#!/usr/bin/env bash
# Run the clean-room four-state verification on the forge Codespace.
#
# Usage:
#   scripts/verify-remote.sh <task-dir> [--url <repo-url>] [--legacy]
#                            [--account <github-login>] [--slot <slot-name>]
#
#   <task-dir>   dir holding test-*.patch, solution-*.patch, Dockerfile-*,
#                and BASE_COMMIT-*.txt (SHA on line 1, repo URL on line 2).
#   --url URL    override / supply the repo URL when it's not on line 2.
#   --legacy     task uses the old positional test.sh (./test.sh base|new)
#                instead of the new ./test.sh --output_path <xml> <mode>.
#   --account    use this account's mapped Codespace and stored gh credential.
#                Precedence: flag, FORGE_ACCOUNT, active gh account.
#   --slot       use a named Codespace slot for the selected account.
#                Precedence: flag, FORGE_SLOT, "primary".
#
# The forge fresh-clones the repo at the base SHA, bakes each state into an
# image, and runs test.sh with `--network none`. Only patches go up; only the
# result XMLs (new format) come back to <task-dir>/.verify/.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
CODESPACES_FILE="$HERE/codespaces.conf"

TASK=""; URL=""; LEGACY=0; ACCOUNT_ARG=""; SLOT_ARG=""
while [ $# -gt 0 ]; do
  case "$1" in
    --url)
      [ "$#" -ge 2 ] || { echo "ERROR: --url requires a value"; exit 1; }
      URL="$2"; shift 2
      ;;
    --account)
      [ "$#" -ge 2 ] || { echo "ERROR: --account requires a GitHub login"; exit 1; }
      ACCOUNT_ARG="$2"; shift 2
      ;;
    --slot)
      [ "$#" -ge 2 ] || { echo "ERROR: --slot requires a slot name"; exit 1; }
      SLOT_ARG="$2"; shift 2
      ;;
    --legacy) LEGACY=1; shift ;;
    --*) echo "ERROR: unknown option: $1"; exit 1 ;;
    *)
      [ -z "$TASK" ] || { echo "ERROR: unexpected argument: $1"; exit 1; }
      TASK="$1"; shift
      ;;
  esac
done
[ -n "$TASK" ] && [ -d "$TASK" ] || { echo "ERROR: pass a valid task dir"; exit 1; }
[ -f "$CODESPACES_FILE" ] || {
  echo "ERROR: Codespace mapping file not found: $CODESPACES_FILE"
  exit 1
}

ACCOUNT="$ACCOUNT_ARG"
[ -n "$ACCOUNT" ] || ACCOUNT="${FORGE_ACCOUNT:-}"
if [ -z "$ACCOUNT" ]; then
  ACCOUNT="$(gh api user --jq .login 2>/dev/null || true)"
  [ -n "$ACCOUNT" ] || {
    echo "ERROR: cannot determine the active GitHub account; use --account <login>"
    exit 1
  }
fi

SLOT="$SLOT_ARG"
[ -n "$SLOT" ] || SLOT="${FORGE_SLOT:-primary}"

mapfile -t MATCHES < <(
  awk -v account="$ACCOUNT" -v slot="$SLOT" '
    NF && $1 !~ /^#/ &&
      tolower($1) == tolower(account) && tolower($2) == tolower(slot) { print $3 }
  ' "$CODESPACES_FILE"
)
if [ "${#MATCHES[@]}" -ne 1 ] || [ -z "${MATCHES[0]:-}" ]; then
  echo "ERROR: expected exactly one Codespace mapping for $ACCOUNT slot $SLOT in $CODESPACES_FILE"
  exit 1
fi
CS="${MATCHES[0]}"

gh_for_account() {
  local token
  if ! token="$(gh auth token --hostname github.com --user "$ACCOUNT" 2>/dev/null)"; then
    echo "ERROR: no stored GitHub CLI credential for $ACCOUNT" >&2
    return 1
  fi
  GH_TOKEN="$token" gh "$@"
}

AUTHENTICATED_LOGIN="$(gh_for_account api user --jq .login)" || {
  echo "ERROR: could not authenticate GitHub CLI as $ACCOUNT"
  exit 1
}
if [ "${AUTHENTICATED_LOGIN,,}" != "${ACCOUNT,,}" ]; then
  echo "ERROR: credential for $ACCOUNT resolved as $AUTHENTICATED_LOGIN"
  exit 1
fi

BC="$(ls "$TASK"/BASE_COMMIT-*.txt | head -1)"
SHA="$(sed -n '1p' "$BC" | tr -d '[:space:]')"
[ -n "$URL" ] || URL="$(sed -n '2p' "$BC" | tr -d '[:space:]')"
[ -n "$URL" ] || { echo "ERROR: no repo URL (line 2 of $BC or --url)"; exit 1; }
NAME="$(basename "$TASK")"

echo ">> account=$ACCOUNT  slot=$SLOT  forge=$CS  task=$NAME  sha=$SHA  url=$URL  legacy=$LEGACY"

# 1. ship patches + Dockerfile up (tiny)
gh_for_account codespace ssh -c "$CS" -- "rm -rf ~/verify/$NAME && mkdir -p ~/verify/$NAME/out"
for f in "$TASK"/test-*.patch "$TASK"/solution-*.patch "$TASK"/Dockerfile-*; do
  gh_for_account codespace cp -e -c "$CS" "$f" "remote:verify/$NAME/$(basename "$f")"
done

# 2. run the clean-room four-state on the forge's Docker
gh_for_account codespace ssh -c "$CS" -- \
  "SHA='$SHA' URL='$URL' NAME='$NAME' LEGACY='$LEGACY' bash -s" <<'REMOTE'
set -uo pipefail
cd ~/verify/"$NAME"
rm -rf src && git clone --quiet "$URL" src && ( cd src && git checkout --quiet "$SHA" )
cp Dockerfile-* src/Dockerfile

runstate() { # <image-tag> <mode> ; echoes exit code
  local tag="$1" mode="$2"
  if [ "$LEGACY" = "1" ]; then
    docker run --rm --network none "$tag" ./test.sh "$mode" >/dev/null 2>&1
  else
    docker run --rm --network none -v ~/verify/"$NAME"/out:/out "$tag" \
      ./test.sh --output_path /out/"$mode".xml "$mode" >/dev/null 2>&1
  fi
  echo $?
}

cd src
git apply ../test-*.patch
docker build --quiet -t "olympus-verify-$NAME-t" . >/dev/null \
  || { echo "RESULT: DOCKER BUILD FAILED (test-patch image) — states not run"; exit 1; }
RC1=$(runstate "olympus-verify-$NAME-t" base)   # expect 0
RC2=$(runstate "olympus-verify-$NAME-t" new)    # expect non-zero (new tests fail on base)
git apply ../solution-*.patch
docker build --quiet -t "olympus-verify-$NAME-ts" . >/dev/null \
  || { echo "RESULT: DOCKER BUILD FAILED (solution image) — states not run"; exit 1; }
RC3=$(runstate "olympus-verify-$NAME-ts" base)  # expect 0
RC4=$(runstate "olympus-verify-$NAME-ts" new)   # expect 0

pass() { [ "$1" = "$2" ] && echo PASS || echo "FAIL(rc=$1)"; }
echo "FOUR-STATE ($NAME):"
echo "  base + test.patch        (want PASS): $( [ "$RC1" = 0 ] && echo PASS || echo FAIL rc=$RC1 )"
echo "  new  + test.patch        (want FAIL): $( [ "$RC2" != 0 ] && echo PASS || echo 'FAIL (new passed on base!)' )"
echo "  base + solution.patch    (want PASS): $( [ "$RC3" = 0 ] && echo PASS || echo FAIL rc=$RC3 )"
echo "  new  + solution.patch    (want PASS): $( [ "$RC4" = 0 ] && echo PASS || echo FAIL rc=$RC4 )"
[ "$RC1" = 0 ] && [ "$RC2" != 0 ] && [ "$RC3" = 0 ] && [ "$RC4" = 0 ] \
  && echo "RESULT: ALL FOUR STATES HELD" || echo "RESULT: MISMATCH"
REMOTE

# 3. pull result XMLs back (new format only)
if [ "$LEGACY" = "0" ]; then
  mkdir -p "$TASK/.verify"
  gh_for_account codespace cp -e -r -c "$CS" "remote:verify/$NAME/out" "$TASK/.verify" 2>/dev/null || true
  echo ">> XMLs (if any) in $TASK/.verify/out/"
fi
