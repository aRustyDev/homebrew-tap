class JustMcp < Formula
  desc "MCP server for Just"
  homepage "https://github.com/PromptExecution/just-mcp"
  url "https://github.com/PromptExecution/just-mcp/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "047c58d0ddea28178bfb2abdf4add5e1fec3d9a69c433c1c95e70294ce719f78"
  license "MIT"

  head "https://github.com/PromptExecution/just-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "just-mcp", shell_output("#{bin}/just-mcp --version")
  end
end
