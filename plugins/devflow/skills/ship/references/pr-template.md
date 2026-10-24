## Why
<2–4 sentences: the problem or user need, who is affected, and why it matters now.>

<Key clarifications agreed before building, if any:>
- <question> → <decision>

## What was implemented
<1–2 sentences summarising the solution.>

- <change 1: user-visible behaviour or component>
- <change 2>
- <change 3>

**Approach:** <one line>. Considered <alternative>, not chosen because <reason>.

## Verification
**Unit / integration tests:** `<test command>` → <N passed, 0 failed>
**E2E (Playwright):** `<e2e command>` → <N passed>
**Lint / typecheck:** <passed>
**Code review:** <N findings, all Critical/Major fixed; follow-ups listed below>

| AC | Acceptance criterion | Test | Result |
|----|----------------------|------|--------|
| AC-1 | <Given/When/Then, short> | `<test name>` | ✅ |
| AC-2 | ... | ... | ✅ |

## Evidence
**AC-1 — <what this screenshot proves>**
![AC-1](<url>)

**AC-2 — <what this proves>**
![AC-2](<url>)

<For non-UI ACs, a trimmed output block:>
```
<request / response or command output>
```

## How to test locally
```bash
<install>
<run>
<test>
```

## Notes
- Follow-ups: <list or "none">
- Known limitations: <list or "none">
