# Canonical LaTeX Post-Success Cleanup

This is the single normative cleanup contract for Agents Flow. Other files summarize eligibility but do not duplicate commands or extension lists.

## Eligibility

Automatic cleanup runs only when all are true:

1. `artifact-document-latex` applies;
2. neither `intent-inquiry` nor `intent-diagnosis` is selected;
3. SMOL modified LaTeX project/build inputs, or the workflow explicitly requests cleanup; and
4. every committed acceptance check passed, including the final project-native compile, required diagnostics, and any required rendered-page inspection.

A successful compile alone is insufficient. If any committed check fails or is blocked, preserve intermediates and skip cleanup.

An explicit cleanup-only task may run without source edits or a fresh compile only when its finalized checklist and acceptance criteria authorize that outcome. It remains mutating work.

## Resolve the Build Boundary

Before deletion, PLAN records:

- project root and exact root document(s);
- actual output and auxiliary directories;
- project-native clean command or latexmk configuration;
- generated-file inventory from `.fls`, `.fdb_latexmk`, logs, build metadata, or a dedicated intermediate directory;
- protected artifacts: sources, `.bib`, `.bbl`, classes/styles, figures/assets, configuration, and final deliverables such as PDFs.

Do not assume the current directory is the build directory. If the boundary or generated inventory cannot be established safely, skip cleanup and report a process warning.

## Procedure

1. Prefer the project-native clean target only when inspection proves it removes generated intermediates and preserves every protected artifact.
2. Otherwise, when latexmk is available, run `latexmk -c <root-document>` from the resolved root with the same configuration and output/auxiliary-directory options used by the validated build. Run separately for each validated root when needed.
3. Immediately after the clean command, intersect the pre-established generated inventory with currently existing paths. Use one bounded existence check. If empty, cleanup is complete: do not issue removal commands or probe absent paths individually.
4. Only when that intersection is nonempty, or the clean command is unavailable/fails, remove the currently existing residual paths already identified as generated inside the boundary. Build the removal operation from that existence-filtered list; never pass absent paths.
5. After a residual removal operation, perform one final existence check limited to the attempted paths.
6. Never use a suffix-only current-directory sweep, recursively delete an unverified directory, or run `latexmk -C`.
7. Keep every protected artifact, including final PDFs and `.bbl` files.

A failed clean command never authorizes a broader fallback. PLAN may continue only with the pre-established bounded inventory.

## Verification and Reporting

After cleanup, PLAN:

1. checks the clean/removal command status;
2. reuses the empty post-clean intersection as final proof, or the single post-removal check when residual removal ran;
3. confirms root source documents and final deliverables still exist;
4. does not recompile, rerender, rehash, or reinspect artifacts solely because cleanup ran;
5. reports the mechanism, boundary, and one outcome:
   - **cleaned** — no generated inventory path remains;
   - **partial warning** — protected artifacts are intact but named residuals or a step failed;
   - **skipped warning** — an eligibility or boundary condition was not established.

Never report cleaned after a partial or failed cleanup. Never issue a removal command just to prove an absent path is absent.

## Failure and Recovery

Automatic cleanup is post-success housekeeping, not validation. A cleanup failure is non-fatal when the requested LaTeX result and every committed check already succeeded. When cleanup is itself the requested deliverable, incomplete cleanup fails the task.

A successful or bounded partial cleanup does not by itself require a recovery packet. Unexpected deletion, protected-artifact change, or suspected corruption follows `references/safety.md` and blocks the run.
