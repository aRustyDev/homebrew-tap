---
id: A6AC0C95-DE40-4165-AA13-43A8764F44EC
title: "Phase 2: Create New Workflow"
status: "✅ Completed"
date: 2025-01-13
author: Claude
related:
  - 94D957ED-BC40-4696-B9FA-9EB936B830CE
  - 11875DF1-2553-406B-9AA1-F08EBBE2642E
---

# Phase 2: Create New Workflow

## Objective

Create a new simplified workflow file that uses `dawidd6/action-homebrew-bump-formula@v7` with 1Password secret management to automatically detect and update outdated Homebrew formulas.

## Prerequisites

Before starting this phase:

- [x] Phase 1 completed (legacy files cleaned up)
- [ ] Verify `OP_SVC_ACCT_TOKEN` exists as a repository secret
- [ ] Verify 1Password item `op://gh-homebrew-tap/gh-homebrew-tap/token` contains valid PAT
- [ ] PAT has required scopes: `public_repo` and `workflow`

## Tasks

### 2.1 Create New Workflow File ✅

Created `.github/workflows/bump-formulas.yml` with:
- 1Password secret loading via `1password/load-secrets-action@v2`
- `dawidd6/action-homebrew-bump-formula@v7` for formula bumping
- Concurrency controls to prevent duplicate runs
- Explicit permissions for security

### 2.2 Workflow Configuration Details

| Input | Purpose | Default |
|-------|---------|---------|
| `formula` | Target specific formula instead of all | Empty (checks all) |
| `force` | Skip check for existing open PRs | `false` |

| Secret Source | Reference | Purpose |
|---------------|-----------|---------|
| GitHub Repo Secret | `OP_SVC_ACCT_TOKEN` | 1Password Service Account auth |
| 1Password | `op://gh-homebrew-tap/gh-homebrew-tap/token` | GitHub PAT for Homebrew ops |

### 2.3 Key Implementation Notes

**1Password Secret Access:** The `1password/load-secrets-action@v2` exports secrets as **environment variables**, not step outputs. Access via `${{ env.HOMEBREW_PAT }}`.

**Concurrency Control:** The `concurrency` block prevents duplicate runs if scheduled and manual triggers overlap.

**Permissions:** Explicit `contents: read` permission. The PAT handles write operations to the tap.

### 2.4 Verify Workflow Syntax ✅

YAML syntax validated successfully.

## File Location

```
.github/
└── workflows/
    ├── bump-formulas.yml  # NEW - created this phase
    ├── publish.yml        # EXISTING - unchanged
    └── tests.yml          # EXISTING - unchanged
```

## Completion Criteria

- [x] `.github/workflows/bump-formulas.yml` created with correct content
- [x] YAML syntax validates
- [ ] File committed to repository
- [ ] No syntax errors shown in GitHub Actions tab (pending push)

## Next Phase

Proceed to **Phase 3: Verify & Test** after changes are committed and pushed.
