#!/usr/bin/env bash
#
# Voxer build script
#
# Author: Dave Eddy <dave@daveeddy.com>
# Date: 6/19/14

out=$1
arch=${2:-x64}

if [[ -z $out ]]; then
	echo 'error: out directory must be specified as the first argument'
	exit 1
fi

if [[ $arch != x64 ]]; then
	echo 'error: only x64 builds supported for bud' >&2
	exit 1
fi

echo '> cleaning up previous builds'
rm -rf out

echo '> pulling git submodules'
git submodule update --init --recursive

echo '> pulling gyp'
svn co http://gyp.googlecode.com/svn/trunk tools/gyp

echo '> running ./gyb_bud'
./gyp_bud > /dev/null   || exit 1

echo '> running make'
make -C out/ > /dev/null|| exit 1

echo "> copying files to $out"
mkdir -p "$out/bin"
mv out/Release/bud "$out/bin" || exit 1

echo "> bud built in $SECONDS seconds, saved to $out"
echo
sha256sum "$out/bin/bud"
