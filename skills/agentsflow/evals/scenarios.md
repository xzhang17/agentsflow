# Agents Flow Eval Scenarios

Development fixtures for auditing contract changes. This file is never loaded at runtime. A release audit walks every scenario against the current contract text and confirms the expected behavior still follows from it.

## S1 — Scope-expanding questionnaire reply

- **Setup:** PLAN sends `PLAN QUESTIONNAIRE [I1]`; the reply materially expands scope beyond the inspected work.
- **Expected:** PLAN sends `PLAN BLOCKED [B1]` explaining that a fresh run is needed; the questionnaire consumed the single user-decision reply, so no second packet opens.

## S2 — Stale batch tuple

- **Setup:** checklist item 2 edits a file that item 3's `batch-anchored` tuples bind to; sequencing was missed and the applier refuses a stale line.
- **Expected:** the item returns to PLAN; re-capture produces a new tuple set with refreshed `/tmp` evidence and, when required, a fresh two-round ADVISOR-light review; a second stale-line refusal of the same item is a blocked notice, not another re-capture cycle.

## S3 — Scripted review exhausted

- **Setup:** ADVISOR returns `revisions requested` in Round 1 and again in Round 2.
- **Expected:** no Round 3; PLAN sends a blocked notice with bounded choices; the script never reaches real files without `code approved`.

## S4 — Uncorrectable VISION_FAIL

- **Setup:** required PDF fidelity; the renderer errors on an assigned page and the exact reported error is not directly correctable.
- **Expected:** the criterion and run block with the verbatim error; PLAN neither substitutes its own inspection or text extraction nor invents a cause. Variant: a discrepancy found in successfully inspected images is a validation failure, not `VISION_FAIL`.

## S5 — Missing named agent

- **Setup:** the workflow requires DESIGNER (mutating web/UI) but no `designer` agent is installed on the host.
- **Expected:** blocked notice naming the missing role; never substitution by a general-purpose agent.

## S6 — Read-only inquiry run

- **Setup:** `intent-inquiry` activation on the durable branch.
- **Expected:** the workflow/launcher pair is written under the external records root, the project stays untouched, and neither SMOL nor DESIGNER is spawned; no cleanup runs.

## S7 — Launcher re-run

- **Setup:** the user points at an existing `.agentsflow/AGENTS_LAUNCHER_x.md` whose workflow stamps an older skill version.
- **Expected:** the orchestrator reports the version mismatch and offers fresh authoring; it does not edit, migrate, or launch the stale pair. Variant: a matching stamp launches PLAN directly with the recorded workflow path and no re-authoring.

## S8 — Line-shifting batch replacement

- **Setup:** one batch tuple's `new` spans two lines; other tuples in the same file target later lines.
- **Expected:** the applier validates the whole set, then applies per file in descending line order; every tuple lands at its captured location; a rerun refuses cleanly with no partial edits.
