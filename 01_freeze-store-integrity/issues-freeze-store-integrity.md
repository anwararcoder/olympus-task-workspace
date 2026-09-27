
Tests - (1/3) Weak
T3/T4 — The only passing agent is a false positive:
- It normalizes CRLF descriptions before invoking the user-provided filename strategy, changing the public callback input.
- It uses direct Properties.containsKey handling, so configuration inherited through Properties.defaults can bypass the constructor/config conflict.
- It rejects a symlinked store directory that the existing store accepts.
Add direct regression tests for all three behaviors.
T5 — The concurrent save/forget test over-prescribes the winner. It requires a forget invocation started second to win even when the first save already owns the transaction lock. The contract requires a consistent serialization, not invocation-order precedence. Accept either complete serialized result or specify the required precedence publicly.
T3/T4 — Additional coverage gaps remain:
- The integrity-report ordering test uses condition names already in lexical order, so a global-sort implementation passes.
- The empty-name strategy rollback test does not verify that stored.rules and cached membership remain unchanged.
- Failed file deletion is not checked against the same live store instance.
- Empty-save cleanup lacks the unique internal-symlink case.
- “Do not rewrite an unchanged index” is tested only by comparing bytes, which cannot detect an identical rewrite.
- Custom strategy input is not tested with CRLF descriptions.
- The harness concatenates native XML without validating it first, allowing a truncated report to produce malformed advertised JUnit.
T1/T6: Trim the long test narration and section-divider commentary.

Solution & Code - (1/3) Weak
S1/S2 — The reference implementation has four unresolved correctness defects:
- reloadFromFileSystem() performs clear() followed by putAll() while readers are not synchronized on the same monitor. A concurrent evaluation can observe a temporarily empty store and incorrectly refreeze a known rule.
- Repair normalizes discard keys before removal. Distinct LF and CRLF keys can therefore cause the healthy mapping to be removed while the broken entry remains.
- The absent-index fail-policy scan occurs outside the per-path transaction lock. It can inspect files created by a concurrent save before that save publishes its index entry and reject them as unowned.
- Repair silently continues when a required delete or move returns failure, allowing initialization to succeed without completing the requested repair.
S4: Reduce the comment-heavy implementation narration to short explanations of genuinely non-obvious invariants.