---
name: analyze
description: Analyze a problem statement or feature request before any design or code, restating the problem, listing assumptions, edge cases and risks, and producing clarifying questions with proposed defaults, then pausing for answers. Use when the user says "/devflow:analyze", "analyze this requirement", "what do we need to clarify", or at the start of the devflow run workflow.
argument-hint: "<problem statement or path to spec>"
---

# devflow: analyze

Understand the problem well enough that design cannot go in the wrong direction. Write no production code in this phase.

## Steps

1. Read the problem (`$ARGUMENTS`, or the file it points to). Read `CLAUDE.md`.
2. Explore the codebase only as far as needed: entry points, the modules the change will touch, existing tests for those modules, similar existing features to copy patterns from. Use the Playwright MCP to look at the running app if the task is UI-related and the app can be started.
3. Write `.devflow/<slug>/01-analysis.md` following `references/analysis-template.md`.
4. Make the questions good:
   - Ask only questions whose answer would change the design, the scope, or the acceptance criteria. Drop anything that is a pure implementation detail.
   - Order by impact. At most 5–7 questions; in lite mode at most 3–4.
   - For every question give a **proposed default** and why, so the user can answer "accept defaults".
   - Phrase them so the user can read them aloud to a stakeholder or interviewer as-is.

## Checkpoint

Present: a 2–3 line problem restatement, then the numbered questions with defaults. Ask the user to answer each, or accept defaults. Stop and wait.

After the reply, record answers in the `## Answers` section, update assumptions accordingly, and mark the phase done in `00-progress.md` if it exists.
