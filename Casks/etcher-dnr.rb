cask "etcher-dnr" do
  version "2.1.7-dnr.5,1"
  sha256 "3edb2d036ab2c82a392b5a98b8ff54f6cc4c52a2f924a7a45b7594ae7351455f"

  url "https://github.com/fansion314/etcher/releases/download/v2.1.7-dnr.5/etcher-dnr-2.1.7-5-macos-arm64-r1.tar.gz"
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
