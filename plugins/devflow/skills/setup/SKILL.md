---
name: setup
description: Prepare a repository for the devflow workflow by detecting the stack and the build, test, lint and run commands, checking Playwright and GitHub CLI availability, and writing or updating CLAUDE.md. Use when the user says "/devflow:setup", "set up this repo for AI", "prepare the project", or when the run skill finds the project commands are unknown.
---

# devflow: setup

Get the repository into a state where the other phases can run without guessing.

## Steps

1. **Detect the stack.** Inspect `package.json`, `pyproject.toml`, `requirements*.txt`, `go.mod`, `pom.xml`, `Cargo.toml`, `Makefile`, Docker files, and the folder layout. Identify language, framework, package manager, test runner, and how the app is started.
2. **Find the commands** for install, run/dev server, unit tests, e2e tests, lint, format, typecheck. Run the cheap ones (lint, unit tests) once to confirm they work and note the baseline (e.g. "2 pre-existing failing tests").
3. **Check tooling** and report, without installing anything yet:
   - Playwright: present? (`npx playwright --version` or `pytest --version` with pytest-playwright)
   - GitHub CLI: `gh auth status`
   - git remote and default branch: `git remote -v`, `git symbolic-ref refs/remotes/origin/HEAD`
4. **Write or update `CLAUDE.md`** at the repo root. Keep it under ~60 lines:
   - One-paragraph project summary
   - Stack
   - Commands (exact, copy-pasteable)
   - Conventions observed (naming, folder structure, error handling, test location)
   - "Do not" list (e.g. do not edit generated files, migrations, lockfiles by hand)
   - Pointer: "Task docs live in `docs/devflow/<slug>/`"
   If `CLAUDE.md` exists, add missing items only; never delete the user's content.
5. **Report** a short table: tool → status → action needed. If Playwright or `gh` is missing, propose the install command and ask before running it.
