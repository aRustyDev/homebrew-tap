---
id: 94D957ED-BC40-4696-B9FA-9EB936B830CE
title: "Homebrew Tap CI Simplification Plan"
status: "🚧 In Progress"
date: 2025-01-13
author: Claude
related:
  - null
children:
  - 11875DF1-2553-406B-9AA1-F08EBBE2642E
  - A6AC0C95-DE40-4165-AA13-43A8764F44EC
  - 87608F52-FF6B-47B1-91E7-DE112771DE64
  - AFC45E1B-5836-431F-B7B6-58E49832A861
---

# Homebrew Tap CI Simplification Plan

## Overview

Replace broken custom CI workflows in `aRustyDev/homebrew-tap` with the battle-tested `dawidd6/action-homebrew-bump-formula` action, using 1Password for secret management.

## Problem Statement

The current CI implementation has:
- Multiple broken workflow files with `TODO@CLAUDE:` placeholders
- Invalid GitHub Actions syntax (string outputs used as matrix arrays)
- References to undefined steps and inputs
- Custom actions that don't function correctly
- Unused `.data/formulas.json` infrastructure

## Solution

Adopt `dawidd6/action-homebrew-bump-formula@v7` which:
- Uses official Homebrew tooling (`brew bump-formula-pr`, `brew livecheck`)
- Handles SHA256 calculation automatically
- Creates PRs via Homebrew's established workflow
- Supports scheduled livecheck mode for all tap formulas

## Prerequisites

| Item | Status | Details |
|------|--------|---------|
| 1Password Service Account | ✅ Configured | Token in `OP_SVC_ACCT_TOKEN` repo secret |
| HOMEBREW_PAT in 1Password | ✅ Available | `op://gh-homebrew-tap/gh-homebrew-tap/token` |
| PAT Scopes | ⚠️ Verify | Needs `public_repo` + `workflow` scopes |

## Phases

### Phase 1: Cleanup Legacy Files
**Document:** `.ai/plans/phases/homebrew-tap-ci-simplification-phase-1.md`

Delete broken/unused files:
- [ ] `.github/workflows/formula-bump.yml`
- [ ] `.github/workflows/update-formula.yml`
- [ ] `.github/actions/check-formula/`
- [ ] `.github/actions/update-formula/`
- [ ] `.github/actions/run-jq/`
- [ ] `.github/jq/` (entire directory)
- [ ] `.data/formulas.json`
- [ ] `.data/formula.schema.json`
- [ ] `.data/formulas.schema.json`

### Phase 2: Create New Workflow
**Document:** `.ai/plans/phases/homebrew-tap-ci-simplification-phase-2.md`

Create `.github/workflows/bump-formulas.yml`:

```yaml
# id:D4E5F6A7-B8C9-0123-DEF0-456789012345
name: Bump Formulas

on:
  schedule:
    - cron: "0 2 * * *"
  workflow_dispatch:
    inputs:
      formula:
        description: "Specific formula to check (leave empty for all)"
        required: false
        type: string
      force:
        description: "Force check even if PR already exists"
        required: false
        default: false
        type: boolean

concurrency:
  group: bump-formulas
  cancel-in-progress: false

permissions:
  contents: read

jobs:
  bump-formulas:
    runs-on: ubuntu-latest
    steps:
      - name: Load secrets from 1Password
        uses: 1password/load-secrets-action@v2
        env:
          OP_SERVICE_ACCOUNT_TOKEN: ${{ secrets.OP_SVC_ACCT_TOKEN }}
          HOMEBREW_PAT: op://gh-homebrew-tap/gh-homebrew-tap/token

      - name: Bump Homebrew formulas
        uses: dawidd6/action-homebrew-bump-formula@v7
        with:
          token: ${{ env.HOMEBREW_PAT }}
          tap: aRustyDev/tap
          formula: ${{ inputs.formula }}
          livecheck: true
          force: ${{ inputs.force || false }}
          no_fork: true
```

### Phase 3: Verify & Test
**Document:** `.ai/plans/phases/homebrew-tap-ci-simplification-phase-3.md`

1. [ ] Trigger workflow manually via `workflow_dispatch`
2. [ ] Verify 1Password secret loading works
3. [ ] Confirm livecheck runs against all formulas
4. [ ] Test with specific formula input
5. [ ] Verify PR creation (if updates found)

### Phase 4: Documentation & Cleanup
**Document:** `.ai/plans/phases/homebrew-tap-ci-simplification-phase-4.md`

1. [ ] Update README.md with CI workflow description
2. [ ] Remove `.data/` directory if empty
3. [ ] Update CHANGELOG.md
4. [ ] Create final commit

## File Changes Summary

### Files to Delete

| Path | Reason |
|------|--------|
| `.github/workflows/formula-bump.yml` | Broken, replaced |
| `.github/workflows/update-formula.yml` | Broken, replaced |
| `.github/actions/check-formula/` | Broken, unused |
| `.github/actions/update-formula/` | Broken, unused |
| `.github/actions/run-jq/` | No longer needed |
| `.github/jq/*.jq` | No longer needed |
| `.data/formulas.json` | Unused (empty `[]`) |
| `.data/*.schema.json` | No longer needed |

### Files to Create

| Path | Purpose |
|------|---------|
| `.github/workflows/bump-formulas.yml` | New simplified workflow |

### Files to Keep (Unchanged)

| Path | Purpose |
|------|---------|
| `.github/workflows/tests.yml` | Formula testing |
| `.github/workflows/publish.yml` | Publishing workflow |
| `.github/templates/` | May be useful for future customization |

## Rollback Plan

If issues arise:
1. Revert the PR that implements this plan
2. Re-enable old workflows (they won't work but won't break anything)
3. Open issue documenting what went wrong

## Success Criteria

- [ ] `bump-formulas.yml` workflow runs successfully
- [ ] 1Password secrets load correctly (masked in logs)
- [ ] Livecheck identifies outdated formulas (if any exist)
- [ ] PRs are created for formula updates (when updates available)
- [ ] No CI failures on `main` branch
- [ ] All broken legacy files removed

## References

- [dawidd6/action-homebrew-bump-formula](https://github.com/dawidd6/action-homebrew-bump-formula)
- [1Password Load Secrets Action](https://github.com/1Password/load-secrets-action)
- [Homebrew Livecheck](https://docs.brew.sh/Brew-Livecheck)
- [Homebrew bump-formula-pr](https://docs.brew.sh/How-To-Open-a-Homebrew-Pull-Request#submit-a-new-version-of-an-existing-formula)
