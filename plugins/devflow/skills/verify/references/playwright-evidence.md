# Playwright evidence setup

## TypeScript / JavaScript

`tests/e2e/evidence.ts` — a fixture that saves named screenshots into the evidence folder and attaches them to the HTML report:

```ts
import { test as base, expect } from '@playwright/test';
import fs from 'node:fs';
import path from 'node:path';

const EVIDENCE_DIR = process.env.DEVFLOW_EVIDENCE_DIR ?? '.devflow/evidence';

type Evidence = { evidence: (name: string) => Promise<void> };

export const test = base.extend<Evidence>({
  evidence: async ({ page }, use, testInfo) => {
    fs.mkdirSync(EVIDENCE_DIR, { recursive: true });
    await use(async (name: string) => {
      const file = path.join(EVIDENCE_DIR, `${name}.png`);
      await page.screenshot({ path: file, fullPage: true });
      await testInfo.attach(name, { path: file, contentType: 'image/png' });
    });
  },
});

export { expect };
```

Usage:

```ts
import { test, expect } from './evidence';

test('AC-1: user can add a todo with a due date', async ({ page, evidence }) => {
  await page.goto('/');
  await evidence('AC-1-before');
  await page.getByLabel('Title').fill('Buy milk');
  await page.getByLabel('Due date').fill('2026-12-31');
  await page.getByRole('button', { name: 'Add' }).click();
  await expect(page.getByText('Buy milk')).toBeVisible();   // assert first,
  await evidence('AC-1-todo-created');                        // then capture proof
});
```

Relevant `playwright.config.ts` settings:

```ts
use: {
  baseURL: 'http://localhost:3000',
  screenshot: 'only-on-failure',
  trace: 'retain-on-failure',
  video: 'retain-on-failure',
},
reporter: [['list'], ['html', { open: 'never' }]],
webServer: {
  command: 'npm run dev',          // adjust to the project's dev command
  url: 'http://localhost:3000',
  reuseExistingServer: true,
  timeout: 120_000,
},
```

Run: `DEVFLOW_EVIDENCE_DIR=.devflow/<slug>/evidence npx playwright test`

## Python (pytest-playwright)

```python
import os
from pathlib import Path
import pytest

EVIDENCE_DIR = Path(os.environ.get("DEVFLOW_EVIDENCE_DIR", ".devflow/evidence"))

@pytest.fixture
def evidence(page):
    EVIDENCE_DIR.mkdir(parents=True, exist_ok=True)
    def capture(name: str):
        page.screenshot(path=str(EVIDENCE_DIR / f"{name}.png"), full_page=True)
    return capture
```

Run: `DEVFLOW_EVIDENCE_DIR=.devflow/<slug>/evidence pytest tests/e2e`

## Good evidence

- Always assert first, capture second, so a screenshot never "proves" a broken state.
- Use stable selectors (role, label, test id), not CSS classes.
- Make data deterministic (seeded or created in the test) so screenshots are reproducible.
- Prefer full-page shots; crop is unnecessary.
