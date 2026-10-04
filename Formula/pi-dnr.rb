class PiDnr < Formula
  desc "Pi coding agent for the shared dnr runtime"
  homepage "https://github.com/fansion314/pi"
  url "https://github.com/fansion314/pi/releases/download/pi-dnr-v1.0.2-1/pi-dnr-1.0.2-1-macos-arm64-r1.tar.gz"
  version "1.0.2-1"
  revision 1
  sha256 "dd1eaf8e58c999e330b1ee02bb801d4d6652bbda5544abd52352901776342f72"
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
    assert_equal "1.0.2", shell_output("#{bin}/pi --version").strip
    assert_match "Usage:", shell_output("#{bin}/pi --help")
  end
end
