class HexPatch < Formula
  desc "Binary patcher and hex editor with terminal UI"
  homepage "https://github.com/Etto48/HexPatch"
  url "https://github.com/Etto48/HexPatch/archive/refs/tags/v1.12.5.tar.gz"
  sha256 "089a87c1128483507bef4f89df5ea4e0a7ffe09210b3a9cfa687705f86ea621f"
  license "MIT"
  head "https://github.com/Etto48/HexPatch.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "HexPatch", shell_output("#{bin}/hex-patch --help")
  end
end
