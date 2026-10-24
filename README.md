# devflow-tools

A Claude Code plugin marketplace containing **devflow**: a structured AI engineering workflow with human approval checkpoints.

```
Analyze ──► Design ──► Implement ──► Review ──► Verify ──► Ship
   │           │          (TDD)        │          │          │
 questions   ACs +                  choose     evidence    approve
 answered    design                 fixes      matrix      push + PR
 ✋           ✋                       ✋          ✋           ✋
```

## Install

1. Push this repository to GitHub (e.g. `your-user/devflow-tools`).
2. In Claude Code:

```
/plugin marketplace add your-user/devflow-tools
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
| `/devflow:setup` | Detect stack and commands, write `CLAUDE.md`, check Playwright and `gh` |
| `/devflow:analyze` | Restate problem, assumptions, edge cases, clarifying questions with defaults |
| `/devflow:design` | Approach + alternative, Given/When/Then acceptance criteria, test plan |
| `/devflow:implement` | Failing tests first, then code, small conventional commits |
| `/devflow:review` | Independent `code-reviewer` agent, findings by severity, apply chosen fixes |
| `/devflow:verify` | Full tests + Playwright screenshots per AC, `acceptance-auditor` check |
| `/devflow:ship` | Pre-flight checks, PR description with evidence, push + `gh pr create` |

Every phase writes a document to `docs/devflow/<slug>/`:

```
docs/devflow/<slug>/
├── 00-progress.md          phases, time, decisions
├── 01-analysis.md          questions + answers
├── 02-design.md            design + acceptance criteria + test plan
├── 03-review.md            findings and resolution
├── 04-verification.md      AC → test → result → evidence
├── 05-pr-description.md
└── evidence/               AC-1-*.png, test-results.txt ...
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

Before publishing, replace `YOUR_NAME` in both JSON manifests.
