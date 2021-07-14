#!/bin/bash

# Idea:
#  - add files to a tar ball
#    - possibly a very large amount of data, which may not fir in RAM or on permanent storage
#  - calculate sha256sums on the fly, save in an external file and add to the archive
# dependencies:
#  - mktemp
#  - GNU parallel
#  - pv

ROOT="$1"
shift
TARGET="$1"
shift
SHAFILE="$1"
shift
# remaining parameters are arguments to find

TEMP=$(mktemp -d)
#[ "x$TEMP" != "x" ] && exit 1

pushd "$ROOT" || exit 1
find "$@" -type f -print0 | tee >(parallel -0 sha256sum | sort -k2 > "$TEMP/sha256sums") | tar -cf >(pv > "$TARGET") --null -T -
#find "$ROOT" -type f -print0 | tee >(parallel -0 sha256sum > "$TEMP/sha256sums") > "$TARGET.list"
tar -C "$TEMP" -rf "$TARGET" sha256sums
head "$TEMP/sha256sums"
if [ "x${SHAFILE}" != "x" ]; then
	cp "$TEMP/sha256sums" "$SHAFILE"
fi
rm -r "$TEMP"
popd
