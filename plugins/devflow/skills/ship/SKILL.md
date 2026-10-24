---
name: ship
description: Ship a verified devflow change end to end, running pre-flight checks, pushing the feature branch, publishing screenshot evidence to a separate evidence branch, and creating the pull request with a description covering Why, What was implemented, Verification and embedded Evidence images. Use when the user says "/devflow:ship", "push and create the PR", "open a pull request", or right after the user approves the verify checkpoint of the devflow workflow.
argument-hint: "[base-branch] [--draft]"
---

# devflow: ship

Push the work and open a PR a reviewer can approve without asking questions. Code, tests and config go to the feature branch; screenshots go to the PR description only.

## Approval

Run only after the user has approved shipping: either a "yes" at the verify checkpoint, or the user invoking this skill directly. That approval covers the whole ship phase; do not stop again unless a pre-flight check fails.

## Pre-flight (stop and report if any fails)

1. `.devflow/<slug>/04-verification.md` exists and every in-scope AC passes.
2. On the feature branch, not the default branch. `git status` shows no stray changes; `.devflow/` is gitignored and nothing under it is tracked (`git ls-files .devflow` is empty).
3. Base branch: argument if given, else the remote default branch. `git fetch origin` and rebase onto `origin/<base>`; if anything changed, re-run the test suite.
4. Secret scan of `git diff origin/<base>...HEAD`: API keys, tokens, passwords, private keys, `.env` files. Stop if anything looks suspicious.
5. Feature diff must not contain screenshots or evidence files. If any were committed, remove them from the branch in a new commit.
6. `gh auth status` succeeds and the remote is reachable.

## Steps

1. **Push the feature branch:** `git push -u origin <branch>`.
2. **Publish evidence** (if the evidence folder has images): run
   `bash scripts/publish-evidence.sh .devflow/<slug>/evidence <branch-with-slashes-replaced-by-dashes>`
   (path relative to this skill's directory). It commits the images to the `devflow-evidence` orphan branch, which is never merged, and prints `<file>\t<url>` per image. Use those URLs in the PR body.
   If the repo is a fork without push access to upstream, the script pushes to the fork's `origin`, which is fine.
3. **Write the PR description** from `references/pr-template.md` into `.devflow/<slug>/05-pr-description.md`. Fill it from the devflow documents:
   - **Why** ← problem restatement and answers in `01-analysis.md`
   - **What was implemented** ← approach and changes in `02-design.md`, plus the commit list
   - **Verification** ← test commands and counts, AC matrix from `04-verification.md`, review summary from `03-review.md`
   - **Evidence** ← one image per AC that has a screenshot, with a one-line caption of what it proves; text evidence (API/CLI output) as short fenced blocks, trimmed to the relevant lines
   Keep it scannable: no walls of text, no internal file paths under `.devflow/` (they are not in the repo).
4. **Create the PR:**
   `gh pr create --base <base> --head <branch> --title "<conventional title>" --body-file .devflow/<slug>/05-pr-description.md`
   Add `--draft` if requested. Title example: `feat(todos): add due dates to todos`.
5. **Check it rendered:** `gh pr view --json url,body -q .url`. If images were published, open one URL with `curl -sI` (public repos) to confirm it resolves; for private repos tell the user images display only for people with repo access.
6. **Report:** PR URL, branch, number of commits, ACs passed, evidence images attached. Mark all phases done in `.devflow/<slug>/00-progress.md` with total time.

## If something fails

- `gh` missing or not logged in: ask the user to run `gh auth login`; meanwhile leave the body file ready and give the exact `gh pr create` command.
- Evidence publish fails: still create the PR with the text evidence, list the screenshot file names, and tell the user how to drag them into the PR on GitHub.
