#!/usr/bin/env bash
# Point pkgs/blender-bin at the newest official Blender release.
# Reads the published .sha256 file, so nothing big is downloaded here.
set -euo pipefail

mirror="https://mirrors.ocf.berkeley.edu/blender/release"
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

series="$(curl -fsSL "$mirror/" | grep -oE 'Blender[0-9]+\.[0-9]+/' | sort -uV | tail -n1)"
series="${series%/}"

version="$(curl -fsSL "$mirror/$series/" |
  grep -oE 'blender-[0-9]+\.[0-9]+\.[0-9]+-linux-x64\.tar\.xz' |
  sed -E 's/^blender-(.*)-linux-x64\.tar\.xz$/\1/' | sort -uV | tail -n1)"

if [ -z "$version" ]; then
  echo "No Linux release found in $mirror/$series" >&2
  exit 1
fi

sha256="$(curl -fsSL "$mirror/$series/blender-$version.sha256" |
  awk -v f="blender-$version-linux-x64.tar.xz" '$2 == f { print $1 }')"

if [ -z "$sha256" ]; then
  echo "No checksum for blender-$version-linux-x64.tar.xz" >&2
  exit 1
fi

current="$(sed -nE 's/.*"version": "([^"]+)".*/\1/p' "$here/source.json")"
cat >"$here/source.json" <<EOF
{
  "version": "$version",
  "sha256": "$sha256"
}
EOF

if [ "$current" = "$version" ]; then
  echo "blender-bin already at $version"
else
  echo "blender-bin $current -> $version"
fi
