class TddGuardRust < Formula
  desc "TDD Guard reporter for Rust test frameworks"
  homepage "https://github.com/nizos/tdd-guard"
  url "https://github.com/nizos/tdd-guard/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "2cff0aebbae4e22a5944494c8397dc40115e152478bac55835aa8387ce3bac44"
  license "MIT"
  head "https://github.com/nizos/tdd-guard.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  def install
    cd "reporters/rust" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_match "tdd-guard-rust", shell_output("#{bin}/tdd-guard-rust --help")
  end
end
