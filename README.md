# ARustyDev Tap

## How do I install these formulae?

### Create the tap

`brew tap aRustyDev/tap https://github.com/aRustyDev/homebrew-tap.git`

### Install a formula

`brew install <formula>`

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
