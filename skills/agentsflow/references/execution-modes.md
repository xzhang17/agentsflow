# Execution Modes and Review Routing

This file is the single detailed authority for how PLAN classifies checklist items, prepares implementation artifacts, invokes review, and hands work to SMOL. Profiles define task obligations; modes define implementation mechanics. A selected profile never preselects a mode.

## Mode Selection

PLAN assigns exactly one mode to every finalized checklist item after inspection:

| Mode | Use when | Required artifact | Review |
|---|---|---|---|
| `anchored` | One or a few unique sites can be edited safely with exact file-and-anchor context. | Checklist line plus exact file and anchor. | None. |
| `batch-anchored` | A repeated change is completely enumerated as exact replacements; no pattern discovery remains. | Exact `(file, line, old, new)` tuple list and exact-once-or-refuse applier. | PLAN fast path unless the batch-risk trigger fires; otherwise ADVISOR-light. |
| `scripted-pattern` | A genuinely mechanical transformation requires regex/AST matching at scale and cannot be represented as exact tuples. | Full transformation spec, authored script, whole-copy dry-run, offender scan, and real validation evidence. | Mandatory ADVISOR full review; `code approved` required. |
| `planned-implementation` | New files, substantial behavior, or coordinated multi-file changes require bounded engineering judgment. | File-by-file behavior contract with interfaces, states, and observable acceptance criteria. | None. |

Selection rules:

1. Prefer `anchored` when the safe target set is small.
2. Use `batch-anchored` only when PLAN has already enumerated every exact site.
3. Use `scripted-pattern` only when a real pattern is necessary. A list of replacements is not a script.
4. Use `planned-implementation` for behavior, not as a wrapper around an unreviewed bulk transform.
5. Split a bulk transform out of a planned item when it independently needs `scripted-pattern` review.
6. Do not downgrade a failed scripted review into the batch fast path.

## `anchored`

PLAN provides:

- checklist item number and acceptance criterion;
- exact path;
- exact symbol, line, block, or uniquely identifying nearby text;
- intended replacement or behavior.

SMOL uses the anchored editing tool and refuses stale, ambiguous, or missing anchors. No extra review artifact is required.

## `batch-anchored`

Use only when every change is an exact tuple:

```text
(file, line, old, new)
```

### Tuple contract

- `file` is inside the finalized scope.
- `line` identifies the inspected source line.
- `old` is copied from an untruncated source read.
- `old` occurs exactly once on that line.
- `new` is the complete replacement for that occurrence.
- `(file, line, old)` keys are unique.
- Applying all tuples removes every `old` target and cannot double-wrap on rerun.

If exact source text cannot be recovered, use `anchored`. Judgment-dependent sites never belong in a batch.

Tuples bind to the source state PLAN captured them from. When another checklist item edits a tuple's file, PLAN sequences the batch item ahead of it or re-captures the tuples — refreshing `/tmp` evidence and any required review — before SMOL runs the applier. An applier refusal on a stale line returns the item to PLAN. A re-captured tuple set is a new review artifact: any required ADVISOR-light review restarts with a fresh two-round maximum. A second stale-line refusal of the same item becomes a blocked notice rather than another re-capture cycle.

### Exact-once-or-refuse applier

The applier must validate the entire tuple set before writing. It applies a tuple only when the exact `old` substring occurs exactly once on the named line. Any mismatch, duplicate key, out-of-scope path, or non-unique occurrence refuses the whole write with no partial edits. A blind replacement is prohibited. Within each file, the applier applies tuples in descending line order, so a replacement that changes the line count can never shift the line numbers of tuples not yet applied.

### PLAN dry-run

Before implementation, PLAN applies the tuple set to a disposable whole-project `/tmp` copy and runs:

- the task-specific offender or residue scan;
- the project-native focused build/test/render check;
- an idempotency check when rerun behavior is not obvious;
- a changed-file and edit-count check.

PLAN records exactly one line:

```text
batch review path: PLAN fast path | ADVISOR-light (<trigger>)
```

### Canonical batch-risk trigger

ADVISOR-light is required when any tuple touches:

- public APIs or exported identifiers;
- schemas, migrations, permissions, security, or authentication;
- filenames, paths, labels, references, or citations with cross-file consumers;
- deletion or irreversible behavior;
- whitespace or delimiters that carry syntax or semantic meaning;
- generated-source boundaries or build configuration;
- any target set, count, exact string, or idempotency claim that PLAN cannot fully reconcile by construction.

Otherwise PLAN may use the fast path after the `/tmp` evidence passes.

### ADVISOR-light

ADVISOR checks only the tuple and applier mechanics:

- well-formed tuples and valid locations;
- unique keys and in-scope files;
- exact-once-or-refuse behavior with no partial writes;
- obvious idempotency;
- preservation of required prefixes, spacing, and delimiters.

Verdict: `structurally approved` or `revisions requested`. PLAN revises and refreshes `/tmp` evidence after a requested revision. ADVISOR-light follows the same two-round maximum as scripted review: Round 2 occurs only after `revisions requested` and is final. After Round 2 without `structurally approved`, PLAN sends a blocked notice.

## `scripted-pattern`

Use only for a real regex or AST transform whose safe sites cannot be exhaustively represented as exact tuples.

### Required PLAN package

For each scripted item, PLAN supplies:

- item number;
- exact before-to-after transformation rule;
- exact target files;
- every skip, exception, and edge case;
- idempotency and rerun behavior;
- the complete script;
- whole-copy dry-run evidence;
- adversarial/offender scan results;
- real project-native validation on the transformed copy;
- changed-file and edit-count results.

The spec is frozen before review. PLAN authors the script; SMOL never authors or revises it.

### Whole-copy dry-run

PLAN copies the complete relevant project to `/tmp`, applies the script there, and proves:

1. every catalogued target changed as specified;
2. no uncatalogued target changed;
3. all enumerated edge cases were handled;
4. the transformed copy passes the real focused build/test/render command;
5. rerunning is safe;
6. changed files and counts match the spec.

### Mandatory ADVISOR review

Every scripted item receives independent full review. Round 1 is mandatory. Round 2 occurs only after `revisions requested` and is final.

ADVISOR checks:

- full-copy evidence and real validation are present and passing;
- validation covers success, blast radius, and project behavior;
- script conforms to the finalized spec;
- edge cases and idempotency are correct;
- only target files change;
- no unrelated cleanup or formatting occurs.

Verdict: `code approved` or `revisions requested`.

If ADVISOR finds a validation-sufficiency gap:

- `additions-only`: PLAN may add stronger checks and record them;
- `requires-weakening`: PLAN uses the run's remaining decision request before changing a committed criterion; if the single user-decision reply is already spent, PLAN blocks instead.

After Round 2 without `code approved`, PLAN sends a blocked notice with bounded choices. There is no Round 3.

### SMOL handoff

SMOL receives the exact approved script and recorded verdict. It runs the script unchanged on real files, then immediately reports changed files and edit count. If the script or verdict is missing or appears inconsistent, SMOL refuses and returns the item to PLAN.

## `planned-implementation`

PLAN provides a bounded engineering contract:

- item number;
- exact files to create or edit;
- per-file behavior;
- interfaces and dependencies;
- data flow and public compatibility requirements;
- normal, loading, empty, error, invalid-input, and failure behavior as applicable;
- observable acceptance criteria;
- explicit out-of-scope boundaries.

SMOL may use normal engineering judgment inside that contract. It must not redesign, widen scope, create unrequested abstractions, or resolve a material ambiguity itself. Any unresolved material choice returns to PLAN as a blocked issue.

## Validation and Freeze Rules

PLAN freezes the numbered implementation checklist and validation checklist after the questionnaire is resolved or skipped.

- Every item has one mode and one observable acceptance criterion.
- PLAN may add stronger validation after freeze but may not remove or weaken a committed check without a user decision.
- Required review completes before SMOL receives the affected item.
- PLAN validates the integrated real project after SMOL; copy-only evidence never replaces final real-project validation.
- No mode authorizes off-checklist cleanup, dependency changes, broad formatting, or destructive rollback.

## Handoff Contract

PLAN gives SMOL:

1. the finalized numbered checklist;
2. exact anchors for `anchored` items;
3. tuples, applier, review-path line, and any structural verdict for `batch-anchored` items;
4. PLAN-authored script and `code approved` verdict for `scripted-pattern` items;
5. file-by-file behavior contract for `planned-implementation` items.

Missing records are a refusal condition, not an invitation to improvise.
