class Lazyworktree < Formula
  desc "TUI for managing Git worktrees"
  homepage "https://github.com/chmouel/lazyworktree"
  url "https://github.com/chmouel/lazyworktree/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "c1aedba2cb0f6da51398e8287017a3a7bb2f2a9caca64502456f88d2bb23c1dd"
  license "Apache-2.0"
  head "https://github.com/chmouel/lazyworktree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/lazyworktree"
  end

  test do
    assert_match "lazyworktree", shell_output("#{bin}/lazyworktree --help")
  end
end
