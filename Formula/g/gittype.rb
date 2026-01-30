class Gittype < Formula
  desc "TUI tool to practice and learn Git commands"
  homepage "https://github.com/unhappychoice/gittype"
  url "https://github.com/unhappychoice/gittype/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "8683af755410563122cad529d382087bf717e7aeaee9e1d1b053225668f34ef0"
  license "MIT"
  head "https://github.com/unhappychoice/gittype.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "gittype", shell_output("#{bin}/gittype --help")
  end
end
