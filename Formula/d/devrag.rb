class Devrag < Formula
  desc "Markdown vector search MCP server for Claude Code"
  homepage "https://github.com/tomohiro-owada/devrag"
  url "https://github.com/tomohiro-owada/devrag/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "ec05a1d6018fdd2a5bf8f789e1d0b76957da51bba87e9f7bc985b17254d70b2d"
  license :cannot_represent
  head "https://github.com/tomohiro-owada/devrag.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.BuildTime=#{time.iso8601}
      -X main.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/devrag --version")
  end
end
