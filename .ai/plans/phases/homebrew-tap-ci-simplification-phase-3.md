---
id: 87608F52-FF6B-47B1-91E7-DE112771DE64
title: "Phase 3: Verify & Test"
status: "⏳ Pending"
date: 2025-01-13
author: Claude
related:
  - 94D957ED-BC40-4696-B9FA-9EB936B830CE
  - A6AC0C95-DE40-4165-AA13-43A8764F44EC
---

# Phase 3: Verify & Test

## Objective

Validate that the new `bump-formulas.yml` workflow functions correctly by running manual tests and verifying all integrations work as expected.

## Prerequisites

Before starting this phase:

- [ ] Phase 2 completed (workflow file created and committed)
- [ ] Changes pushed to `main` branch (or test branch)
- [ ] Access to GitHub Actions tab for the repository

## Tasks

### 3.1 Verify Workflow Appears in GitHub Actions

1. Navigate to: `https://github.com/aRustyDev/homebrew-tap/actions`
2. Confirm "Bump Formulas" workflow appears in the left sidebar
3. Verify no syntax errors are displayed

**Expected Result:** Workflow visible, no error banners.

### 3.2 Test 1Password Secret Loading

Trigger a manual workflow run to verify secrets load correctly:

1. Go to Actions → "Bump Formulas" → "Run workflow"
2. Leave inputs empty (default values)
3. Click "Run workflow"
4. Monitor the "Load secrets from 1Password" step

**Expected Result:**
- Step completes successfully (green checkmark)
- No "secret not found" errors
- `HOMEBREW_PAT` value is masked in logs (`***`)

**Failure Indicators:**
- `Error: Unable to load secret from 1Password`
- `Error: Invalid service account token`
- `Error: Item not found: op://gh-homebrew-tap/gh-homebrew-tap/token`

### 3.3 Test Livecheck Execution

Monitor the "Bump Homebrew formulas" step:

**Expected Result (No Updates Available):**
```
==> brew livecheck --tap aRustyDev/tap
==> No outdated formulae found
```

**Expected Result (Updates Available):**
```
==> brew livecheck --tap aRustyDev/tap
==> formula-name: 1.0.0 -> 1.1.0
==> Running brew bump-formula-pr for formula-name...
==> Created PR: https://github.com/aRustyDev/homebrew-tap/pull/XXX
```

### 3.4 Test Specific Formula Input

1. Go to Actions → "Bump Formulas" → "Run workflow"
2. Enter a known formula name in the "formula" input (e.g., `zoxide`)
3. Click "Run workflow"
4. Verify only that formula is checked

**Expected Result:** Livecheck runs only for the specified formula.

### 3.5 Test Force Flag

1. If a PR already exists for a formula, note its name
2. Go to Actions → "Bump Formulas" → "Run workflow"
3. Enter the formula name
4. Set "force" to `true`
5. Click "Run workflow"

**Expected Result:** Workflow attempts update despite existing PR (may warn or create duplicate).

### 3.6 Verify PR Creation (If Updates Found)

If livecheck finds an outdated formula:

1. Check the workflow logs for PR URL
2. Navigate to the created PR
3. Verify PR contains:
   - Version bump in formula file
   - Updated SHA256 hash
   - Appropriate title and description

**Expected PR Structure:**
```
Title: <formula>: update X.X.X -> Y.Y.Y
Body: Created by `brew bump-formula-pr`
Files: Formula/<letter>/<formula>.rb
```

## Test Matrix

| Test | Input | Expected Outcome | Status |
|------|-------|------------------|--------|
| Basic run | defaults | Completes, checks all formulas | ⬜ |
| 1Password loading | defaults | Secret loaded and masked | ⬜ |
| Livecheck execution | defaults | Runs `brew livecheck` | ⬜ |
| Specific formula | `formula: zoxide` | Only checks zoxide | ⬜ |
| Force flag | `force: true` | Ignores existing PRs | ⬜ |
| PR creation | (if update found) | Valid PR created | ⬜ |

## Debugging Commands

If issues arise, these commands help diagnose:

```bash
# Check 1Password CLI connectivity (requires op CLI)
op item get "gh-homebrew-tap" --vault "gh-homebrew-tap" --fields token

# Test Homebrew livecheck locally
brew livecheck --tap aRustyDev/tap

# Check specific formula
brew livecheck aRustyDev/tap/<formula-name>

# Verify formula has livecheck block
cat Formula/<letter>/<formula>.rb | grep -A5 "livecheck do"
```

## Common Issues & Solutions

### Issue: 1Password Secret Not Found

**Symptom:**
```
Error: Unable to find item at path op://gh-homebrew-tap/gh-homebrew-tap/token
```

**Solutions:**
1. Verify vault name: `gh-homebrew-tap`
2. Verify item name: `gh-homebrew-tap`
3. Verify field name: `token`
4. Check service account has access to the vault

### Issue: PAT Lacks Required Scopes

**Symptom:**
```
Error: Resource not accessible by integration
Error: Must have admin rights to Repository
```

**Solutions:**
1. Regenerate PAT with scopes: `public_repo`, `workflow`
2. Update token in 1Password
3. Re-run workflow

### Issue: No Formulas Found

**Symptom:**
```
Warning: No formulae found in tap aRustyDev/tap
```

**Solutions:**
1. Verify tap name is correct (`aRustyDev/tap` not `aRustyDev/homebrew-tap`)
2. Check formulas exist in `Formula/` directory
3. Ensure formulas have valid Ruby syntax

### Issue: Livecheck Returns Empty

**Symptom:**
```
==> No outdated formulae found
```

**Note:** This is expected if all formulas are up-to-date. To force-test:
1. Manually downgrade a formula version in the `.rb` file
2. Run workflow to verify it detects the "update"

## Completion Criteria

- [ ] Workflow runs without errors
- [ ] 1Password secrets load successfully (masked in logs)
- [ ] Livecheck executes and reports formula status
- [ ] Specific formula input works correctly
- [ ] Force flag behaves as expected
- [ ] If updates exist, PRs are created correctly

## Next Phase

Proceed to **Phase 4: Documentation & Cleanup** after all tests pass.
