class Euporie < Formula
  include Language::Python::Virtualenv

  desc "Terminal-based interactive computing environment for Jupyter"
  homepage "https://github.com/joouha/euporie"
  url "https://github.com/joouha/euporie/archive/refs/tags/v2.10.3.tar.gz"
  sha256 "f9651dbde2810e46145ede8a5e311e3d68903527c403d228f453452c94bea894"
  license "MIT"
  head "https://github.com/joouha/euporie.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources(using: "python@3.14")
  end

  test do
    assert_match "euporie", shell_output("#{bin}/euporie --help")
  end
end
