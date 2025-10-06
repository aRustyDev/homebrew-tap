# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class JustMcp < Formula
  desc "MCP server for Just"
  homepage "https://github.com/PromptExecution/just-mcp"
  license "MIT"

  # Stable release - will be updated by GitHub workflow
  # url "https://github.com/PromptExecution/just-mcp/archive/refs/tags/v1.0.0.tar.gz"
  # sha256 "PLACEHOLDER_SHA256"

  # Development version from main branch
  head "https://github.com/PromptExecution/just-mcp.git", branch: "main"

  depends_on "rust" => :build
  depends_on "just" => :build

  def install
    system "cargo", "install", *std_cargo_args
    # TODO: add mcp server configs
  end

  test do
    # TODO: check 'just-mcp' is in PATH
    # TODO: check 'CARGO_HOME/bin' is in PATH
    # TODO: check 'just-mcp' is executable
    assert_match "just-mcp", shell_output("#{bin}/just-mcp --version")
  end
end

# just build    # Build the project
# just test     # Run tests
# just server   # Start MCP server
# just clean    # Clean build artifacts
