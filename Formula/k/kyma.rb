class Kyma < Formula
  desc "Command-line tool for generating documentation"
  homepage "https://github.com/museslabs/kyma"
  url "https://github.com/museslabs/kyma/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ee2e3da492b51a352dda5c6ad9e3d6d0f8da212b1eaacce655ffb39c2986c36d"
  license "GPL-3.0-only"
  head "https://github.com/museslabs/kyma.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "kyma", shell_output("#{bin}/kyma --help")
  end
end
