# Profiles and Domain Rubrics

## Schema

- **Profile schema:** `3`
- Profiles define task obligations, protected boundaries, role overlays, and validation evidence.
- Profiles never choose an execution mode. PLAN selects modes from `references/execution-modes.md` after inspection.

## Profile Selection Index

During authoring, the orchestrator reads only candidate index rows. During runtime, PLAN reads only selected profiles' sections plus any compatible profile it adds after inspection.

| Category | Profile ID | Select when |
|---|---|---|
| Intent | `intent-inquiry` | The user asks for an answer or read-only explanation. |
| Intent | `intent-diagnosis` | The user asks for root-cause analysis or rollback advice without edits. |
| Intent | `intent-repair` | The task fixes a broken, buggy, corrupted, or incorrect artifact. |
| Intent | `intent-feature-implementation` | The task adds new behavior, files, components, or a coordinated feature. |
| Intent | `intent-refactor` | The task restructures internals without observable behavior change. |
| Intent | `intent-optimization` | The task improves measurable performance or resource use without behavior change. |
| Intent | `intent-translation` | The task translates text while preserving protected meaning and structure. |
| Intent | `intent-formatting` | The task applies an explicitly cosmetic formatting or layout rule. |
| Intent | `intent-conversion` | The task converts an artifact to another format with fidelity requirements. |
| Artifact | `artifact-code` | Source code, libraries, applications, scripts, or build/test infrastructure. |
| Artifact | `artifact-web-ui` | Web pages, browser interfaces, components, styles, or interaction behavior. |
| Artifact | `artifact-configuration-data` | Configuration, YAML/JSON/TOML, structured data, secrets, or generated data. |
| Artifact | `artifact-document-latex` | LaTeX sources, bibliographies, figures, classes, or document builds. |
| Artifact | `artifact-document-generic` | Markdown, plain text, office documents, RTF, EPUB, or structured prose. |
| Artifact | `artifact-generic-files` | Images, archives, directories, binaries, or mixed file operations. |
| Evidence | `evidence-build-test` | Correctness requires a build, test, schema check, or rendered diagnostic. |
| Evidence | `evidence-visual-browser-pdf` | Correctness requires browser, screenshot, PDF, image, or pixel/fidelity inspection. |
| Evidence | `evidence-source-reference` | A specification, source passage, URL, screenshot, or reference defines correctness. |
| Fallback | `generic-fallback` | No specific artifact profile reliably classifies the task. |

## Composition Contract

1. Select exactly one primary intent unless `generic-fallback` is the only profile.
2. Add a secondary intent only for a distinct compatible outcome explicitly requested by the prompt.
3. Read-only inquiry or diagnosis never combines with a mutating intent.
4. Repair includes diagnosis; do not add `intent-diagnosis` to a repair workflow.
5. Editing requires at least one artifact profile or `generic-fallback`.
6. `generic-fallback` does not coexist with a specific artifact profile.
7. Evidence profiles are optional overlays. They define proof, not task intent.
8. Profiles accumulate constraints but never create separate mini-plans.
9. PLAN may add compatible profiles after inspection but may not remove or weaken a prompt-selected profile, except for the one-time runtime resolution of `generic-fallback` defined below.
10. When `generic-fallback` is selected, first inspection replaces it once in the runtime-loaded profile set with exactly one discovered specific artifact profile. The authored workflow remains unchanged, and fallback never coexists with that artifact profile.
11. The runtime-loaded profile set must satisfy this composition contract before checklist freeze. A fallback-only run that requires a mutating intent establishes that intent through the run's single user-decision reply; if the reply is unavailable or cannot settle the intent safely, PLAN blocks.
12. Material profile conflicts or scope expansion require a decision request when the run still has its single user-decision reply; otherwise PLAN sends a blocked notice.
13. Identical obligations collapse and run once.
14. Generated workflows snapshot only prompt-grounded requirements and facts to discover; runtime procedure stays here and in `execution-modes.md`.

## PLAN Synthesis

After inspection, PLAN:

- resolves the selected profiles into one dependency-aware checklist;
- preserves every profile's protected boundaries;
- selects one execution mode per item;
- deduplicates equivalent validation obligations;
- uses the narrowest evidence that proves each acceptance criterion;
- routes DESIGNER, VISION, ADVISOR, SMOL, or the semantic inspector only when the applicable profile and mode require them.

## Intent Profiles

## `intent-inquiry`

<!-- AGENTS_PROFILE_AUTHORING_START: intent-inquiry -->
### Applies when
The user explicitly requests an answer, explanation, or read-only assessment.

### Authoring rubric — orchestrator
- State the question and named evidence sources.
- State that project files must not be edited.
<!-- AGENTS_PROFILE_AUTHORING_END: intent-inquiry -->

### Runtime rubric — PLAN
- Inspect only enough evidence to answer reliably.
- Keep command outputs and temporary analysis outside the project when practical.
- Do not spawn SMOL or perform cleanup.

### Validation obligations
- Support the answer with directly inspected evidence and mark uncertainty.

## `intent-diagnosis`

<!-- AGENTS_PROFILE_AUTHORING_START: intent-diagnosis -->
### Applies when
The user requests root-cause analysis, failure explanation, or rollback advice without edits.

### Authoring rubric — orchestrator
- Capture the symptom, known reproduction, and non-editing boundary.
- Request a concrete cause and next action.
<!-- AGENTS_PROFILE_AUTHORING_END: intent-diagnosis -->

### Runtime rubric — PLAN
- Reproduce or establish the failure when practical.
- Separate observed cause from hypothesis; do not edit or spawn SMOL.

### Validation obligations
- Report root cause, supporting evidence, uncertainty, and a bounded next action.

## `intent-repair`

<!-- AGENTS_PROFILE_AUTHORING_START: intent-repair -->
### Applies when
The task fixes a broken, buggy, corrupted, or incorrect artifact.

### Authoring rubric — orchestrator
- Capture the reported defect, expected behavior, and protected compatibility boundaries.
- Require source-level correction rather than warning suppression.
<!-- AGENTS_PROFILE_AUTHORING_END: intent-repair -->

### Runtime rubric — PLAN
- Diagnose before checklist freeze.
- Prefer narrow local edits and sequence required cross-subsystem changes.

### Validation obligations
- Reproduce or establish the defect when practical, then prove it is gone with the focused artifact check.

## `intent-feature-implementation`

<!-- AGENTS_PROFILE_AUTHORING_START: intent-feature-implementation -->
### Applies when
The task adds new behavior, files, components, or a coordinated feature.

### Authoring rubric — orchestrator
- Capture requested behavior, named interfaces, compatibility constraints, and observable outcomes.
- Keep discoverable architecture and file locations for PLAN to inspect.
<!-- AGENTS_PROFILE_AUTHORING_END: intent-feature-implementation -->

### Runtime rubric — PLAN
- Define file-by-file behavior, interfaces, data flow, boundaries, and error states.
- Reuse established architecture and make checklist items independently verifiable.

### Validation obligations
- Verify each requested behavior with focused project-native checks; add a test only for a new observable contract without existing coverage.

## `intent-refactor`

<!-- AGENTS_PROFILE_AUTHORING_START: intent-refactor -->
### Applies when
The task restructures internals without observable behavior change.

### Authoring rubric — orchestrator
- Name the intended structural change and behavior-preservation boundary.
- Preserve public compatibility unless explicitly authorized otherwise.
<!-- AGENTS_PROFILE_AUTHORING_END: intent-refactor -->

### Runtime rubric — PLAN
- Establish callers and public surfaces before choosing edits.
- Use LSP and syntax-aware navigation when available.

### Validation obligations
- Prove behavior is preserved at affected interfaces and run broader regression checks only when the changed boundary requires them.

## `intent-optimization`

<!-- AGENTS_PROFILE_AUTHORING_START: intent-optimization -->
### Applies when
The task improves measurable performance or resource use without behavior change.

### Authoring rubric — orchestrator
- Capture the metric, workload, baseline expectation, and behavior-preservation constraint.
<!-- AGENTS_PROFILE_AUTHORING_END: intent-optimization -->

### Runtime rubric — PLAN
- Measure before changing; reject speculative complexity without evidence.
- Preserve numerical accuracy and observable behavior.

### Validation obligations
- Compare the same representative workload before and after and run the focused correctness check.

## `intent-translation`

<!-- AGENTS_PROFILE_AUTHORING_START: intent-translation -->
### Applies when
The task translates text while preserving protected structure and meaning.

### Authoring rubric — orchestrator
- Capture source and target language, scope, terminology references, and do-not-translate tokens.
<!-- AGENTS_PROFILE_AUTHORING_END: intent-translation -->

### Runtime rubric — PLAN
- Preserve identifiers, equations, citations, paths, labels, placeholders, and document structure.
- Use one terminology consistently.

### Validation obligations
- Compare structure and protected tokens, then inspect representative translated passages for meaning and fluency.

## `intent-formatting`

<!-- AGENTS_PROFILE_AUTHORING_START: intent-formatting -->
### Applies when
The user requests a cosmetic formatting, spacing, or layout rule without semantic edits.

### Authoring rubric — orchestrator
- Capture the exact formatting rule, scope, examples, and protected semantics.
- Do not imply broader prose or code cleanup.
<!-- AGENTS_PROFILE_AUTHORING_END: intent-formatting -->

### Runtime rubric — PLAN
- Infer the smallest consistent rule from prompt examples and existing conventions.
- Preserve content, control tokens, comments, and structure.

### Validation obligations
- Prove the requested formatting rule and semantic invariants with representative evidence; do not default to exhaustive visual comparison.

## `intent-conversion`

<!-- AGENTS_PROFILE_AUTHORING_START: intent-conversion -->
### Applies when
The task converts one artifact format to another.

### Authoring rubric — orchestrator
- Capture input, output format, fidelity requirements, output location, and protected originals.
<!-- AGENTS_PROFILE_AUTHORING_END: intent-conversion -->

### Runtime rubric — PLAN
- Define what must survive exactly: structure, order, equations, figures, tables, labels, citations, links, metadata, and paths as applicable.
- Prefer new outputs; never destroy originals without exact authorization.

### Validation obligations
- Render or parse the result and compare representative structure and protected content against the source.

## Artifact Profiles

## `artifact-code`

<!-- AGENTS_PROFILE_AUTHORING_START: artifact-code -->
### Applies when
The target includes source code, scripts, libraries, applications, build files, or tests.

### Authoring rubric — orchestrator
- Capture requested behavior, named APIs, compatibility constraints, and explicit validation expectations.
- Leave repository structure, callers, and native commands for PLAN to discover.
<!-- AGENTS_PROFILE_AUTHORING_END: artifact-code -->

### Runtime rubric — PLAN
- Inspect relevant architecture, references, callers, tests, and project conventions.
- Use LSP for symbol navigation and syntax-aware tools for structural work.
- Preserve public APIs unless the prompt explicitly authorizes change.

### Validation obligations
- Exercise the changed behavior with focused project-native tests/builds and add tests only for an uncovered new contract.

## `artifact-web-ui`

<!-- AGENTS_PROFILE_AUTHORING_START: artifact-web-ui -->
### Applies when
The target includes web pages, browser interfaces, components, styles, or user interaction.

### Authoring rubric — orchestrator
- Capture target pages/components, user-visible outcomes, supplied references, required states, and viewport constraints.
- Require DESIGNER before implementation and after rendering.
<!-- AGENTS_PROFILE_AUTHORING_END: artifact-web-ui -->

### Runtime rubric — PLAN
- Spawn DESIGNER before checklist freeze for an implementation-ready specification.
- Inspect the real interface in a browser when runnable.
- After SMOL, exercise the UI in PLAN's browser and spawn DESIGNER for visual review.
- Preserve the existing design system and accessibility conventions.

### Validation obligations
- Exercise actual interaction, relevant state and viewport behavior, accessibility structure, and browser diagnostics.

### Cross-profile interfaces
- Add `evidence-visual-browser-pdf` when visual correctness is part of the result.

## `artifact-configuration-data`

<!-- AGENTS_PROFILE_AUTHORING_START: artifact-configuration-data -->
### Applies when
The target is configuration, structured data, secrets, or generated data.

### Authoring rubric — orchestrator
- Capture schema or consumer expectations, ordering/comment preservation, and secret-handling boundaries.
<!-- AGENTS_PROFILE_AUTHORING_END: artifact-configuration-data -->

### Runtime rubric — PLAN
- Preserve comments and formatting where practical; avoid unrelated normalization.
- Treat credentials and live secrets as opaque and never expose them.
- Identify consumers before changing keys or schema.

### Validation obligations
- Parse or schema-check changed data and verify affected consumers with focused evidence; read-only work must not create project-local artifacts.

## `artifact-document-latex`

<!-- AGENTS_PROFILE_AUTHORING_START: artifact-document-latex -->
### Applies when
The target includes LaTeX sources, bibliographies, figures, classes, or document builds.

### Authoring rubric — orchestrator
- Capture named source/reference files, requested textual or structural outcome, and preserved math, labels, citations, figures, paths, and document order.
- Require project-native compilation and affected-page inspection when the result is visual.
<!-- AGENTS_PROFILE_AUTHORING_END: artifact-document-latex -->

### Runtime rubric — PLAN
- Inspect root and included inputs plus build configuration, and identify task-relevant rendered pages. When `evidence-visual-browser-pdf` requires PDF fidelity, assign those pages to VISION under its exact evidence contract rather than inspecting them in PLAN.
- Preserve mathematical meaning, labels, cross-references, citations, filenames, and order.
- Treat OCR corruption narrowly and do not trust compilation alone.
- Use the project-native LaTeX pipeline.

### Validation obligations
- Compile once to convergence as the project requires and check task-relevant undefined-reference, warning, and overfull diagnostics. When the requested result is visual, require the role designated by the selected evidence profile to inspect directly affected pages or a small representative sample.

### Cross-profile interfaces
- Eligible mutating work follows `references/latex-cleanup.md` only after all validation passes.

## `artifact-document-generic`

<!-- AGENTS_PROFILE_AUTHORING_START: artifact-document-generic -->
### Applies when
The target is Markdown, plain text, DOCX, RTF, EPUB, or another non-LaTeX prose document.

### Authoring rubric — orchestrator
- Capture requested content change, structure to preserve, terminology, links, references, and output format.
<!-- AGENTS_PROFILE_AUTHORING_END: artifact-document-generic -->

### Runtime rubric — PLAN
- Preserve headings, lists, tables, links, metadata, document order, and source formatting conventions unless change is requested.
- Do not create extra documentation files.

### Validation obligations
- Parse or render the changed artifact and compare affected structure and representative passages.

## `artifact-generic-files`

<!-- AGENTS_PROFILE_AUTHORING_START: artifact-generic-files -->
### Applies when
The task concerns images, archives, directories, binaries, or mixed file operations not covered elsewhere.

### Authoring rubric — orchestrator
- Capture exact input and output paths, required transformation, preservation boundaries, and authorized filesystem effects.
<!-- AGENTS_PROFILE_AUTHORING_END: artifact-generic-files -->

### Runtime rubric — PLAN
- Establish types, metadata, ownership, and destination behavior before mutation.
- Preserve originals by default and never overwrite or delete without exact authorization.

### Validation obligations
- Verify expected outputs, paths, counts, metadata, and readability with the artifact-appropriate tool.

## Evidence Overlays

## `evidence-build-test`

<!-- AGENTS_PROFILE_AUTHORING_START: evidence-build-test -->
### Applies when
Correctness requires a build, test, schema check, render, or diagnostic.

### Authoring rubric — orchestrator
- Snapshot only prompt-named commands or expected outcomes.
- Leave project-native command discovery to PLAN.
<!-- AGENTS_PROFILE_AUTHORING_END: evidence-build-test -->

### Runtime rubric — PLAN
- Choose the narrowest project-native command that proves the acceptance criterion.
- Do not stack equivalent checks or default to full suites, broad formatters, or warning sweeps.

### Validation obligations
- Record the exact command, status, and focused result; a committed check that cannot run is failed or blocked.

## `evidence-visual-browser-pdf`

<!-- AGENTS_PROFILE_AUTHORING_START: evidence-visual-browser-pdf -->
### Applies when
Correctness requires screenshots, browser states, rendered PDF pages, images, or fidelity comparison.

### Authoring rubric — orchestrator
- Capture supplied references, named pages/states/viewports, and whether fidelity is representative or exhaustive.
<!-- AGENTS_PROFILE_AUTHORING_END: evidence-visual-browser-pdf -->

### Runtime rubric — PLAN
- Establish visual correctness from image/page evidence; do not infer rendered correctness from source.
- For web/UI, use PLAN's browser plus DESIGNER pre/post review.
- For supplied or rendered PDF/image fidelity, PLAN chooses uniquely identified local reference/target inputs, explicit comparison pairs or standalone sites, the exact pages, bounded criteria, suitable default DPI, and whether follow-up crops are allowed, then routes that complete contract to VISION. VISION uses its restricted renderer for private temporary PNGs and returns image-based findings keyed to those identifiers; PLAN does not render or visually inspect those pages itself.
- When the contract allows follow-up crops and a full page is insufficient, VISION may choose bounded normalized crop coordinates within an assigned page and criterion. It must ask PLAN for any new page or evidence set and may not expand the assigned inputs, pages, pairs, or criteria autonomously. Use exhaustive comparison only when explicitly required or focused evidence cannot prove the result.

### Validation obligations
- Report every inspected input or comparison identifier, page or site, material discrepancy, and evidence limitation. Required PDF/image fidelity passes only when VISION inspected image evidence for every assigned pair or standalone site. An uncorrectable `VISION_FAIL` blocks the criterion and run rather than being treated as a visual discrepancy or replaced by PLAN inspection or text extraction.

## `evidence-source-reference`

<!-- AGENTS_PROFILE_AUTHORING_START: evidence-source-reference -->
### Applies when
A specification, original document, screenshot, source passage, URL, or reference file defines correctness.

### Authoring rubric — orchestrator
- Name the supplied references and the aspects they govern.
- Do not invent precedence among conflicting sources.
<!-- AGENTS_PROFILE_AUTHORING_END: evidence-source-reference -->

### Runtime rubric — PLAN
- Establish the authoritative source and the structural, semantic, behavioral, or visual equivalence required.
- Use the semantic inspector only for a narrow high-stakes suspect set that structural inspection cannot settle.

### Validation obligations
- Compare output against the reference and report all material discrepancies and uncertainty.

## Fallback Profile

## `generic-fallback`

<!-- AGENTS_PROFILE_AUTHORING_START: generic-fallback -->
### Applies when
No specific artifact profile reliably classifies the task.

### Authoring rubric — orchestrator
- Capture prompt-grounded intent, inputs, scope, protected boundaries, and observable outcome.
- Keep uncertain format and project facts under PLAN-discoverable facts.
<!-- AGENTS_PROFILE_AUTHORING_END: generic-fallback -->

### Runtime rubric — PLAN
- On first inspection, discover the artifact type and replace `generic-fallback` once in the runtime-loaded profile set with exactly one specific artifact profile. Keep the authored workflow unchanged.
- Never infer the primary intent from the target. When a fallback-only run requires a mutating intent, establish it through the run's single user-decision reply before checklist freeze; block if that reply is unavailable or cannot settle the intent safely.
- If exactly one specific artifact profile cannot be established from inspection, block rather than retaining fallback, guessing, or asking the user for a discoverable fact.
- Prefer read-only discovery and minimal changes until artifact, intent, and scope are clear.

### Validation obligations
- Apply the resolved artifact profile's obligations and report the runtime fallback resolution.
