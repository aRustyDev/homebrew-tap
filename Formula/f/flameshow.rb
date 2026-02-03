class Flameshow < Formula
  include Language::Python::Virtualenv

  desc "Flamegraph viewer in the terminal"
  homepage "https://github.com/laixintao/flameshow"
  url "https://github.com/laixintao/flameshow/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "640cfb27faa42fb8915c4cbe5aedc242c0b5ad42020838f022b01b1d22812ac2"
  license "MIT"
  head "https://github.com/laixintao/flameshow.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "python@3.14"

  def install
    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install buildpath
    bin.install_symlink Dir[libexec/"bin/flameshow"]
  end

  test do
    assert_match "flameshow", shell_output("#{bin}/flameshow --help")
  end
end
