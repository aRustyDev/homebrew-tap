---
id: AI-CONFIG-SYNC-001
title: "AI Configuration Sync Strategy Options"
status: "brainstorming"
date: 2025-12-18
context:
  machines: 7+
  workflow: "project → global/dotfiles (promotion pattern)"
  tools: "Claude Code, Claude Desktop, Zed, future custom agents, VSCode"
  current_repos:
    - "arustydev/dotfiles → /Users/arustydev/repos/configs/dotfiles"
    - "arustydev/ai → /Users/arustydev/repos/configs/ai"
---

# AI Configuration Sync Strategy Options

## Problem Statement

You have AI-related configuration files (CLAUDE.md, skills, plugins, rules, roles, commands, hooks) spread across two repos with no clear flow:

1. **arustydev/dotfiles** - Has `.ai/` and `.claude/` directories
2. **arustydev/ai** - Comprehensive AI config collection (seems more complete)

Goals:
- Single source of truth for AI configs
- Easy promotion: project → global → source repo
- CI-based sync across 7+ machines
- Support multiple tools (Claude Code, Claude Desktop, Zed, future agents)

## Current Flow (Problems)

```
Project .claude/     →  (manual copy)  →  ~/.claude/
       ↓                                      ↓
dotfiles/.claude/   →  just install   →  ~/.claude/
       ↓
dotfiles/.ai/       →  ???            →  ???

ai/                 →  TODO stubs     →  various tools
```

**Issues:**
- Two repos with overlapping content
- No clear promotion path from project → source
- Manual syncing prone to drift
- `ai` repo has richer content but `dotfiles` has the deployment mechanism

---

## Option 1: Submodule (ai as submodule of dotfiles)

### Structure
```
dotfiles/
├── .ai/              → git submodule (arustydev/ai)
├── .claude/          → symlinks or copies from .ai/
├── justfile          → handles install + submodule update
└── ...other dotfiles
```

### Workflow
1. Make changes in project `.claude/`
2. Promote to `dotfiles/.ai/` (which is the ai submodule)
3. Commit in submodule, push, then commit in parent
4. CI triggers sync to all machines

### Pros
- Clear separation of concerns
- `ai` repo can be used standalone (shared with others, used in other projects)
- Version pinning - dotfiles can pin a specific version of ai configs
- Atomic updates to ai configs

### Cons
- Submodule complexity (two-step commits, detached HEAD issues)
- Harder to make quick iterative changes
- Submodule sync issues can be confusing
- Need to remember `git submodule update` on other machines

### Best For
- If you want to share `ai` repo publicly or with teams
- If you need version pinning/stability guarantees

---

## Option 2: Monorepo (merge ai into dotfiles)

### Structure
```
dotfiles/
├── ai/                   → (formerly arustydev/ai, now a directory)
│   ├── claude/           → Claude Code configs
│   │   ├── commands/
│   │   ├── skills/
│   │   ├── hooks/
│   │   └── rules/
│   ├── zed/              → Zed configs
│   ├── desktop/          → Claude Desktop configs
│   └── shared/           → Common rules, prompts, context
├── .claude/              → project-level Claude configs for dotfiles itself
└── justfile              → unified install
```

### Workflow
1. Make changes in project `.claude/`
2. Run `promote-config` script → copies to `dotfiles/ai/claude/`
3. Commit and push
4. CI syncs to all machines

### Pros
- Single repo, single git workflow
- No submodule complexity
- Everything discoverable in one place
- Simpler CI/CD

### Cons
- Larger repo
- Can't share ai configs independently
- Mixes AI configs with other dotfiles (noise)
- History of ai repo would need migration or be lost

### Best For
- If AI configs are personal and don't need to be shared
- If you value simplicity over separation

---

## Option 3: ai as Upstream Library (pull-based)

### Structure
```
ai/                      → Source of truth (curated library)
├── claude/
├── zed/
├── shared/
└── export.sh            → Generates consumable bundles

dotfiles/
├── .ai/                 → Pulled from ai repo
├── .claude/             → Symlinks to .ai/claude/
└── justfile
  └── sync-ai:           → git clone/pull ai repo, copy relevant parts
```

### Workflow
1. Develop/test configs locally in project or ~/.claude
2. When ready to promote, open PR to `ai` repo
3. Merge to ai repo
4. Run `just sync-ai` in dotfiles to pull latest
5. Commit updated configs in dotfiles
6. CI syncs to machines

### Pros
- Clean separation
- `ai` repo is the canonical source
- Can have review process for ai repo changes
- dotfiles stays focused on deployment

### Cons
- Two repos to maintain
- More complex sync workflow
- Potential version drift between ai and dotfiles
- Extra step to "sync" changes

### Best For
- If ai configs will be shared or are a standalone "product"
- If you want curation/review before configs go global

---

## Option 4: dotfiles as Source of Truth (deprecate ai)

### Structure
```
dotfiles/
├── ai/                   → All AI configs (migrated from ai repo)
│   ├── claude/
│   ├── zed/
│   ├── shared/
│   └── README.md
├── .claude/              → Symlinks to ai/claude/ or project-specific
└── justfile

ai/                       → Archived, read-only, points to dotfiles
```

### Workflow
1. Make changes in project `.claude/`
2. Run `promote-config` → commits to dotfiles
3. Push
4. CI syncs

### Pros
- Single source of truth
- Simple mental model
- No sync complexity
- ai repo can redirect to dotfiles

### Cons
- ai repo loses its identity
- If sharing AI configs, need to point people to dotfiles
- dotfiles repo gets bigger

### Best For
- If you're the only consumer of these configs
- If you value simplicity above all

---

## Option 5: Chezmoi or Dotfile Manager

### Structure
```
dotfiles/                 → chezmoi source directory
├── .chezmoiroot
├── private_dot_claude/   → ~/.claude
├── dot_ai/               → project .ai templates
└── .chezmoitemplates/    → shared templates

ai/                       → Library of configs (optional)
```

### Workflow
1. `chezmoi add ~/.claude/commands/new-command.md` → adds to source
2. Edit in source repo
3. `chezmoi apply` on each machine (or via CI)
4. Templates allow machine-specific variations

### Pros
- Purpose-built for multi-machine dotfile sync
- Handles secrets, templates, machine differences
- `chezmoi diff` shows what would change
- Automatic merge conflict detection

### Cons
- Learning curve
- Another tool dependency
- Template syntax for variations
- May be overkill if machines are identical

### Best For
- If machines have different configs (work vs personal)
- If you need secret management
- If you want robust diff/merge handling

---

## Option 6: GitHub Actions CI Sync (Keep Current + Add Automation)

### Structure
```
dotfiles/                 → Source of truth
├── .ai/
├── .claude/
└── .github/workflows/
    └── sync-to-machines.yml  → SSH/rsync to machines

ai/                       → Deprecated or reference only
```

### Workflow
1. Make changes in project
2. Run `promote-to-dotfiles` script
3. Push to dotfiles
4. GitHub Actions syncs to all machines via SSH

### Pros
- Minimal changes to current setup
- Familiar git workflow
- Can gradually deprecate ai repo

### Cons
- Need SSH access from GitHub to machines
- Security considerations for SSH keys
- Machines need to be reachable from internet (or use tailscale/vpn)
- Not great for laptops that aren't always online

### Best For
- If machines are always online and reachable
- If you don't want to change much

---

## Option 7: Hybrid - Monorepo + "Promote" Automation

### Structure
```
dotfiles/
├── ai/                   → Source of truth for all AI configs
│   ├── claude/           → Claude Code global configs
│   │   ├── commands/
│   │   ├── skills/
│   │   ├── hooks/
│   │   └── rules/
│   ├── desktop/          → Claude Desktop configs
│   ├── zed/              → Zed AI configs
│   └── shared/           → Common context, rules, prompts
├── .claude/              → Dotfiles' own project configs
├── bin/
│   └── promote-ai-config → Script to promote from project → ai/
└── justfile
    └── install-ai        → Deploy ai/ to appropriate locations

~/.claude/                → Symlink or populated by just install-ai
~/.ai/                    → Optional global .ai (symlink to dotfiles/ai/)
```

### The "Promote" Script
```bash
#!/bin/bash
# promote-ai-config
# Usage: promote-ai-config <type> <source-path>
# Example: promote-ai-config skill ~/.claude/skills/homebrew-formula/

TYPE=$1  # skill, command, rule, hook
SOURCE=$2
DOTFILES=~/repos/configs/dotfiles
DEST=$DOTFILES/ai/claude/${TYPE}s/

cp -r "$SOURCE" "$DEST"
cd $DOTFILES
git add -A
git commit -m "feat(ai): promote $TYPE from project"
git push
```

### Workflow
1. Create/test config in project `.claude/`
2. Run `promote-ai-config skill .claude/skills/new-skill/`
3. Script copies to dotfiles, commits, pushes
4. On other machines: `git pull && just install-ai`

### Machine Sync Options
- **Pull-based**: Cron job or login hook runs `git pull && just install-ai`
- **Push-based**: GitHub webhook triggers sync (if machines are reachable)
- **Hybrid**: Use tailscale + webhook for always-on machines, pull for laptops

### Pros
- Single source of truth (dotfiles)
- Clear promotion path with tooling
- Works offline (pull-based)
- Flexible sync options
- Supports all tools (Claude, Zed, etc.)
- Familiar git workflow

### Cons
- Still manual sync on machines (unless automated)
- Larger dotfiles repo
- ai repo needs migration/deprecation

### Best For
- Your specific workflow (project → global → source)
- Mix of always-on and sometimes-offline machines
- Multiple AI tools

---

## Comparison Matrix

| Aspect | Submodule | Monorepo | Upstream | Deprecate ai | Chezmoi | CI Sync | Hybrid |
|--------|-----------|----------|----------|--------------|---------|---------|--------|
| **Complexity** | High | Low | Medium | Low | Medium | Medium | Medium |
| **Single Source** | ✓ (ai) | ✓ (dotfiles) | ✓ (ai) | ✓ (dotfiles) | ✓ | ✓ | ✓ |
| **Easy Promote** | ✗ | ✓ | ✗ | ✓ | ✓ | ✓ | ✓ |
| **Shareable** | ✓ | ✗ | ✓ | ✗ | ✗ | ✗ | ✗ |
| **Multi-tool** | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| **Offline OK** | ✓ | ✓ | ✓ | ✓ | ✓ | ✗ | ✓ |
| **7+ Machines** | Medium | Good | Medium | Good | Best | Good | Good |
| **Learning Curve** | Medium | Low | Low | Low | High | Low | Low |

---

## Revised Recommendation

### Updated Context
- Shares configs with others → `ai` repo must remain shareable
- **Workflow: project → source → global** (not project → global → source)
- Machine profiles needed → dynamic config construction
- Secrets handled by 1Password (`op://vault/item/key`)
- **Future vision**: Atomic, schema'd components that compile to tool-specific formats

### Recommended: Option 8 - Composable Config Architecture

This is a hybrid of Option 3 (ai as upstream) + a build/compile layer.

```
┌─────────────────────────────────────────────────────────────────────┐
│                           WORKFLOW                                   │
│                                                                      │
│   Project .claude/  ──promote──▶  ai/ (source)  ──build──▶  global  │
│                                      │                               │
│                                      ▼                               │
│                               dotfiles/                              │
│                           (deployment layer)                         │
└─────────────────────────────────────────────────────────────────────┘
```

### Architecture

```
ai/                              ← SHAREABLE SOURCE OF TRUTH
├── components/                  ← Atomic, reusable pieces
│   ├── rules/                   ← Schema'd JSON rule objects
│   │   ├── git-workflow.rule.json
│   │   ├── security-review.rule.json
│   │   └── ...
│   ├── skills/                  ← Skill definitions
│   ├── commands/                ← Command templates
│   ├── hooks/                   ← Hook definitions
│   └── context/                 ← Shared context fragments
│
├── profiles/                    ← Machine/use-case profiles
│   ├── personal.profile.json   ← "include these rules, exclude those"
│   ├── work.profile.json
│   ├── server.profile.json
│   └── minimal.profile.json
│
├── tools/                       ← Tool-specific output schemas
│   ├── claude-code/
│   │   └── schema.json         ← How to compile for Claude Code
│   ├── zed/
│   │   └── schema.json
│   ├── claude-desktop/
│   │   └── schema.json
│   └── vscode/
│       └── schema.json
│
├── mcp/                         ← MCP server definitions
│   ├── global/                  ← Remote/shared MCP configs
│   │   ├── memory.mcp.json
│   │   └── github.mcp.json
│   └── local/                   ← Project-scoped MCP templates
│       └── filesystem.mcp.json
│
├── build/                       ← Build tooling
│   ├── compile.py              ← Compiles components → tool configs
│   ├── validate.py             ← Schema validation
│   └── diff.py                 ← Compare profiles/versions
│
└── dist/                        ← Generated output (gitignored or separate branch)
    ├── claude-code/
    │   └── personal/
    │       ├── commands/
    │       ├── skills/
    │       └── rules/
    └── zed/
        └── personal/
            └── settings.json

dotfiles/                        ← DEPLOYMENT LAYER
├── ai -> submodule or symlink to ai/
├── .claude/                     ← This repo's project configs
└── justfile
    ├── ai-build PROFILE TOOL   ← Compile ai/components → ai/dist
    ├── ai-deploy PROFILE TOOL  ← Copy ai/dist → ~/.claude, ~/.zed, etc
    └── ai-sync                 ← Pull ai/, build, deploy
```

### Component Schema Example (Future Design)

```json
// ai/components/rules/git-workflow.rule.json
{
  "$schema": "../schemas/rule.schema.json",
  "id": "git-workflow",
  "version": "1.0.0",
  "tags": ["git", "workflow", "commits"],
  "priority": 100,
  "conflicts_with": [],
  "depends_on": [],
  "content": {
    "title": "Git Workflow Rules",
    "sections": [
      {
        "heading": "Branch Strategy",
        "instructions": [
          "Use feature branches for all development",
          "Never commit directly to main/master"
        ]
      }
    ]
  },
  "output": {
    "claude-code": "markdown",
    "zed": "markdown",
    "cursor": "markdown"
  }
}
```

### Profile Example

```json
// ai/profiles/personal.profile.json
{
  "name": "personal",
  "description": "Personal development machines",
  "extends": ["minimal"],
  "rules": {
    "include": ["git-workflow", "security-*", "clean-code"],
    "exclude": ["enterprise-*"]
  },
  "skills": {
    "include": ["homebrew-formula", "github-actions-ci"]
  },
  "mcp": {
    "global": ["memory", "github", "context7"],
    "local_templates": ["filesystem"]
  },
  "variables": {
    "github_user": "arustydev",
    "default_branch": "main"
  }
}
```

### Workflow

1. **Develop in project**
   ```bash
   # Working in some-project/.claude/
   # Create/test a new skill
   ```

2. **Promote to source**
   ```bash
   promote-component skill ./some-project/.claude/skills/new-skill/
   # → Extracts, schemas, adds to ai/components/skills/
   # → Opens PR or commits to ai repo
   ```

3. **Build for profile/tool**
   ```bash
   cd dotfiles
   just ai-build personal claude-code
   # → Compiles ai/components → ai/dist/claude-code/personal/
   ```

4. **Deploy to global**
   ```bash
   just ai-deploy personal claude-code
   # → Copies ai/dist/claude-code/personal/ → ~/.claude/
   ```

5. **Sync on other machines**
   ```bash
   just ai-sync
   # → git pull ai/
   # → just ai-build $PROFILE claude-code
   # → just ai-deploy $PROFILE claude-code
   ```

### Why This Architecture

| Requirement | How It's Met |
|-------------|--------------|
| Share configs | `ai/` repo is standalone, shareable |
| project → source → global | `promote` → `build` → `deploy` |
| Machine profiles | `profiles/*.profile.json` |
| Multi-tool support | `tools/*/schema.json` for each tool |
| Atomic components | `components/` with schema validation |
| Future experiments | Structured data enables diff/compare/analyze |
| MCP classes | `mcp/global/` vs `mcp/local/` |
| 1Password secrets | Templates use `op://` refs, resolved at deploy |

### Migration Path

**Phase 1: Structure (Now)**
1. Restructure `ai/` repo with new directory layout
2. Keep existing content in `legacy/` during migration
3. Add `dotfiles/` as submodule consumer or keep separate

**Phase 2: Basic Workflow (Soon)**
1. Create `promote-component` script (simple copy + commit for now)
2. Create `just ai-build` (simple copy, no compilation yet)
3. Create `just ai-deploy` (copy to target locations)
4. Migrate key configs to new structure

**Phase 3: Schema & Compilation (Future)**
1. Define JSON schemas for rules, skills, etc.
2. Build `compile.py` that generates tool-specific output
3. Migrate components to schema'd format
4. Add validation to CI

**Phase 4: Profiles & MCP (Future)**
1. Define profile schema
2. Implement profile-based filtering
3. Add MCP config generation
4. Add `op://` resolution at deploy time

### Immediate Next Steps

1. **Decide on ai/dotfiles relationship**:
   - Submodule (recommended for clean separation)
   - Symlink (simpler but less portable)
   - Copy-based (most flexible but can drift)

2. **Create initial structure in ai repo**
3. **Create basic promote/build/deploy scripts**
4. **Migrate one component type (e.g., rules) as proof of concept**

---

## Questions to Consider

1. **Submodule vs other linking?** Submodule gives version pinning and clean separation.

2. **Build tool language?** Python, Deno/TypeScript, or shell scripts?

3. **Where does profile selection happen?** Environment variable? Machine hostname? Manual?

4. **CI for ai repo?** Validate schemas, run tests on changes?
