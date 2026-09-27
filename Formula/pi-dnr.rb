class PiDnr < Formula
  desc "Pi coding agent for the shared dnr runtime"
  homepage "https://github.com/fansion314/pi"
  url "https://github.com/fansion314/pi/releases/download/pi-dnr-v0.87.1-3/pi-dnr-0.87.1-3-macos-arm64-r1.tar.gz"
  version "0.87.1-3"
  revision 1
  sha256 "e2f86b3e76b0d575a7d30d568d1680899abd42eba5f87fe2974b63949840d62a"
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
    assert_equal "0.87.1", shell_output("#{bin}/pi --version").strip
    assert_match "Usage:", shell_output("#{bin}/pi --help")
  end
end
