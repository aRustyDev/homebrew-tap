class Flamelens < Formula
  desc "Flamegraph viewer in the terminal"
  homepage "https://github.com/YS-L/flamelens"
  url "https://github.com/YS-L/flamelens/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "d491dbafbc8cedc4a7df2294e31a017b34edd068cb32471bda28e8208a6b1c5e"
  license "MIT"
  head "https://github.com/YS-L/flamelens.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "flamelens", shell_output("#{bin}/flamelens --help")
  end
end
