# typed: strict
# frozen_string_literal: true

# Formula for mustache - Mustache template engine CLI
class Mustache < Formula
  desc "CLI for the Mustache template language"
  homepage "https://github.com/cbroglie/mustache"
  url "https://github.com/cbroglie/mustache/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "3330c4516ffd3797ac9744280d2b0e1619faca082832e15d08eca9234af08636"
  license "MIT"
  head "https://github.com/cbroglie/mustache.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/mustache"
  end

  test do
    (testpath/"template.mustache").write("Hello {{name}}!")
    (testpath/"data.yml").write("name: World")
    output = shell_output("#{bin}/mustache #{testpath}/data.yml #{testpath}/template.mustache")
    assert_equal "Hello World!", output.strip
  end
end
