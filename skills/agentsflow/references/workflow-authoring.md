# Workflow Reference Authoring

Use this reference for every activated Agents Flow request that creates a durable workflow and launcher. Authoring is a pure prompt-structuring pass; it is not target inspection.

## Canonical Sources

- `skill://agentsflow/assets/AGENTS_WORKFLOW_CORE.template.md`
- `skill://agentsflow/assets/AGENTS_LAUNCHER.template.md`
- `skill://agentsflow/references/profiles.md` → profile index and prompt-facing authoring rubrics

The workflow is the task-specific contract. The launcher is universal except for the workflow path.

## Authoring Boundary

Before reading target contents, searching the project, compiling, diagnosing, localizing sites, inferring APIs or schemas, or selecting execution modes, the orchestrator may use only:

- the current prompt and supplied context;
- explicitly named paths, references, screenshots, and artifacts;
- directory metadata needed to choose collision-free output paths;
- candidate rows in the Profile Selection Index;
- selected profiles' `Authoring rubric — orchestrator` sections;
- the two canonical templates.

Project facts that require inspection belong under **Facts for PLAN to Discover**. The orchestrator does not write PLAN's checklist, choose modes, route review, or invent project evidence.

## Output Paths

Write both files under `.agentsflow/`:

1. workflow: `.agentsflow/AGENTS_WORKFLOW.md`;
2. launcher: `.agentsflow/AGENTS_LAUNCHER.md`.

If either default exists and overwrite was not explicitly requested, choose a matching collision-free pair:

```text
.agentsflow/AGENTS_WORKFLOW_<short-task-slug>.md
.agentsflow/AGENTS_LAUNCHER_<short-task-slug>.md
```

If that pair exists, append `_2`, `_3`, and so on. Never overwrite a generated workflow the user may still be running.

## Current Metadata

Every new workflow declares exactly:

- `Agents Flow skill: 3.1.0`

This single stamp records which skill version authored the workflow, for provenance only.

## Profile Selection

1. Select exactly one primary intent unless `generic-fallback` is the only profile.
2. Add a secondary intent only for a distinct compatible outcome explicitly requested.
3. Read-only inquiry or diagnosis does not combine with a mutating intent.
4. Repair already includes diagnosis.
5. Editing requires a specific artifact profile or `generic-fallback`.
6. Fallback does not coexist with a specific artifact.
7. Evidence overlays are optional and selected only when supported by the prompt.
8. Preserve the index order in the workflow.
9. Mark exactly one selected intent as `— primary intent` unless fallback-only.

## Workflow Rendering

Render the core template in memory with concise prompt-grounded content:

- task title;
- current skill version stamp;
- goal and context;
- named inputs and read-only/editable boundaries;
- selected profile IDs;
- atomic `REQ-n` requirements derived from the prompt;
- facts PLAN must discover;
- observable validation expectations;
- stopping condition.

Do not copy profile procedures into the workflow. Do not preselect `anchored`, `batch-anchored`, `scripted-pattern`, or `planned-implementation`.

## Mechanical Write Check

Before writing, mechanically verify the in-memory render:

1. every reserved slot was replaced;
2. required headings occur exactly once and contain content;
3. current metadata occurs exactly once;
4. selected profile IDs are unique, indexed, and composition-valid;
5. exactly one selected intent is marked primary unless fallback-only;
6. prompt facts remain separate from PLAN-discoverable facts;
7. destructive or external effects appear only when the prompt authorizes the exact target and effect;
8. no implementation checklist, mode choice, or invented project evidence appears.

Then render the launcher with the exact final workflow path and mechanically verify that no slots remain and the path occurs exactly once.

Write both new files. Their first substantive read by PLAN is the handoff; do not perform a redundant post-write equality comparison. If either write fails, do not launch PLAN. Correct only an incomplete, not-yet-launched pair; never overwrite a previously generated pair the user may be running.

## Launch Gate

Before launching PLAN, verify from the retained rendered content and write results:

- both selected paths were written successfully;
- the workflow stamps the current skill version;
- the launcher contains the exact final workflow path exactly once;
- neither retained render contains an unresolved slot;
- selected profiles remain valid.

If the gate fails, report the write/check failure and do not launch.

## Local Runtime Branch

When the user explicitly requests immediate local Agents Flow execution without workflow files, structure the same binding fields in the PLAN spawn prompt and include the current skill version. Do not create a launcher or durable workflow pair. PLAN still owns inspection, questionnaire, checklist/modes, routing, validation, housekeeping, and reporting.

## Generated Pairs

Each run authors a fresh workflow and launcher from the current `profiles.md` and `execution-modes.md`. PLAN's first read of the saved workflow is sufficient handoff verification; no separate read-back ceremony is required. Do not overwrite a previously generated pair the user may still be running; choose a collision-free name instead.

## Launch and Relay

After the authoring gate passes, spawn exact `agent:"plan"` with the workflow path. From that point the orchestrator is passive relay. It may only:

- forward PLAN's typed statuses, single questionnaire, decision request, or blocked notice verbatim;
- forward the user's correlated answer verbatim;
- inspect job-liveness metadata;
- cancel on user request;
- display PLAN's final report verbatim.

It must not inspect PLAN artifacts, route roles, validate, edit, open a browser, author or run scripts, or supplement the report.
