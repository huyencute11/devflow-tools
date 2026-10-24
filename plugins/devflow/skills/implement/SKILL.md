---
name: implement
description: Implement an approved devflow design test-first, writing failing tests for each acceptance criterion, then the code to make them pass, in small conventional commits on a feature branch. Use when the user says "/devflow:implement", "implement the design", "start coding", or after the design phase of the devflow workflow is approved.
---

# devflow: implement

Build exactly what the approved design says, proving each acceptance criterion with a test.

## Steps

1. Read `02-design.md`. Confirm the ACs are marked approved; if not, stop and ask.
2. Create a branch from the up-to-date default branch: `feat/<slug>` (or `fix/<slug>` for bugs). Never commit to the default branch.
3. **Red:** write the tests from the test plan first. Name each test with its AC ID (e.g. `"AC-2: rejects empty title"`) so results trace back to criteria. Run them and confirm they fail for the expected reason (not because of a typo or import error). Commit: `test(<scope>): add failing tests for <slug>`.
4. **Green:** implement in the order of the task breakdown. After each step run the relevant tests; commit when a step is green, e.g. `feat(<scope>): <what>`.
5. **Refactor** only within the touched code, keeping tests green.
6. Run the full unit/integration suite, lint, format, and typecheck. Fix what this change broke. Report pre-existing failures without fixing them unless asked.

## Guardrails

- If the design turns out to be wrong or incomplete, stop and explain the problem with options. Do not silently redesign.
- Do not change an AC or weaken a test assertion to get green. If a test seems wrong, say so and ask.
- No unrelated refactors, renames, or dependency upgrades. Note them as follow-ups instead.
- Add a new dependency only if the design mentions it, or after asking.
- Never write secrets, tokens, or real credentials into code or tests.

## Checkpoint (light)

Report: commits made, an AC status table (AC → test → pass/fail), lint/typecheck status, and anything deferred. Ask whether to continue to review. Stop and wait.
