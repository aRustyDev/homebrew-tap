class Labcoat < Formula
  desc "TUI for managing GitLab CI/CD pipelines"
  homepage "https://github.com/jhillyerd/labcoat"
  head "https://github.com/jhillyerd/labcoat.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "labcoat", shell_output("#{bin}/labcoat --help")
  end
end
