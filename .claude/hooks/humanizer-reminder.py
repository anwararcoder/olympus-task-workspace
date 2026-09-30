"""PostToolUse hook: after Claude edits a task description, remind it to run the humanizer skill."""
import json
import re
import sys

try:
    event = json.load(sys.stdin)
except ValueError:
    sys.exit(0)

path = str((event.get("tool_input") or {}).get("file_path") or "").replace("\\", "/")
if not re.search(r"(^|/)[^/]*-description\.md$", path):
    sys.exit(0)

message = (
    "You just modified the task description " + path + ". Before finishing, run the humanizer skill "
    "(.claude/skills/humanizer/) on the changed prose in file mode, then write the final text back. "
    "Keep every tested clause, config key, value, and precedence rule exactly as it is; the humanizer "
    "changes wording only, never the contract."
)
print(json.dumps({"hookSpecificOutput": {"hookEventName": "PostToolUse", "additionalContext": message}}))
