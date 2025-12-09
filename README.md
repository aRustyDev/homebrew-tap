# ARustyDev Tap

## How do I install these formulae?

### Create the tap

`brew tap aRustyDev/tap https://github.com/aRustyDev/homebrew-tap.git`

### Install a formula

`brew install <formula>`

## CI/CD

### Automated Formula Updates

This tap uses [dawidd6/action-homebrew-bump-formula](https://github.com/dawidd6/action-homebrew-bump-formula) to automatically detect and update outdated formulas.

**Schedule:** Daily at 2 AM UTC

**Manual Trigger:** Go to Actions → "Bump Formulas" → "Run workflow"

**Inputs:**
- `formula`: Specific formula to check (leave empty for all)
- `force`: Force check even if PR already exists

When updates are found, the workflow automatically:
1. Downloads the new source tarball
2. Calculates the SHA256 hash
3. Creates a PR with the version bump

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

### Add a New Formula (ie package install directions)

#### Golang

`brew create --tap tapname/tap --set-version $VERSION --HEAD --go https://github.com/aRustyDev/homebrew-tap.git`

#### Rust

`brew create --tap tapname/tap --set-version $VERSION --HEAD --rust https://github.com/aRustyDev/homebrew-tap.git`

#### Archive

`brew create --tap tapname/tap --set-version $VERSION https://github.com/aRustyDev/target-project/-/archive/1.1.0/aws-sso-1.1.0.tar`

### Aliases

- `Aliases/FooAlias` `../Formula/f/foo.rb`
