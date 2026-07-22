# Templates

This file is the single authoritative source for Agents Flow message and report shapes. Procedures live in `SKILL.md`, `profiles.md`, `execution-modes.md`, `grilling-intake.md`, and `safety.md`.

## Live Messages

### PLAN status

```text
PLAN STATUS — <phase>: <observable action or result>; state=<active|waiting|blocked>.
```

### Post-inspection questionnaire

```text
PLAN QUESTIONNAIRE [I1] — Post-inspection decisions; reply once with each Q<n> choice.

Q1. <decision>
recommended=<answer>; reason=<short evidence-based reason>; options=<bounded options>

Q2. <decision>
recommended=<answer>; reason=<short evidence-based reason>; options=<bounded options>

Q3. <decision>
recommended=<answer>; reason=<short evidence-based reason>; options=<bounded options>
```

Omit unused questions.

### Late decision request

```text
PLAN DECISION REQUEST [D1] — <bounded decision>.
recommended=<answer>; reason=<evidence-based reason>; options=<bounded options>; next=<what follows each option>
```

### Blocked notice

```text
PLAN BLOCKED [B1] — <blocking condition>; evidence=<concise observed basis>; files=<unchanged | exact modified paths>; options=<narrow next options>.
```

Only PLAN uses these `PLAN` prefixes. The orchestrator relays the whole message verbatim.

### Orchestrator liveness

```text
ORCHESTRATOR LIVENESS — PLAN's job is <active|failed|cancelled>; <neutral liveness detail>.
```

The orchestrator reports job state only, never analytical progress.

## PLAN Internal Packet

PLAN keeps this detailed packet as an `agent://` artifact. The orchestrator does not read or summarize it.

```text
Diagnosis:
- ...

Localization/classification:
- inspected files/sites and relevant conventions
- exact counts and reconciliation only when completeness or batch/script routing requires them
- semantic-inspector escalation, if any

Root cause or requested behavior:
- ...

Scope:
- in: ...
- out: ...
- protected: ...

Decision record:
- inspection basis: <files/sites/evidence>
- user packet: I1 sent | D1 sent | skipped
- questions asked: <0-3>
- user decisions: <Q<n>/D1 = answer>
- conservative defaults: <decision = default>
- narrow confirmation lookup: none | <exact site>
- blocked notice: none | B1

Implementation checklist:
1. files: <paths>
   mode: anchored | batch-anchored | scripted-pattern | planned-implementation
   change: <behavior/transformation>
   acceptance: <observable check>

Mode artifacts:
- anchored: exact paths and anchors
- batch-anchored: tuple list, applier, /tmp evidence, `batch review path` line, structural verdict when required
- scripted-pattern: finalized spec, PLAN-authored script, whole-copy evidence, ADVISOR verdict
- planned-implementation: file-by-file behavior, interfaces, states, and acceptance criteria

Validation checklist:
1. ...

Risks and recovery boundary:
- ...
```

Mode artifact requirements are canonical in `references/execution-modes.md`; do not duplicate them into generated workflows.

## DESIGNER Brief

Every mutating web/UI task uses DESIGNER before checklist freeze and after SMOL.

```text
DESIGNER brief:
- phase: pre-implementation specification | post-implementation browser review
- target: <page/component/flow>
- evidence: <files, runnable URL, states, viewports, references>
- required checks: <hierarchy, layout, states, responsiveness, accessibility, consistency>
- protected boundaries: <what must remain unchanged>
```

Post-implementation blocking findings return through PLAN to SMOL only when the frozen checklist already authorizes the correction. Otherwise PLAN uses the remaining decision opportunity or blocks.

## ADVISOR Reviews

ADVISOR is used only for risk-triggered `batch-anchored` items and every `scripted-pattern` item.

### Batch ADVISOR-light

```text
batch-anchored structural review:
- item ref: <n>
- review round: <1|2> of 2
- tuple count: <N>
- tuples well-formed and locations valid: yes/no
- duplicate (file, line, old) keys absent: yes/no
- target files in scope: yes/no
- exact-once-or-refuse with no partial writes: yes/no
- idempotency obvious: yes/no
- required prefixes/spaces/delimiters preserved: yes/no
- verdict: structurally approved | revisions requested
- required revisions: <all blocking issues | none>
```

PLAN owns the whole-copy dry-run/build/scan. ADVISOR-light independently reviews tuple and applier mechanics.

### Scripted full review

```text
scripted-pattern code review:
- item ref: <n>
- review round: <1|2> of 2
- PLAN-finalized spec source: checklist item <n>
- whole-copy transform and offender scan provided: yes/no
- real project-native validation on copy: pass/fail/missing
- frozen criteria prove success, blast radius, and project behavior: yes/no
- sufficiency gap: none | additions-only | requires-weakening
- spec conformance: yes/no
- edge-case coverage: yes/no
- idempotency: yes/no
- target-file blast radius: pass/fail
- unrelated cleanup absent: yes/no
- verdict: code approved | revisions requested
- required revisions: <all blocking issues | none>
```

Round 1 is mandatory. Round 2 occurs only after revisions and is final. No script reaches real files without `code approved`.

## SMOL Executor Contract

PLAN includes this contract in every SMOL assignment:

```text
SMOL executor contract:
- Implement exactly the PLAN-finalized numbered checklist, in order.
- Use the mode artifact supplied for each item; do not redesign or widen scope.
- anchored: use the exact file and anchor.
- batch-anchored: require tuples, exact-once-or-refuse applier, `batch review path`, and structural approval when triggered.
- scripted-pattern: run only the exact PLAN-authored script carrying ADVISOR `code approved`; never author or revise it.
- planned-implementation: implement the file-by-file behavior contract and acceptance boundaries.
- Refuse missing, ambiguous, contradictory, stale, or out-of-scope records and return the item to PLAN.
- Never perform destructive git rollback.
```

Per item:

```text
SMOL item report:
- item: <n>. <description>
- mode: <mode>
- files edited: <paths>
- edit summary: <one line>
- edit/tuple count: <N if applicable>
- review record relied on: <none | PLAN fast path | structurally approved | code approved round k>
- skipped/refused: <none | reason>
- notice for PLAN: <none | issue>
```

Final handoff:

```text
SMOL implementation report:
- items implemented: <n>/<m>
- files changed: <paths>
- skipped/refused: <none | list>
- issues for PLAN: <none | list>
```

PLAN alone validates the integrated real project and authors the final report.

## VISION Evidence Contract

For required PDF/page/image fidelity, PLAN supplies this complete assignment:

```text
VISION evidence contract:
- inputs: <unique input ID -> exact local PDF/image path>
- comparisons/sites: <comparison ID -> reference input/page and target input/page | standalone site ID -> input/page>
- pages: <exact page list for each input>
- default full-page DPI: <72-300; normally 180>
- comparison criteria: <bounded visible properties>
- coverage: <representative | exhaustive>
- follow-up crops: <VISION may choose bounded normalized coordinates within assigned pages and criteria | not allowed>
- boundary: render only assigned local PDF pages with `render_pdf_pages`; inspect returned or supplied images with `read`; use `render_pdf_region` only when follow-up crops are allowed and a full page is insufficient; do not add inputs, pages, pairs, sites, or criteria; do not substitute text extraction
```

VISION returns one image-based result keyed by comparison or standalone-site ID for every assigned pair or site. It records any chosen crop coordinates. On `VISION_FAIL`, include the exact renderer/model error. PLAN may retry only when that exact error is directly correctable without changing scope; otherwise the unavailable required evidence blocks the criterion and run. A discrepancy found in successfully inspected images is a validation failure, not `VISION_FAIL`. PLAN never replaces a required VISION review with its own image inspection or an inferred failure story.

## Final Report

Successful runs use a concise Markdown table beginning exactly with:

```text
════════════════════════════════
## Final Report
```

Then render:

| Result | <task title> ✓ |
|---|---|
| **Done** | one line with outcome and useful counts |
| **Files** | changed files with concise per-file summary |
| **Untouched** | important adjacent artifacts deliberately preserved |
| **Profiles** | authored profile IDs, runtime fallback resolution when used, and any PLAN additions |
| **Build/Test** | exact focused command/check ✓ one-line result |
| **Checks** | frozen validation N/N pass |
| **Process** | include only for a noteworthy process warning |

Add at most one compact payoff detail line when useful. Keep raw identifiers, transcripts, exhaustive tables, and artifacts in the `agent://` packet and offer it on request.

On failure, blocked work, scope violation, or unexpected file state, mark Result `✗` and append:

```text
## Problem
- failure/blocker: <exact issue>
- evidence: <observed result>
- files changed: <none | exact paths and state>
- validation completed: <checks and results>
- recovery boundary: <what is safe now>
- next options: <narrow choices>
```

Do not bury a failed acceptance criterion in a successful-looking card. Do not include a rollback command unless it is accurate; destructive git commands require explicit approval.
