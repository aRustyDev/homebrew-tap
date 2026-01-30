class JwtUi < Formula
  desc "Terminal UI for decoding and inspecting JSON Web Tokens"
  homepage "https://github.com/jwt-rs/jwt-ui"
  url "https://github.com/jwt-rs/jwt-ui/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "97c6a8cd998adcf80147aa12084efd5ca5bf2f0ead4645851837967d98114630"
  license "MIT"
  head "https://github.com/jwt-rs/jwt-ui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "jwt-ui", shell_output("#{bin}/jui --help")
  end
end
