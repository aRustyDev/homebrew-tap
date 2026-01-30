class CargoSeek < Formula
  desc "Cargo subcommand to search and compare crates"
  homepage "https://github.com/tareqimbasher/cargo-seek"
  url "https://github.com/tareqimbasher/cargo-seek/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "d2d9b63d2ef7fe56d3c9c5045350b991d443ed9ca56c28ed72168a88ba97009e"
  license "MIT"
  head "https://github.com/tareqimbasher/cargo-seek.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "cargo-seek", shell_output("#{bin}/cargo-seek --help")
  end
end
