---
name: review
description: Review the changes on the current feature branch against the approved devflow design and acceptance criteria using an independent code-reviewer subagent, record findings by severity, and apply the fixes the user approves. Use when the user says "/devflow:review", "review the code", "review my changes", or after the implement phase of the devflow workflow.
---

# devflow: review

Get an independent, critical look at the change before verifying and shipping.

## Steps

1. Determine the base: the default branch (from `git symbolic-ref refs/remotes/origin/HEAD`, fallback `main`). Collect `git diff <base>...HEAD --stat` and the list of commits.
2. Launch the **code-reviewer** agent. Give it: the slug, the path to `02-design.md`, and the base branch. Let it read the diff and the files itself. Do not pre-summarise or defend the code to it; the point is a fresh perspective.
3. Write its findings to `.devflow/<slug>/03-review.md`: a table of ID, severity (Critical / Major / Minor / Nit), file:line, issue, suggested fix. Add your own brief note per finding: agree / disagree with reason.

## Checkpoint

Present: counts per severity and the Critical + Major items in one line each, with your recommendation (default: fix all Critical and Major, list Minor/Nit as follow-ups). Ask the user which to fix. Stop and wait.

## After the decision

- Apply the chosen fixes as separate commits: `fix(review): <what>` or `refactor(review): <what>`.
- Re-run the full test suite, lint, and typecheck.
- Update `03-review.md`: mark each finding Fixed / Won't fix (reason) / Follow-up.
