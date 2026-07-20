# Agents Flow Questions, Decisions, and Blocked Runs

This file is the canonical authority for user-decision eligibility and the one-reply limit. Do not depend on an external grilling skill.

## Ordering

PLAN asks only after it has:

1. read the binding task contract and selected profiles;
2. performed one proportional inspection sufficient to locate/classify the work, establish project facts, diagnose the issue, and frame bounded alternatives.

Questions resolve user judgments revealed by evidence. They never replace inspection.

## One-Reply Rule

A run waits for at most one user-decision reply. Use one of these paths:

1. `PLAN QUESTIONNAIRE [I1]` after inspection, with up to three questions; or
2. `PLAN DECISION REQUEST [D1]` later, only when no questionnaire was sent and one newly revealed bounded choice controls continuation.

Never use both. Never open a second routine questionnaire.

## Routine Questionnaire

Zero questions is preferred. A question is eligible only when all are true:

1. it is a genuine user judgment, not a discoverable fact;
2. it materially affects behavior, semantics, scope, safety, public compatibility, destructive behavior, or validation;
3. the prompt, project evidence, and conservative defaults do not already settle it;
4. PLAN can offer bounded options with a recommendation and evidence-based reason.

Do not ask for:

- file locations, counts, callers, project conventions, native commands, or other discoverable facts;
- checklist approval;
- preferred implementation mode;
- a decision whose conservative default is already clear and non-material.

If more than three decisions exist, ask the three highest-impact ones only when every omitted decision has a safe conservative default. Otherwise block rather than hiding an unresolved material choice.

Use the canonical `PLAN QUESTIONNAIRE [I1]` shape in `references/templates.md`; omit unused questions.

After the reply, PLAN may perform only a narrow confirmation lookup at an already-inspected site, then freezes the checklist. A reply that materially expands scope or invalidates inspection cannot open a second packet — the questionnaire consumed the run's single user-decision reply — so PLAN blocks and explains why a fresh run is needed.

## Late Decision Request

Use `PLAN DECISION REQUEST [D1]` only when:

- no questionnaire was sent;
- the alternatives are already bounded by evidence;
- one answer determines whether the finalized task can continue;
- the answer requires no expanded authorization beyond the stated options.

Use the canonical `PLAN DECISION REQUEST [D1]` shape in `references/templates.md`.

Ask once, wait for one reply, update the checklist or validation contract as authorized, and continue. Do not use this for routine preference gathering.

## Blocked Notice

Use `PLAN BLOCKED [B1]` only when continuation is genuinely impossible. The single authority for blocked-run triggers is **Decision and Blocked Outcomes** in `references/safety.md`; load that section before issuing the notice. This file owns the decision and notice protocol and does not restate or extend the trigger list.

Use the canonical `PLAN BLOCKED [B1]` shape in `references/templates.md`.

A blocked notice ends the run. PLAN authors a blocked final report and conditionally persists recovery evidence under `references/safety.md`. It is not a second question or a request to approve a plan.

## Internal Decision Record

PLAN keeps the canonical `Decision record` block defined in the PLAN Internal Packet in `references/templates.md`: inspection basis, user packet, questions asked, user decisions, conservative defaults, any narrow confirmation lookup, and any blocked notice.

This record is analytical material. The orchestrator does not inspect or summarize it.
