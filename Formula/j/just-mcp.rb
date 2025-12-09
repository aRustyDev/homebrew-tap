class JustMcp < Formula
  desc "MCP server for Just"
  homepage "https://github.com/PromptExecution/just-mcp"
  license "MIT"

  head "https://github.com/PromptExecution/just-mcp.git", branch: "main"

  depends_on "just" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "just-mcp", shell_output("#{bin}/just-mcp --version")
  end
end
