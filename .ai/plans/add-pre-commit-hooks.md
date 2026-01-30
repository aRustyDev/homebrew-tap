---
id: 8A3F2E1D-C4B5-6789-DEF0-123456789ABC
title: "Add Pre-commit Hooks for Formula Development"
status: "⏳ Pending"
date: 2025-12-18
author: Claude
related:
  - 94D957ED-BC40-4696-B9FA-9EB936B830CE
children: []
---

# Add Pre-commit Hooks for Formula Development

## Overview

Add pre-commit hooks to the Homebrew tap to catch formula issues before they reach CI, reducing failed PR iterations and improving developer experience.

## Problem Statement

Currently, formula validation only happens in CI via `brew test-bot --only-tap-syntax`. This means:
- Developers don't discover issues until after pushing
- CI failures require additional commits to fix
- The feedback loop is slow (push → wait for CI → fix → push again)

## Solution

Implement [pre-commit](https://pre-commit.com/) framework with hooks that run locally before each commit, catching issues early.

## Research Findings

### Available Hook Repositories

| Repository | Hooks | Notes |
|------------|-------|-------|
| [rubocop/rubocop](https://github.com/rubocop/rubocop) | `rubocop` | Official RuboCop hook, same linter `brew style` uses |
| [mattlqx/pre-commit-ruby](https://github.com/mattlqx/pre-commit-ruby) | `rubocop`, `rspec` | Uses Bundler for version management |
| [pre-commit/pre-commit-hooks](https://github.com/pre-commit/pre-commit-hooks) | General utilities | `trailing-whitespace`, `end-of-file-fixer`, `check-yaml`, etc. |

### No Existing Homebrew-Specific Hooks

There is no existing pre-commit hook repository specifically for Homebrew formula development. A custom local hook for `brew style` would be needed.

### Key Insight

RuboCop uses the community Ruby style guide by default, but Homebrew has custom rules in `.rubocop.yml`. The `brew style` command automatically applies Homebrew's configuration, making it preferable to raw RuboCop for formula files.

## Proposed Configuration

### `.pre-commit-config.yaml`

```yaml
# Pre-commit hooks for Homebrew tap development
# See https://pre-commit.com for more information
repos:
  # General file hygiene
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
        exclude: ^\.ai/
      - id: end-of-file-fixer
        exclude: ^\.ai/
      - id: check-yaml
      - id: check-added-large-files
      - id: detect-private-key

  # Ruby/Formula linting via brew style (uses Homebrew's rubocop config)
  - repo: local
    hooks:
      - id: brew-style
        name: brew style
        description: Lint formula files with Homebrew's style rules
        entry: brew style --fix
        language: system
        files: ^Formula/.*\.rb$
        pass_filenames: true

      - id: brew-audit
        name: brew audit (new formulas)
        description: Audit formula for common issues
        entry: bash -c 'for f in "$@"; do name=$(basename "$f" .rb); brew audit --new --formula "$name" 2>/dev/null || brew audit --formula "$name"; done' --
        language: system
        files: ^Formula/.*\.rb$
        pass_filenames: true
        stages: [pre-push]  # Only on push, too slow for every commit
```

### Alternative: RuboCop Directly (Faster, Less Complete)

```yaml
repos:
  - repo: https://github.com/rubocop/rubocop
    rev: v1.69.2
    hooks:
      - id: rubocop
        args: ['--autocorrect', '--force-exclusion']
        files: ^Formula/.*\.rb$
```

This is faster but won't catch all `brew style` issues since it doesn't use Homebrew's full configuration context.

## Implementation Plan

### Phase 1: Setup Pre-commit Framework

1. [ ] Install pre-commit: `brew install pre-commit`
2. [ ] Create `.pre-commit-config.yaml` in repo root
3. [ ] Run `pre-commit install` to set up git hooks
4. [ ] Test with `pre-commit run --all-files`

### Phase 2: Configure Hooks

1. [ ] Add general file hygiene hooks (trailing whitespace, EOF, YAML check)
2. [ ] Add `brew style` local hook for formula linting
3. [ ] Add `brew audit` hook (pre-push stage only - it's slow)
4. [ ] Exclude `.ai/` and `.claude/` directories from text hooks

### Phase 3: Documentation

1. [ ] Update README.md with pre-commit setup instructions
2. [ ] Add to slash command documentation
3. [ ] Update CONTRIBUTING.md (if exists)

### Phase 4: CI Integration (Optional)

1. [ ] Add pre-commit to CI workflow as additional check
2. [ ] Use `pre-commit run --all-files` in CI for consistency

## Trade-offs

### `brew style` vs Direct RuboCop

| Aspect | `brew style` | Direct RuboCop |
|--------|--------------|----------------|
| Speed | Slower (spawns brew) | Faster |
| Accuracy | 100% matches CI | May miss Homebrew-specific rules |
| Dependencies | Requires Homebrew | Just Ruby/RuboCop |
| Auto-fix | `--fix` flag | `--autocorrect` flag |

**Recommendation:** Use `brew style` for accuracy. The slight slowdown is worth catching all CI issues locally.

### Pre-push vs Pre-commit for `brew audit`

`brew audit` is slower because it may fetch remote data. Options:
1. **Pre-commit (every commit):** Slower workflow, catches everything
2. **Pre-push (before push):** Faster commits, catches issues before CI
3. **Manual only:** Developer runs when ready

**Recommendation:** Use `pre-push` stage for `brew audit` to balance speed and safety.

## Success Criteria

- [ ] `pre-commit run --all-files` passes on clean repo
- [ ] New formula commits are validated before push
- [ ] CI failures due to style issues are eliminated
- [ ] Developer workflow is not significantly slowed

## References

- [pre-commit.com](https://pre-commit.com/)
- [RuboCop Pre-commit Hooks](https://github.com/rubocop/rubocop/blob/master/.pre-commit-hooks.yaml)
- [pre-commit/pre-commit-hooks](https://github.com/pre-commit/pre-commit-hooks)
- [mattlqx/pre-commit-ruby](https://github.com/mattlqx/pre-commit-ruby)
- [Homebrew Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)

## Open Questions

1. Should we require pre-commit for all contributors or make it optional?
2. Should CI also run pre-commit for consistency?
3. Do we need a Gemfile for RuboCop version pinning, or rely on system brew?
