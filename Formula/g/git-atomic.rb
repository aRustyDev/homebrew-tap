class GitAtomic < Formula
  desc "Git subcommand for creating atomic commits & branches"
  homepage "https://github.com/aRustyDev/git-atomic"
  url "https://github.com/aRustyDev/git-atomic/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MIT"
  head "https://github.com/aRustyDev/git-atomic.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"git-atomic", "--help"
  end
end
