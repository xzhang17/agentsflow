# Safety, Recovery, and Validation Boundaries

Load this file for destructive or external effects, secrets, corruption, recovery evidence, validation boundaries, and blocked-run handling.

## Git and Rollback

Agents Flow makes no backup decision. The user manages checkpoints or backups if wanted.

The following commands are forbidden unless the user explicitly approves the exact action in the current conversation:

```bash
git reset --hard
git checkout -- <file>
git clean -fd
git stash drop
```

Treat `git restore <file>` as a destructive rollback too: it may discard uncommitted work and requires explicit approval of the exact path and command.

Never discard user changes to repair workflow work. If corruption is suspected, PLAN sends a blocked notice and reports the current state; no role attempts blind or destructive self-repair.

## Destructive and External Actions

Database deletion, publication, deployment, credential rotation, permission changes, remote-service writes, overwriting originals, and other irreversible/external effects require:

1. exact target and effect authorized by the prompt or the run's single decision reply;
2. a bounded recovery or rollback plan where recovery is possible;
3. an observable verification boundary;
4. a finalized checklist item.

A vague request does not authorize a destructive effect. If exact authorization cannot be obtained within the single-reply contract, PLAN blocks.

## Secrets

- Never print, log, summarize, or copy live credentials, tokens, private keys, cookies, or secret-bearing configuration.
- Inspect secret-bearing files only when necessary and use redacted or structural evidence.
- Never place real secrets in examples, tests, generated workflows, scratch artifacts, or reports.
- If a secret appears in tool output, do not repeat it.

## Scope and Protected Artifacts

Every run preserves prompt-defined protected artifacts, public interfaces, identifiers, paths, labels, references, citations, document structure, mathematical/legal meaning, and user changes unless explicit authorization says otherwise.

No role may add off-checklist cleanup, broad formatting, dependency changes, warning suppression, unrelated tests, or opportunistic fixes. Unexpected project changes are treated as user work and left intact.

## Validation Proportionality

Validation proves changed behavior; it does not maximize command count.

- Use the narrowest project-native evidence that proves each acceptance criterion.
- Collapse equivalent checks and run them once.
- Prefer one focused build/test/render plus directly affected evidence over full-corpus comparisons.
- Run broad suites, exhaustive page/image/hash comparison, or formatters only when the prompt, public interface, or focused evidence requires them.
- Add a test only for a new observable contract without existing coverage or when explicitly requested.
- A committed check that cannot run is failed or blocked, not silently skipped.
- Copy-only dry-run evidence never replaces validation of the integrated real project.

For LaTeX, one project-native compile to the required convergence state, directly affected pages or a small representative sample, and one task-relevant diagnostic check are normally sufficient. Full-page or pixel comparison requires an explicit exhaustive-fidelity goal or evidence that focused validation cannot prove the result.

## Editing and Validation Separation

- PLAN inspects, plans, routes, validates, performs authorized housekeeping, and reports. PLAN never edits real project source files.
- SMOL implements only the finalized checklist. It does not broaden validation unless PLAN assigned an implementation-local smoke check.
- The orchestrator does not inspect, edit, validate, or supplement after PLAN launches.
- ADVISOR, DESIGNER, VISION, and the semantic inspector are read-only.

## Decision and Blocked Outcomes

Use `PLAN DECISION REQUEST [D1]` only for one bounded choice when no questionnaire was sent and continuation depends on the answer. This consumes the run's single user-decision reply.

Use `PLAN BLOCKED [B1]` when continuation is genuinely impossible, including:

- incompatible workflow/schema contract;
- missing required profile or mode authority;
- irreversible/external action without exact authorization;
- suspected corruption;
- mandatory scripted review ending without `code approved`;
- a validation regression that cannot be resolved within the finalized scope;
- an ambiguity with no safe conservative default after the user-decision opportunity is exhausted.

A blocked notice ends the run. It states the blocker, evidence, whether user files changed, recovery boundary, and narrow next options. It is not a request for routine approval.

## Conditional Recovery Packet

Persist a project-external recovery packet only when:

1. the user or workflow explicitly requested an audit artifact;
2. an irreversible or external side effect occurred or was attempted; or
3. the run ends failed or blocked after modifying user files.

Otherwise report concise evidence inline and create no packet.

When required, include only:

- outcome and blocking condition;
- files changed and current state;
- validation completed and failed;
- external effects, if any;
- recovery boundary and exact next action.

Exclude private reasoning, secret values, source dumps, and unnecessary raw tool output.

## LaTeX Cleanup

Automatic cleanup exists only for eligible `artifact-document-latex` work and follows `references/latex-cleanup.md`. It is post-success housekeeping, not validation. No other profile inherits automatic cleanup.

Unexpected deletion, protected-artifact change, or suspected corruption blocks the run. A bounded partial cleanup that preserves protected artifacts is a process warning unless cleanup itself was the requested deliverable.

## Process Observability

Live status is separate from task validation. A missed status or liveness transport problem is a `[PROCESS WARNING]`, not a failed deliverable when the requested work and validation succeeded. Include a Process row in the final card only when noteworthy.

## Completion Check

Before reporting success, PLAN confirms:

1. every finalized checklist item is complete;
2. every committed acceptance criterion ran and passed;
3. required mode/review records exist;
4. no unexpected file or external effect occurred;
5. protected artifacts remain intact;
6. housekeeping is complete or accurately warned;
7. the final report names the actual validation evidence.
