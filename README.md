# devflow-tools

A Claude Code plugin marketplace containing **devflow**: a structured AI engineering workflow with human approval checkpoints.

```
Setup ──► Analyze ──► Design ──► Implement ──► Review ──► Verify ──► Ship
  │          │           │        (scaffold      │          │        (auto)
 repo +   questions    ACs +      + TDD)       choose    evidence   push, evidence,
 GitHub   answered     design                  fixes     + approve  PR created
 info ✋     ✋           ✋                       ✋        ship ✋
```

## Install

1. Push this repository to GitHub (e.g. `huyencute11/devflow-tools`).
2. In Claude Code:

```
/plugin marketplace add huyencute11/devflow-tools
/plugin install devflow@devflow-tools
```

Test locally before pushing:

```
/plugin marketplace add ./devflow-tools
/plugin install devflow@devflow-tools
```

Update later with `/plugin marketplace update devflow-tools`.

## Usage

| Command | What it does |
|---------|--------------|
| `/devflow:run <problem>` | Full workflow, all checkpoints |
| `/devflow:run --lite <problem>` | Time-boxed version for 60–90 min sessions (interviews) |
| `/devflow:setup` | Existing repo: check remote and push access. New project: ask GitHub owner/repo/visibility, create repo, push baseline. Then detect commands and write `CLAUDE.md` |
| `/devflow:analyze` | Restate problem, assumptions, edge cases, clarifying questions with defaults |
| `/devflow:design` | Approach + alternative, Given/When/Then acceptance criteria, test plan |
| `/devflow:implement` | New project: scaffold and push to `main` first. Then failing tests, code, small commits on `feat/<slug>` |
| `/devflow:review` | Independent `code-reviewer` agent, findings by severity, apply chosen fixes |
| `/devflow:verify` | Full tests + Playwright screenshots per AC, `acceptance-auditor` check; approval here = approval to ship |
| `/devflow:ship` | Pre-flight checks, push, publish screenshots, create PR with Why / What / Verification / Evidence |

Where things live:

```
.devflow/<slug>/            gitignored working docs — never committed
├── 00-progress.md          phases, time, decisions
├── 01-analysis.md          questions + answers
├── 02-design.md            design + acceptance criteria + test plan
├── 03-review.md            findings and resolution
├── 04-verification.md      AC → test → result → evidence
├── 05-pr-description.md    body used for the PR
└── evidence/               AC-1-*.png, test-results.txt ...

feat/<slug> branch          code, tests, config only
devflow-evidence branch     screenshots referenced by PRs (orphan, never merged)
Pull request                Why · What was implemented · Verification · Evidence images
```

## Requirements

- Claude Code
- git, and the GitHub CLI (`gh auth login`) for the ship phase
- Node.js (for `npx @playwright/mcp` and Playwright tests) or Python with `pytest-playwright`

## Contents

```
.claude-plugin/marketplace.json
plugins/devflow/
├── .claude-plugin/plugin.json
├── .mcp.json                       Playwright MCP for exploring the running app
├── agents/
│   ├── code-reviewer.md
│   └── acceptance-auditor.md
└── skills/
    ├── run/  setup/  analyze/  design/
    ├── implement/  review/  verify/  ship/
```

