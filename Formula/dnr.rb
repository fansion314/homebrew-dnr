class Dnr < Formula
  desc "Shared Deno runtime and application packager"
  homepage "https://github.com/fansion314/dnr"
  url "https://github.com/fansion314/dnr/releases/download/v0.5.2/dnr-0.5.2-macos-arm64.tar.gz"
  version "0.5.2"
  sha256 "4fbbb588335b7f7eb71c53b2b465627f10d5122cb21bb883c233b5a0067fe4ae"
  license "MIT"

  depends_on arch: :arm64
  depends_on macos: :sequoia

  def install
    bin.install "bin/dnr", "bin/dnc"
    doc.install "README.md", "README.zh.md", "THIRD_PARTY.md", "docs"
    (pkgshare/"licenses").install Dir["licenses/*"]
  end

  test do
    assert_match "dnr #{version}", shell_output("#{bin}/dnr --version")
    assert_match "dnc #{version}", shell_output("#{bin}/dnc --version")
    (testpath/"app/main.ts").write <<~TS
      const value: string = Deno.readTextFileSync(new URL("./data.txt", import.meta.url));
      console.log(`${value}:${Deno.args[0]}`);
    TS
    (testpath/"app/data.txt").write "homebrew"
    system bin/"dnc", "app", "--entry", "main.ts", "--app-id", "dev.dnr.homebrew.test", "-o", "app.dnp"
    assert_equal "homebrew:ok", shell_output("#{bin}/dnr app.dnp ok").strip
  end
end
