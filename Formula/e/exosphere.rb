class Exosphere < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for managing DigitalOcean infrastructure"
  homepage "https://github.com/mrdaemon/exosphere"
  url "https://github.com/mrdaemon/exosphere/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "3985382cf4d99aebcec17119af2c5163fa013d7b9fc3829e2da4c03bc343790c"
  license "MIT"
  head "https://github.com/mrdaemon/exosphere.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "python@3.14"

  uses_from_macos "zlib"

  def install
    venv = virtualenv_create(libexec, "python3.14")
    # Install from source (not on PyPI) with dependencies
    system venv.root/"bin/python", "-m", "pip", "install", buildpath
    bin.install_symlink Dir[libexec/"bin/exosphere"]
  end

  test do
    assert_match "exosphere", shell_output("#{bin}/exosphere --help")
  end
end
