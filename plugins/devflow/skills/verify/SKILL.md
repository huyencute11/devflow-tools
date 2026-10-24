---
name: verify
description: Verify a devflow change against its acceptance criteria by running the full test suite and Playwright end-to-end tests that capture screenshot evidence per criterion, then build an AC-to-evidence verification matrix. Use when the user says "/devflow:verify", "test it and capture evidence", "run playwright and take screenshots", or after the review phase of the devflow workflow.
---

# devflow: verify

Prove every acceptance criterion with a passing test and, for UI behaviour, a screenshot someone else can look at.

## Steps

1. Read the AC list and test plan in `02-design.md`. Evidence folder: `docs/devflow/<slug>/evidence/`.
2. **Unit/integration:** run the full suite. Save the summary output to `evidence/test-results.txt` (trim noise; keep the pass/fail summary and AC-named test lines).
3. **E2E (for every AC tagged `e2e`):**
   - If Playwright is not set up, propose the setup (`npm init playwright@latest`, or `pip install pytest-playwright && playwright install chromium` for Python) and ask before installing.
   - Use the evidence helper and config in `references/playwright-evidence.md`. Configure the dev server via `webServer` so tests start the app themselves.
   - In each e2e test, capture a screenshot at the moment that proves the "Then" of the AC, named `AC-<n>-<short-state>.png` (e.g. `AC-1-item-created.png`). Capture a "before" shot too when the change is easier to understand as before/after.
   - Run with `DEVFLOW_EVIDENCE_DIR=docs/devflow/<slug>/evidence`. Keep trace and video on failure only.
   - Look at each screenshot (open the image) to confirm it actually shows the expected state, not a blank page, spinner, or error overlay. Retake if needed.
4. **Non-UI ACs** (API, CLI): save the request and response or command output as `evidence/AC-<n>-<state>.txt`.
5. Build the matrix: run `bash scripts/evidence-index.sh docs/devflow/<slug>/evidence` (relative to this skill's directory) to list evidence files, then write `docs/devflow/<slug>/04-verification.md`:
   - Table: AC | description | test | result | evidence file(s)
   - Overall result, test counts, lint/typecheck status
   - Anything not verified, with reason
6. Launch the **acceptance-auditor** agent to check that each AC's test would really fail if the behaviour broke. Add its verdict to the file.

## Checkpoint

Present the matrix and any failed/unverified ACs. If anything failed, propose a fix and go back to implement only with the user's approval. Otherwise ask whether to ship. Stop and wait.

Do not commit trace/video artifacts; commit only the screenshots and text evidence in `docs/devflow/<slug>/evidence/`.
