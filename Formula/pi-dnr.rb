class PiDnr < Formula
  desc "Pi coding agent for the shared dnr runtime"
  homepage "https://github.com/fansion314/pi"
  url "https://github.com/fansion314/pi/releases/download/pi-dnr-v0.99.2-1/pi-dnr-0.99.2-1-macos-arm64-r1.tar.gz"
  version "0.99.2-1"
  revision 1
  sha256 "2ec12f3a20cf3a5685a2828b6c4f402597e7821d0c6eb32b05ee7583175854a8"
  license "MIT"

  depends_on arch: :arm64
  depends_on macos: :sequoia
  depends_on "fansion314/dnr/dnr"
  depends_on "fd"
  depends_on "ripgrep"

  def install
    system Formula["fansion314/dnr/dnr"].opt_bin/"dnc", "install", "pi.dnp", libexec/"app"
    (bin/"pi").write <<~SH
      #!/bin/sh
      exec "#{Formula["fansion314/dnr/dnr"].opt_bin}/dnr" "#{libexec}/app/pi.dnp" "$@"
    SH
  end

  test do
    ENV["PI_OFFLINE"] = "1"
    ENV["PI_TELEMETRY"] = "0"
    ENV["PI_CODING_AGENT_DIR"] = (testpath/"config").to_s
    assert_equal "0.99.2", shell_output("#{bin}/pi --version").strip
    assert_match "Usage:", shell_output("#{bin}/pi --help")
  end
end
