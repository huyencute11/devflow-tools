---
name: design
description: Turn an approved analysis into a technical design with testable acceptance criteria (Given/When/Then, numbered AC-1, AC-2...) and a test plan mapping each criterion to a test, then pause for approval. Use when the user says "/devflow:design", "design the solution", "write acceptance criteria", or after the analyze phase of the devflow workflow is approved.
---

# devflow: design

Decide how to build it and define exactly what "done" means. Write no production code in this phase.

## Steps

1. Read `.devflow/<slug>/01-analysis.md` including the answers. If questions are still unanswered, stop and ask.
2. Write `.devflow/<slug>/02-design.md` following `references/design-template.md`.
3. Approach:
   - Give the chosen approach and **one** realistic alternative with the reason it was not chosen.
   - List files to create/modify and the responsibility of each.
   - Define contracts that other parts rely on: API routes and payloads, function signatures, DB schema changes, UI states.
   - Follow existing patterns from the codebase; call out any deliberate deviation.
4. Acceptance criteria:
   - Each AC is observable behaviour, written as Given / When / Then, numbered `AC-1`, `AC-2`...
   - Cover the happy path, validation/error cases, and the edge cases from the analysis that are in scope.
   - Tag each AC with the test level that will prove it: `unit`, `integration`, or `e2e`. Use `e2e` for anything a user sees in the UI; these produce screenshot evidence later.
   - Each AC must be checkable by an automated test. If one is not, rewrite it until it is, or mark it `manual` with a reason.
5. Test plan: a table mapping every AC to the test file and test name that will cover it.
6. Task breakdown: ordered small steps, each ending in a commit.

## Checkpoint

Present: the approach in 3–4 lines, the AC list (IDs + one-line summary each), and any open risk. Ask the user to approve, or to edit/add/remove ACs. Stop and wait.

After approval, freeze the ACs: record "ACs approved" with the time in the decision log. Later changes to ACs require a new checkpoint.
