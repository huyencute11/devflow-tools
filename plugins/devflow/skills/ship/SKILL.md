---
name: ship
description: Ship a verified devflow change by checking the branch is clean and safe, writing a pull request description with acceptance-criteria evidence and screenshots, pushing the branch and opening the PR with the GitHub CLI after explicit user approval. Use when the user says "/devflow:ship", "push and create the PR", "open a pull request", or after the verify phase of the devflow workflow is approved.
disable-model-invocation: true
argument-hint: "[base-branch]"
---

# devflow: ship

Push the work and open a PR that a reviewer can approve without asking questions.

## Pre-flight (stop and report if any fails)

1. `04-verification.md` exists and all in-scope ACs pass. If not, stop.
2. On the feature branch, not the default branch. Working tree clean except intended files.
3. Base branch: `$ARGUMENTS` if given, else the remote default branch. Fetch and rebase onto it (or merge if the repo uses merges); re-run tests if anything changed.
4. Secret scan on the diff: `git diff <base>...HEAD` — look for API keys, tokens, passwords, `.env` files, private keys. Stop if anything suspicious.
5. Commit the devflow docs and evidence: `docs(devflow): add analysis, design and evidence for <slug>`.
6. `gh auth status` succeeds. If `gh` is missing or not logged in, prepare everything and give the user the exact manual commands at the end.

## Write the PR description

1. Fill `references/pr-template.md` and save it as `docs/devflow/<slug>/05-pr-description.md`.
2. Title: conventional format, e.g. `feat(todos): add due dates to todos`.
3. Screenshots: GitHub does not resolve relative image paths in PR descriptions. After pushing, build absolute URLs pinned to the commit:
   `https://github.com/<owner>/<repo>/blob/<commit-sha>/docs/devflow/<slug>/evidence/<file>.png?raw=true`
   Get `<owner>/<repo>` from `gh repo view --json nameWithOwner -q .nameWithOwner` and the SHA from `git rev-parse HEAD`.
4. Keep it scannable: summary in 2–3 lines, AC table with evidence, and only the screenshots that prove an AC.

## Checkpoint (mandatory, even in auto mode)

Show the PR title, the target branch, the commit list, and the first lines of the description. Ask for approval to push and open the PR. Stop and wait.

## After approval

1. `git push -u origin <branch>`
2. Insert the screenshot URLs (they resolve now that the commit is pushed).
3. `gh pr create --base <base> --head <branch> --title "<title>" --body-file docs/devflow/<slug>/05-pr-description.md`
   Add `--draft` if the user asked for a draft.
4. Report the PR URL. Mark all phases done in `00-progress.md` with total time.
