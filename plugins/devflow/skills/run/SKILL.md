---
name: run
description: Run the full devflow engineering workflow on a problem or feature request, from analysis to pull request, pausing at human approval checkpoints. Use when the user says "/devflow:run", "solve this end to end", "take this task from analysis to PR", or hands over a coding task or interview exercise to be completed with a disciplined process. Supports a --lite mode for time-boxed sessions such as interviews.
argument-hint: "[--lite] <problem statement or path to spec>"
---

# devflow: full workflow orchestrator

Drive a task through six phases. Each phase has its own skill; follow that skill's instructions when entering the phase. Respond to the user in the language they write in; keep all files in English unless the user asks otherwise.

## Phases

| # | Phase | Skill | Output file (in `docs/devflow/<slug>/`) | Checkpoint |
|---|-------|-------|------------------------------------------|------------|
| 0 | Setup (only if repo not prepared) | `setup` | `CLAUDE.md` at repo root | No |
| 1 | Analyze + clarifying questions | `analyze` | `01-analysis.md` | **Yes** – answers to questions |
| 2 | Design + acceptance criteria | `design` | `02-design.md` | **Yes** – approve design and ACs |
| 3 | Implement, test-first | `implement` | code + tests, commits | Light – summary |
| 4 | Review | `review` | `03-review.md` | **Yes** – choose fixes |
| 5 | Verify + capture evidence | `verify` | `04-verification.md`, `evidence/` | **Yes** – approve results |
| 6 | Ship: push + PR | `ship` | `05-pr-description.md`, PR | **Yes** – approve before push |

## Start

1. Parse `$ARGUMENTS`. If it contains `--lite`, use lite mode (below). The rest is the problem statement or a path to a spec file; read it.
2. Derive a short kebab-case `<slug>` from the problem (e.g. `todo-due-dates`). Create `docs/devflow/<slug>/`.
3. If the repo has no `CLAUDE.md` or the test/run commands are unknown, run the `setup` phase first.
4. Create `docs/devflow/<slug>/00-progress.md` with a checklist of phases and the start time. Update it at the end of every phase (status, time spent, key decisions).

## Checkpoint protocol

At every checkpoint:
- Summarise in at most ~10 lines what was produced and what decision is needed. Link the file instead of pasting it.
- Ask the user explicitly, using the AskUserQuestion tool when it is available; otherwise ask in plain text.
- **Stop and wait.** Do not start the next phase until the user approves, changes, or says to continue.
- Record the decision in the phase file under a `## Decision log` heading.

Skip checkpoints only if the user explicitly says "auto" / "no checkpoints". Even then, always stop before `ship` pushes anything.

## Lite mode (time-boxed, e.g. 60–90 min interview)

- Merge phases 1 and 2 into one document and one checkpoint: analysis + questions + design + ACs together in `01-analysis.md`.
- Limit ACs to the 3–6 that matter most; mark the rest "out of scope / follow-up".
- Review: one `code-reviewer` pass; fix only Critical and Major findings.
- Verify: e2e evidence only for the main happy path and one important edge case; unit tests for the rest.
- Suggested budget for 60 min: analyze+design 12, implement 25, review 8, verify 10, ship 5. Report elapsed time at each checkpoint so the user can adjust scope.

## Rules throughout

- Never change an approved acceptance criterion silently. If it must change, stop and ask.
- Never weaken or delete a test to make it pass without flagging it to the user.
- Prefer small, reviewable commits with conventional commit messages.
- If something blocks progress (missing dependency, failing unrelated test, unclear requirement), stop and report it with options rather than guessing.
- When explaining a choice at a checkpoint, give the reason in one sentence. The user may be narrating this process to an interviewer.
