class TddGuardGo < Formula
  desc "TDD Guard reporter for Go test frameworks"
  homepage "https://github.com/nizos/tdd-guard"
  url "https://github.com/nizos/tdd-guard/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "2cff0aebbae4e22a5944494c8397dc40115e152478bac55835aa8387ce3bac44"
  license "MIT"
  head "https://github.com/nizos/tdd-guard.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    cd "reporters/go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tdd-guard-go"
    end
  end

  test do
    assert_match "tdd-guard-go", shell_output("#{bin}/tdd-guard-go --help 2>&1")
  end
end
