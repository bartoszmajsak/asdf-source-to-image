#!/usr/bin/env bash

set -euo pipefail

GH_REPO_SLUG="openshift/source-to-image"
GH_REPO="https://github.com/${GH_REPO_SLUG}"
TOOL_NAME="s2i"
TOOL_TEST="s2i --help"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  list_github_tags
}

tagged_commit() {
  local tag
  tag="v$1"
  url=$(curl "${curl_opts[@]}" "https://api.github.com/repos/${GH_REPO_SLUG}/git/refs/tags/$tag" | jq -r .object.url)
  curl "${curl_opts[@]}" "${url}" | jq -r .object.sha | cut -c1-8
}


get_arch() {
  local platform=""
  
  case "$(uname -m)" in
    
    i686|x86_64|amd64)
      platform="amd64"
      ;;

    i386)
      platform="386"
      ;;

    *)
      fail "unsupported_machine"
      ;;

  esac
  
  case "$(uname -s)" in

    Darwin)
      echo "darwin-${platform}"
      ;;

    Linux)
      echo "linux-${platform}"
      ;;

    CYGWIN*|MINGW32*|MSYS*)
      echo "windows-${platform}"
      ;;

    *)
      fail 'unsupported_os'
      ;;
  esac
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"

  commit=$(tagged_commit "$version")
  arch=$(get_arch)
  url="$GH_REPO/releases/download/v${version}/source-to-image-v${version}-${commit}-${arch}.tar.gz"

  echo "* Downloading $TOOL_NAME release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="${3%/bin}/bin"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    mkdir -p "$install_path"
    cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error occurred while installing $TOOL_NAME $version."
  )
}
