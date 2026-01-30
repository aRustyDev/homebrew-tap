class GitAtomic < Formula
  desc "Git subcommand for creating atomic commits & branches"
  homepage "https://github.com/aRustyDev/git-atomic"
  url "https://github.com/aRustyDev/git-atomic/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "0e7d1a9aa01a94323d76bd6ee94a31ceba06d9b7e23cc884e9e1fb0b0aaaa410"
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
