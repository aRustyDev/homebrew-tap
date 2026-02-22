class Gitnr < Formula
  desc "Generate .gitignore files from TopTal, GitHub, or custom templates"
  homepage "https://github.com/reemus-dev/gitnr"
  url "https://github.com/reemus-dev/gitnr/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "835f56863b043d39f572d63914af07bbc9e0a7814de404ebc0e147d460e10cdc"
  license "MIT"
  head "https://github.com/reemus-dev/gitnr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "pkgconf" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "gitnr", shell_output("#{bin}/gitnr --help")
  end
end
