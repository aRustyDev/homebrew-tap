class SmartTree < Formula
  desc "Context-aware directory visualization tool with TUI and MCP integration"
  homepage "https://github.com/8b-is/smart-tree"
  url "https://github.com/8b-is/smart-tree/archive/refs/tags/v6.5.2.tar.gz"
  sha256 "df8f483f6e7f1f56f982d0a3be22ae24e8f38345a3ffc2e4536c41f5b691b7d6"
  license "MIT"
  head "https://github.com/8b-is/smart-tree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "st", shell_output("#{bin}/st --help")
  end
end
