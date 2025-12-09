# typed: strict
# frozen_string_literal: true

# Formula for zed-prompts - Zed prompt library import/export tool
class ZedPrompts < Formula
  desc "Import and export prompts from Zed's prompt library"
  homepage "https://github.com/rubiojr/zed-prompts"
  url "https://github.com/rubiojr/zed-prompts/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "df1614deeb7f63b0bbfb9c2dd7c06a526b789f0f3858eddceb3e59a15323bca5"
  license "MIT"
  head "https://github.com/rubiojr/zed-prompts.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # Test that the binary runs and shows help
    assert_match "export", shell_output("#{bin}/zed-prompts --help")
    assert_match "import", shell_output("#{bin}/zed-prompts --help")
  end
end
