class SmartTree < Formula
  desc "Context-aware directory visualization tool with TUI and MCP integration"
  homepage "https://github.com/8b-is/smart-tree"
  url "https://github.com/8b-is/smart-tree/releases/download/v6.5.2/st-v6.5.2-aarch64-apple-darwin.tar.gz"
  sha256 "b15059ed6da76b54e23c7e2932014ac9a17a7b2d4e47ed67fccee2f0ba1930aa"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on :macos

  resource "intel-binary" do
    on_intel do
      url "https://github.com/8b-is/smart-tree/releases/download/v6.5.2/st-v6.5.2-x86_64-apple-darwin.tar.gz"
      sha256 "4a165904dbf7d51a4b8867f68c191026386fda2060e9018d80b023a767bff1d7"
    end
  end

  def install
    if Hardware::CPU.intel?
      resource("intel-binary").stage do
        bin.install "st"
      end
    else
      bin.install "st"
    end
  end

  test do
    assert_match "st", shell_output("#{bin}/st --help")
  end
end
