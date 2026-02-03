class CargoSelector < Formula
  desc "Cargo subcommand to select and execute binary/example targets"
  homepage "https://github.com/lusingander/cargo-selector"
  url "https://github.com/lusingander/cargo-selector/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "6c17f04ce1ac1fb587d683be58bfdebf1e5981e12a21dde1cfffd1970cf2acfb"
  license "MIT"
  head "https://github.com/lusingander/cargo-selector.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "cargo selector", shell_output("#{bin}/cargo-selector --help")
  end
end
