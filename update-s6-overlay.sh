#!/bin/bash

set -euo pipefail

usage() {
    cat >&2 <<'EOF'
Usage:
  ./update-s6-overlay.sh <version>
  ./update-s6-overlay.sh --legacy <version>

Examples:
  ./update-s6-overlay.sh 3.2.3.0
  ./update-s6-overlay.sh --legacy 3.2.1.0
EOF
}

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    usage
    exit 1
fi

legacy=0
if [ "${1:-}" = "--legacy" ]; then
    legacy=1
    shift
fi

if [ "$#" -ne 1 ]; then
    usage
    exit 1
fi

version=${1#v}
release="v${version}"
base_url="https://github.com/just-containers/s6-overlay/releases/download/${release}"
tmp_dir=$(mktemp -d)

cleanup() {
    rm -rf "$tmp_dir"
}
trap cleanup EXIT

sha256_file() {
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum "$1" | awk '{print $1}'
    else
        shasum -a 256 "$1" | awk '{print $1}'
    fi
}

download() {
    local asset=$1
    curl -fsSL "${base_url}/${asset}" -o "${tmp_dir}/${asset}"
    sha256_file "${tmp_dir}/${asset}"
}

replace_env() {
    local file=$1
    local name=$2
    local value=$3

    perl -0pi -e "s/^ENV ${name}=.*$/ENV ${name}=${value}/m" "$file"
}

if [ "$legacy" -eq 1 ]; then
    dockerfile=Dockerfile.3.16
    noarch_sha=$(download s6-overlay-noarch.tar.xz)
    i686_sha=$(download s6-overlay-i686.tar.xz)

    replace_env "$dockerfile" S6_OVERLAY_VERSION "$release"
    replace_env "$dockerfile" S6_OVERLAY_NOARCH_SHA256 "$noarch_sha"
    replace_env "$dockerfile" S6_OVERLAY_I686_SHA256 "$i686_sha"

    echo "Updated $dockerfile for s6-overlay ${release}"
    echo "  noarch: $noarch_sha"
    echo "  i686:   $i686_sha"
else
    dockerfile=Dockerfile
    noarch_sha=$(download s6-overlay-noarch.tar.xz)
    x86_64_sha=$(download s6-overlay-x86_64.tar.xz)
    aarch64_sha=$(download s6-overlay-aarch64.tar.xz)

    replace_env "$dockerfile" S6_OVERLAY_VERSION "$version"
    replace_env "$dockerfile" S6_OVERLAY_NOARCH_SHA256 "$noarch_sha"
    replace_env "$dockerfile" S6_OVERLAY_X86_64_SHA256 "$x86_64_sha"
    replace_env "$dockerfile" S6_OVERLAY_AARCH64_SHA256 "$aarch64_sha"

    echo "Updated $dockerfile for s6-overlay ${release}"
    echo "  noarch:  $noarch_sha"
    echo "  x86_64:  $x86_64_sha"
    echo "  aarch64: $aarch64_sha"
fi
