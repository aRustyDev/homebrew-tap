# Implementation Plan: Add mustache Formula

## Overview

Add a Homebrew formula for [cbroglie/mustache](https://github.com/cbroglie/mustache) - a Mustache template engine CLI and Go library.

## Project Information

| Field | Value |
|-------|-------|
| **Repository** | github.com/cbroglie/mustache |
| **Latest Version** | v1.4.0 |
| **License** | MIT |
| **Language** | Go |
| **Build System** | goreleaser |

### What is mustache?

A CLI tool and Go library implementing the Mustache template language. The CLI accepts data (YAML/JSON) and a template file, rendering output with variable substitution, sections, and partials support.

**CLI Usage:**
```bash
mustache data.yml template.mustache
cat data.yml | mustache template.mustache
mustache --layout wrapper.mustache data template.mustache
```

## Implementation Steps

### 1. Create Formula File

**Location:** `Formula/m/mustache.rb`

**Approach:** Build from source using Go (preferred Homebrew practice)
- Use source tarball URL, not pre-built binaries
- Use `std_go_args` for standard Go build flags
- Build the CLI binary from `./cmd/mustache`

### 2. Formula Structure

```ruby
# typed: strict
# frozen_string_literal: true

class Mustache < Formula
  desc "CLI for the Mustache template language"
  homepage "https://github.com/cbroglie/mustache"
  url "https://github.com/cbroglie/mustache/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "3330c4516ffd3797ac9744280d2b0e1619faca082832e15d08eca9234af08636"
  license "MIT"
  head "https://github.com/cbroglie/mustache.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/mustache"
  end

  test do
    # Test basic template rendering
    (testpath/"template.mustache").write("Hello {{name}}!")
    (testpath/"data.yml").write("name: World")
    assert_equal "Hello World!", shell_output("#{bin}/mustache #{testpath}/data.yml #{testpath}/template.mustache").strip
  end
end
```

### 3. Key Formula Elements

| Element | Description |
|---------|-------------|
| `desc` | Short description for `brew info` |
| `homepage` | Project homepage URL |
| `url` | Source tarball URL (using archive, not pre-built) |
| `sha256` | Checksum for integrity verification |
| `license` | SPDX license identifier |
| `head` | Git URL for `--HEAD` installs |
| `depends_on "go"` | Build-time dependency |
| `std_go_args` | Standard Homebrew Go build flags |
| `test` | Verification the install works |

### 4. Build Details

- **Build path:** `./cmd/mustache` (the CLI binary lives here)
- **Ldflags:** `-s -w` (strip debug info, reduce binary size)
- **Output:** Single `mustache` binary in `bin/`

### 5. Test Strategy

The test block verifies:
1. Binary executes successfully
2. Template rendering works correctly
3. YAML data parsing works

### 6. Validation Steps

After creating the formula, run:

```bash
# Audit the formula for issues
brew audit --new --formula Formula/m/mustache.rb

# Install and test locally
brew install --build-from-source ./Formula/m/mustache.rb

# Run formula tests
brew test mustache

# Verify help output
mustache --help
```

### 7. Update formulas.json

Add "mustache" to `.data/formulas.json`:
```json
{
  "formulas": ["mustache", "zed-prompts"]
}
```

## Checklist

- [ ] Create `Formula/m/` directory
- [ ] Create `Formula/m/mustache.rb` with formula content
- [ ] Run `brew audit --new --formula` to validate
- [ ] Test installation with `brew install --build-from-source`
- [ ] Run `brew test mustache` to verify
- [ ] Update `.data/formulas.json`
- [ ] Commit changes to feature branch
- [ ] Create PR to main branch

## References

- [Homebrew Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
- [mustache README](https://github.com/cbroglie/mustache#readme)
- [Existing tap formulas](../Formula/) for pattern reference
