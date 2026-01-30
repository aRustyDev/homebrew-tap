---
id: 11875DF1-2553-406B-9AA1-F08EBBE2642E
title: "Phase 1: Cleanup Legacy Files"
status: "✅ Completed"
date: 2025-01-13
author: Claude
related:
  - 94D957ED-BC40-4696-B9FA-9EB936B830CE
---

# Phase 1: Cleanup Legacy Files

## Objective

Remove all broken and unused CI infrastructure files to prepare for the new simplified workflow implementation.

## Tasks

### 1.1 Delete Broken Workflow Files

These workflows contain invalid syntax, undefined references, and `TODO@CLAUDE:` placeholders:

- [x] Delete `.github/workflows/formula-bump.yml`
- [x] Delete `.github/workflows/update-formula.yml`

### 1.2 Delete Broken Custom Actions

These composite actions have severe issues including:
- Duplicate steps with wrong action types
- Invalid input references
- Incomplete shell scripts

- [x] Delete `.github/actions/check-formula/` (entire directory)
- [x] Delete `.github/actions/update-formula/` (entire directory)
- [x] Delete `.github/actions/run-jq/` (entire directory)

### 1.3 Delete Unused jq Scripts

No longer needed with the new approach:

- [x] Delete `.github/jq/get-latest.jq`
- [x] Delete `.github/jq/parse-formula.jq`
- [x] Delete `.github/jq/process-release.jq`
- [x] Delete `.github/jq/process-tags.jq`
- [x] Delete `.github/jq/update-formulas.jq`
- [x] Delete `.github/jq/` directory

### 1.4 Delete Unused Data Files

The JSON-based formula tracking system is unused:

- [x] Delete `.data/formulas.json` (was empty `[]`)
- [x] Delete `.data/formula.schema.json`
- [x] Delete `.data/formulas.schema.json`
- [x] Delete `.data/` directory

## Files Preserved

The following files are intentionally kept:

| File | Reason |
|------|--------|
| `.github/workflows/tests.yml` | Working formula testing workflow |
| `.github/workflows/publish.yml` | Working publish workflow |
| `.github/templates/` | May be useful for future PR/issue templates |

## Completion Criteria

- [x] All listed files/directories deleted
- [x] No broken workflow files remain in `.github/workflows/`
- [x] `.github/actions/` is removed
- [x] `.github/jq/` is removed
- [x] `.data/` is removed
- [x] `git status` shows expected deletions

## Next Phase

✅ Proceed to **Phase 2: Create New Workflow**
