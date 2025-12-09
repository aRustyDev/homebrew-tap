# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- `.github/workflows/bump-formulas.yml` - Simplified automated formula update workflow using `dawidd6/action-homebrew-bump-formula@v7`
- 1Password integration for secure secret management

### Changed
- Replaced broken custom formula bump workflows with battle-tested community action

### Removed
- `.github/workflows/formula-bump.yml` (broken, contained TODO placeholders)
- `.github/workflows/update-formula.yml` (broken, invalid syntax)
- `.github/actions/check-formula/` (broken composite action)
- `.github/actions/update-formula/` (broken composite action)
- `.github/actions/run-jq/` (unused)
- `.github/jq/` directory (unused jq scripts)
- `.data/` directory (unused JSON formula tracking infrastructure)
