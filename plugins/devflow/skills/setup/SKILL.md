---
name: setup
description: Prepare a repository for the devflow workflow. Handles two cases, an existing repository (verify remote and push access, no account setup) or a new project from scratch (collect GitHub owner, repo name and visibility, create the repo and push a baseline), then detects build, test and run commands, checks Playwright and GitHub CLI, and writes CLAUDE.md. Use when the user says "/devflow:setup", "set up this repo", "init the project", or when the run skill starts in a folder that is not ready.
---

# devflow: setup

Get the repository into a state where every later phase, including opening a PR, works without surprises. Respond in the user's language.

## Step 1 — Detect the repository case

Run `git rev-parse --is-inside-work-tree`, `git remote -v`, and list the folder.

- **Case A – existing repo**: a git repo with an `origin` remote (e.g. the interviewer provided it). Go to Step 2A.
- **Case B – new project**: no git repo, or git without a remote, or an empty folder. Go to Step 2B.

## Step 2A — Existing repo (no account setup needed)

1. Default branch: `git symbolic-ref refs/remotes/origin/HEAD` (fallback `main`). Make sure the local default branch is up to date (`git pull --ff-only`).
2. `gh auth status`. If not logged in, ask the user to run `gh auth login` themselves (never handle tokens or passwords).
3. Push access: `gh repo view --json viewerPermission -q .viewerPermission`. If it is not `WRITE`, `MAINTAIN` or `ADMIN`, tell the user and propose `gh repo fork --remote` so PRs go from a fork. Ask before forking.
4. Git identity: `git config user.name` and `git config user.email`. If empty, ask the user for them.

No question about account or repo name is needed in this case.

## Step 2B — New project (collect GitHub info first)

1. Gather defaults silently: `gh auth status`, `gh api user -q .login` (owner), `git config user.name`, `git config user.email`, folder name (repo name). If `gh` is missing or not logged in, ask the user to install it (`brew install gh`) and run `gh auth login` themselves, then continue.
2. Ask the user **once**, in one message (use AskUserQuestion if available), proposing defaults:
   - GitHub owner (default: logged-in account; may be an org)
   - Repository name (default: folder name)
   - Visibility: public / private (default: private)
   - Default branch name (default: `main`)
   - Git name/email only if not configured
   - Confirmation: "OK to create this repo and push the initial baseline and later the project scaffold to `main`?"
3. After the answers:
   - `git init -b <default-branch>` if not a repo yet.
   - Create `.gitignore` for the stack if known (otherwise a generic one) and make sure it contains `.devflow/`.
   - Initial commit: `chore: initial commit`, containing `.gitignore`, a minimal `README.md`, and `CLAUDE.md` once written (Step 4).
   - `gh repo create <owner>/<name> --<visibility> --source=. --remote=origin --push`.
   - Record in `.devflow/config.md`: `bootstrapped: true`, owner, repo, default branch. The implement phase uses this to push the scaffold to the default branch.

## Step 3 — Detect stack and commands

Inspect `package.json`, `pyproject.toml`, `requirements*.txt`, `go.mod`, `pom.xml`, `Cargo.toml`, `Makefile`, Docker files and the layout. Find install, dev server, unit test, e2e test, lint, format, typecheck commands. Run the cheap ones once to record a baseline (e.g. "2 pre-existing failing tests"). For an empty new project, note "stack to be decided in design".

Check Playwright (`npx playwright --version`, or pytest-playwright for Python). Report missing tools with the install command; ask before installing.

## Step 4 — Write or update CLAUDE.md

Keep it under ~60 lines: project summary, stack, exact commands, observed conventions, "do not" list, and "Working docs live in `.devflow/<slug>/` (gitignored)". If `CLAUDE.md` exists, only add missing items; never delete the user's content. In Case B, update it again after the scaffold exists.

Always make sure `.devflow/` is in `.gitignore` (both cases); commit that change only in Case B, or in Case A together with the first feature commit.

## Step 5 — Report

A short table: item → status → action needed (repo, remote, push access, gh auth, git identity, Playwright, commands).
