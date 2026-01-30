class Frontmatter < Formula
  desc "CLI tool to parse and extract markdown frontmatter as YAML or JSON"
  homepage "https://github.com/rythoris/frontmatter"
  head "https://github.com/rythoris/frontmatter.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "frontmatter", shell_output("#{bin}/frontmatter --help", 2)
  end
end
