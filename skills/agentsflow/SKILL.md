---
name: agentsflow
version: 3.0.3
description: Generate and run safe Agents Flow workflows. The orchestrator structures a prompt and launches PLAN; PLAN inspects once, obtains required pre-freeze specialist input, resolves at most one user-decision packet, freezes a mode-per-item checklist, routes review and SMOL, obtains required post-implementation specialist review, validates the integrated project, performs authorized housekeeping, and authors the final report.
---

<!-- Version: 3.0.3 - full history: see CHANGELOG.md in this skill directory. -->

# Skill: Agents Flow

## Purpose

Agents Flow is the separated-role path for nontrivial project work:

```text
orchestrator structures prompt → launch PLAN → PLAN inspects
→ required pre-freeze specialists → ask once only if needed
→ freeze checklist and modes → risk-gated review → SMOL implements
→ required post-implementation specialists → PLAN validates and reports
```

The orchestrator owns prompt structuring and relay. PLAN owns the run. SMOL is the only real-project source editor.

## Activation

Activate only when the current request explicitly invokes `agentsflow`, asks to create or run an Agents Flow workflow, or uses equivalent explicit phrasing. Activation never carries across turns. Ordinary editing requests use normal standalone-agent behavior.

A simple question about Agents Flow does not activate a run unless the user asks Agents Flow to perform work.

## Runtime Branches

### Durable workflow branch

Default for an activated project-backed request unless the user explicitly asks for local execution without generated files:

1. author a fresh workflow and launcher under `.agentsflow/`;
2. apply the pre-launch mechanical gate;
3. spawn exact `agent:"plan"` with the workflow path;
4. become passive relay.

Follow `references/workflow-authoring.md`. Do not overwrite old generated snapshots.

### Direct local branch

When the user explicitly requests immediate local work or says not to generate workflow files:

1. structure the same binding task fields in the PLAN spawn prompt;
2. include current version and schema declarations;
3. spawn exact `agent:"plan"`;
4. become passive relay.

The runtime topology after PLAN starts is identical in both branches.

## Current Contract Versions

- **Agents Flow skill:** `3.0.3`
- **Workflow schema:** `3`
- **Profile schema:** `3`
- **Execution-mode schema:** `1`

New workflows use `references/profiles.md` and `references/execution-modes.md`. Legacy frozen workflows that name `references/modes.md` are compatibility snapshots; regenerate them for the current contract rather than editing them in place.

## Role Separation

| Role | Exact agent | Responsibility |
|---|---|---|
| Orchestrator | current TUI agent | Prompt structuring, authoring gate, launch, verbatim relay, liveness, final-report display. |
| PLAN | `plan` | Inspection, diagnosis, questionnaire, checklist, mode selection, artifact authoring, routing, integrated validation, housekeeping, final report. Never edits real project source. |
| ADVISOR | `reviewer` | Independent review for every scripted item and risk-triggered batch item. Never edits. |
| SMOL | `smol` | Only real-project source editor; implements the finalized checklist. |
| DESIGNER | `designer` | Read-only web/UI specification before implementation and visual review afterward. |
| VISION | `vision` | Read-only PDF/page/image fidelity inspection. |
| Semantic inspector | `inspector_semantic` | Narrow read-only judgment escalation when structural inspection cannot settle correctness. |

Named roles must be spawned by exact agent name. Never substitute a general-purpose agent when a dedicated role exists.

## Orchestrator Boundary

Before PLAN launches, the orchestrator may only structure the prompt and perform the mechanical authoring gate. It must not inspect target contents, compile, diagnose, localize sites, choose modes, or write PLAN's checklist.

After PLAN launches, the orchestrator may only:

- relay PLAN's typed status, questionnaire, decision request, or blocked notice verbatim;
- relay the user's correlated answer verbatim;
- inspect job-liveness metadata and send neutral liveness notices;
- cancel on user request;
- display PLAN's final report verbatim.

It must not read PLAN's analytical artifacts, route downstream roles, validate, edit, open a browser, author or run implementation scripts, or add an independent summary.

## PLAN Runtime

PLAN performs one continuous run:

1. read the binding workflow or direct contract first and in full;
2. read selected profile runtime/cross-profile sections and `execution-modes.md`;
3. perform one proportional localization and classification inspection;
4. obtain any required pre-freeze specialist input, including a DESIGNER specification for web/UI work;
5. send and resolve the single post-inspection questionnaire, if material choices remain;
6. assign one execution mode to every item, then freeze one numbered implementation checklist and validation checklist;
7. prepare and dry-run mode-specific artifacts;
8. route and complete required pre-implementation review;
9. route SMOL to implement the finalized checklist;
10. after SMOL, exercise applicable real behavior and obtain required post-implementation specialist review;
11. validate the integrated real project;
12. perform only authorized housekeeping;
13. author the final report.

PLAN never edits real project source files. It may write scratch artifacts outside the project, run copy-only dry-runs, validate the real integrated project after SMOL, and remove only profile-authorized generated intermediates after successful validation.

## Inspection

PLAN's first pass must be sufficient to:

- identify relevant files, sites, conventions, callers, and consumers;
- diagnose the problem or define the requested behavior;
- discover project-native validation;
- classify every candidate item;
- frame any remaining material user choice;
- determine whether completeness counts are required for batch/script routing.

Exact corpus-wide counts are required only when completeness is an acceptance criterion or a batch/script mode is under consideration. If a narrow high-stakes semantic judgment remains unresolved, PLAN may send only that suspect set to the semantic inspector.

After a user reply, PLAN may perform a narrow confirmation lookup at an already-inspected site. It does not repeat broad inspection or open a second routine questionnaire.

## Profiles

Profiles define obligations, not execution mechanics. During authoring, select profiles from `references/profiles.md` using its compact index and composition contract. During runtime, PLAN reads the prompt-selected profiles and any compatible profile added after inspection.

PLAN may add a compatible profile when inspection proves it applies and must not remove or weaken a prompt-selected profile or `REQ-n` requirement, except that first inspection replaces `generic-fallback` once in the runtime-loaded set with exactly one discovered artifact profile while leaving the authored workflow unchanged. PLAN never infers primary intent from the target, and the runtime-loaded set must satisfy the composition contract before checklist freeze. A material scope-expanding conflict requires a decision request if the run still has its single user-decision reply; otherwise it becomes a blocked notice.

## Questionnaire and Decisions

Zero questions is preferred. Ask only about a genuine user judgment that:

1. is not discoverable from project evidence;
2. materially changes behavior, semantics, scope, safety, compatibility, destructive effects, or validation;
3. has bounded evidence-grounded options.

A run waits for at most one user-decision reply. Use either:

- one `PLAN QUESTIONNAIRE [I1]` after inspection, containing at most three questions; or
- one later `PLAN DECISION REQUEST [D1]` for a newly revealed bounded choice when no questionnaire was sent.

Never use both. Never ask for checklist approval or a discoverable fact.

If continuation is impossible and no bounded choice can safely resolve it, send `PLAN BLOCKED [B1]` and end the run with a blocked final report. A blocked notice does not ask the user to approve a checklist; it states the reason, current file state, and narrow next options.

## Checklist Freeze

PLAN freezes one dependency-aware checklist after the questionnaire is answered or skipped. Every item includes:

```text
<n>. files: <exact paths>
mode: anchored | batch-anchored | scripted-pattern | planned-implementation
change: <specific behavior or transformation>
acceptance: <focused observable check>
```

The validation checklist is the acceptance contract. After freeze, PLAN may add stronger checks but may not silently remove or weaken a committed criterion. A required weakening uses the remaining decision request if available; otherwise PLAN blocks.

## Execution Modes and Review

`references/execution-modes.md` is the single detailed authority for:

- mode selection;
- exact anchors and tuple contracts;
- whole-copy `/tmp` dry-runs;
- the canonical batch-risk trigger;
- ADVISOR-light and full scripted review;
- two-round scripted review;
- SMOL handoff requirements.

Summary:

- `anchored` → SMOL from exact anchors.
- `batch-anchored` → PLAN fast path unless the risk trigger requires ADVISOR-light; then SMOL.
- `scripted-pattern` → mandatory ADVISOR `code approved`; then SMOL runs the exact approved script.
- `planned-implementation` → SMOL from PLAN's file-by-file behavior contract.

Every scripted item requires PLAN's whole-copy dry-run and independent ADVISOR review. No scripted item reaches real files without `code approved`.

## Specialist Routing

- Every web/UI task uses DESIGNER before checklist freeze and after SMOL. PLAN also exercises the real interface in its browser.
- When `evidence-visual-browser-pdf` requires supplied or rendered PDF/page/image fidelity inspection, PLAN must use VISION with the exact evidence set; otherwise VISION remains optional.
- The semantic inspector receives only a narrow suspect set whose correctness cannot be decided structurally.
- ADVISOR is not a routine plan critic or final-diff reviewer.
- SMOL receives only finalized checklist items and required review records.

## Validation

PLAN validates the integrated real project after SMOL. Validation is proportional:

- run the narrowest project-native check that proves each acceptance criterion;
- reproduce a reported defect when practical, then confirm it is gone;
- exercise actual UI behavior in the browser for UI work;
- compile/render task-relevant LaTeX and inspect affected pages and diagnostics;
- add tests only for a new observable contract without existing coverage or when the prompt requests them;
- avoid broad formatters, full suites, exhaustive visual comparisons, and unrelated warning sweeps unless the changed surface or prompt requires them.

Equivalent obligations collapse into one check. A committed check that cannot run is failed or blocked, never silently dropped. Copy-only dry-run evidence supplements but never replaces final real-project validation.

## LaTeX Post-Success Cleanup

Eligible cleanup follows `references/latex-cleanup.md`, the single normative procedure. It runs only after every committed validation check passes and only inside the resolved build boundary. No other profile inherits automatic cleanup.

## Safety and Recovery

Detailed boundaries live in `references/safety.md` and questionnaire/blocked triggers in `references/grilling-intake.md`.

Hard rules:

- never expose secrets;
- never perform an irreversible or external action without exact authorization and recovery/validation boundaries;
- never run `git reset --hard`, `git checkout -- <file>`, `git clean -fd`, or `git stash drop` without explicit user approval in the current conversation;
- never discard user changes to repair workflow work;
- if corruption is suspected, stop and report rather than attempting destructive self-repair;
- never edit outside the finalized checklist.

Persist a recovery packet only when the user requested an audit artifact, an irreversible/external side effect occurred or was attempted, or the run ends failed/blocked after modifying user files. Otherwise report concise evidence inline.

## Live Status Protocol

PLAN sends concise phase-boundary statuses using `references/templates.md`:

```text
PLAN STATUS — <phase>: <observable action or result>; state=<active|waiting|blocked>.
```

Required phases:

1. startup;
2. inspection and required pre-freeze specialist input;
3. questionnaire waiting, only when used;
4. checklist freeze and review routing;
5. implementation wait;
6. post-implementation specialist review, only when applicable;
7. validation;
8. housekeeping, only when applicable;
9. reporting.

Before an operation expected to exceed 90 seconds, PLAN sends one status naming the operation and expected next event. The orchestrator may emit neutral job-liveness notices; it never infers analytical progress from liveness.

## Completion and Reporting

A run completes only when:

- every checklist item is implemented or honestly reported unresolved;
- every committed validation criterion is accounted for;
- required review records are present;
- authorized housekeeping is complete or accurately warned;
- protected artifacts and scope are intact;
- PLAN authors the final report.

PLAN uses `references/templates.md` for a concise result card. Failures and blocked runs expand inline with exact evidence and file state. The orchestrator displays the report verbatim.

## Reference Files

Load only what the active phase needs:

- `assets/AGENTS_WORKFLOW_CORE.template.md` — compact workflow template.
- `assets/AGENTS_LAUNCHER.template.md` — universal launcher.
- `references/workflow-authoring.md` — pre-launch authoring and write gate.
- `references/profiles.md` — profile index, composition, runtime, and validation obligations.
- `references/execution-modes.md` — implementation modes, artifacts, review, and SMOL handoff.
- `references/grilling-intake.md` — questionnaire, decision, and blocked protocol.
- `references/safety.md` — scope, secrets, destructive actions, recovery, and validation boundaries.
- `references/templates.md` — statuses, packets, executor report, and final report.
- `references/latex-cleanup.md` — canonical LaTeX cleanup.
