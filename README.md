# DNR applications for Homebrew

One tap for the shared runtime and all applications built on it. Apple Silicon,
macOS 15 or newer. Packages do not bundle another copy of dnr.

```sh
brew tap fansion314/dnr
brew trust fansion314/dnr
brew install dnr pi-dnr
brew install --cask etcher-dnr
```

`pi-dnr` provides `pi`; Etcher installs `/Applications/balenaEtcher.app`. Each application depends on the
same `dnr` formula, which includes both dnr and dnc. Updates use `brew update`
and `brew upgrade`. Uninstall does not delete application data.

## Migrating the original source-repository tap

First quit applications using dnr. Homebrew 7 removes the old tap’s packages
when using `untap --force`; the last command reinstalls the runtime. The tap name
is unchanged. Its repository has moved from `fansion314/dnr` to
`fansion314/homebrew-dnr`:

```sh
brew untap --force fansion314/dnr
brew tap fansion314/dnr
brew trust fansion314/dnr
brew install fansion314/dnr/dnr
```

Before replacing manual app installations, quit the app and move the old bundle
out of `/Applications`. Install through Homebrew, verify it starts, then remove
the old copy. Check `which -a pi dnr dnc` for manual executables earlier on PATH.

## Signing policy

Trusting this tap permits Homebrew to execute its package definitions; it is not
Apple Developer ID trust. Etcher has an ad-hoc signature and is not notarized. Its cask verifies the shipped signature and automatically removes
`com.apple.quarantine` **only from the app it installs**, as an explicit policy
of this personal tap. It does not disable Gatekeeper or alter global security
settings. Install this cask only if you accept this policy and trust the publisher.

## Publishing

Pi and Etcher build and test on native ARM64 GitHub Actions runners in their
source repositories. Their macOS workflows support tags and manual publication
of a new package revision for an existing tag. Existing assets are immutable.
Songjian remains a local installation and is not distributed or managed by this tap.

This repository checks the fixed source allowlist twice hourly (subject to
GitHub scheduling delays), or via **Sync and test DNR releases**. It verifies
archive SHA-256 files and GitHub asset digests, installs and tests the candidates
with Homebrew on `macos-15`, and only then commits formula/cask updates. It uses
this repository's `GITHUB_TOKEN`; no cross-repository PAT is required. The numeric
version/revision guard prevents downgrades and same-version archive replacement.
Actual GUI interaction is validated separately; CLI CI does not prove GUI behavior.

Maintainers can run `python3 scripts/sync.py dnr pi-dnr etcher-dnr` and
`python3 -m unittest discover -s scripts -p 'test_*.py' -v` locally. `scripts/test-install.sh`
is for disposable macOS runners because it installs the applications.
