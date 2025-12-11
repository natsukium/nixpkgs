#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update gnused

set -euo pipefail

nix-update oxfmt --version-regex 'oxfmt_v(.*)'

linux_hash=$(
  nix-build --no-link --expr \
    '(import ./. { system = "x86_64-linux"; }).oxfmt.pnpmDeps.overrideAttrs { outputHash = ""; }' \
    2>&1 || true
)
linux_hash=$(echo "$linux_hash" | sed -nE 's/.*got: *(sha256-[A-Za-z0-9+/=]+).*/\1/p' | tail -1)

darwin_hash=$(
  nix-build --no-link --expr \
    '(import ./. { system = "aarch64-darwin"; }).oxfmt.pnpmDeps.overrideAttrs { outputHash = ""; }' \
    2>&1 || true
)
darwin_hash=$(echo "$darwin_hash" | sed -nE 's/.*got: *(sha256-[A-Za-z0-9+/=]+).*/\1/p' | tail -1)

sed -i "s|linux = \"sha256-[^\"]*\"|linux = \"$linux_hash\"|" pkgs/by-name/ox/oxfmt/package.nix
sed -i "s|darwin = \"sha256-[^\"]*\"|darwin = \"$darwin_hash\"|" pkgs/by-name/ox/oxfmt/package.nix
