class YoutubeTui < Formula
  desc "TUI client for YouTube built in Rust"
  homepage "https://github.com/Siriusmart/youtube-tui"
  url "https://github.com/Siriusmart/youtube-tui/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "d5f1829d4798c167928d811309d1fed6e9d33cd5d3fd8496bca9b84ccc105575"
  license "GPL-3.0-only"
  head "https://github.com/Siriusmart/youtube-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
    depends_on "zlib"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "youtube-tui", shell_output("#{bin}/youtube-tui --help")
  end
end
