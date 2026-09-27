cask "etcher-dnr" do
  version "2.1.7-dnr.4,1"
  sha256 "b442f590df52ca70b4a543646a7d1d6ef825998c29d9108d76f4d5780b32c719"

  url "https://github.com/fansion314/etcher/releases/download/v2.1.7-dnr.4/etcher-dnr-2.1.7-4-macos-arm64-r1.tar.gz"
  name "balenaEtcher (dnr)"
  desc "Flash OS images using the shared dnr runtime"
  homepage "https://github.com/fansion314/etcher"

  depends_on arch: :arm64
  depends_on macos: :sequoia
  depends_on formula: "fansion314/dnr/dnr"

  app "balenaEtcher.app"

  preflight_steps do
    run "/usr/bin/codesign",
        args: ["--verify", "--deep", "--strict", "{{staged_path}}/balenaEtcher.app"]
  end

  postflight_steps do
    # Explicit policy of this personal tap: approve only this installed app.
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{appdir}}/balenaEtcher.app"]
  end

  caveats <<~EOS
    This app is ad-hoc signed and is not notarized by Apple.
    This tap removes the quarantine attribute from this app only after installation.
    macOS Gatekeeper settings and application data are left unchanged.
  EOS
end
