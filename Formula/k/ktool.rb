class Ktool < Formula
  include Language::Python::Virtualenv

  desc "Mach-O and ObjC analysis toolkit"
  homepage "https://github.com/0cyn/ktool"
  url "https://github.com/0cyn/ktool/archive/refs/tags/2.0.0.tar.gz"
  sha256 "d15d468ec21675633f3cb44190482420c74d61205904f98c29b2783f80d92bac"
  license "MIT"
  head "https://github.com/0cyn/ktool.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "python@3.14"

  def install
    venv = virtualenv_create(libexec, "python3.14")
    # ktool uses pkg_resources which requires setuptools
    venv.pip_install "setuptools"
    venv.pip_install "k2l==#{version}"
    bin.install_symlink Dir[libexec/"bin/ktool"]
  end

  test do
    assert_match "ktool", shell_output("#{bin}/ktool --help")
  end
end
