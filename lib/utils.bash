#!/usr/bin/env bash

set -eo pipefail

GH_REPO="https://github.com/thisisibrahimd/opensloctl"
TOOL_NAME="opensloctl"
TOOL_TEST="opensloctl --help"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if coder is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi


sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/v.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	list_github_tags
}

get_architecture() {
	local architecture

	case "$(uname -m)" in
	x86_64 | x86-64 | x64 | amd64) architecture="x86_64" ;;
	i386 | i486 | i686 | i786 | x86) architecture="i386" ;;
	aarch64 | arm64) architecture="arm64" ;;
	xscale | armv6l | arm ) architecture="arm" ;;
	# armv7l | armv8l) architecture="armv7" ;;
	# ppc64le) architecture="powerpc64le" ;;
	*) fail "Unsupported architecture" ;;
	esac

	echo $architecture
}

get_platform() {
	local platform

	case "$OSTYPE" in
	darwin*) platform="darwin" ;;
	linux*) platform="linux" ;;
	# openbsd*) platform="unknown-freebsd" ;;
	# netbsd*) platform="unknown-netbsd" ;;
	*) fail "Unsupported platform" ;;
	esac

	echo $platform
}

download_release() {
	local version filename platform architecture
	version="$1"
	filename="$2"
	download_path="$3"
	architecture=$(get_architecture)
	platform=$(get_platform)

	url="$GH_REPO/releases/download/v${version}/${TOOL_NAME}_${platform}_${architecture}.tar.gz"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
	tar xvf $filename --directory $download_path
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"
	install_file="$install_path/$TOOL_NAME"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp "$ASDF_DOWNLOAD_PATH/$TOOL_NAME" "$install_file"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
