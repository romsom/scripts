#!/bin/bash

# Idea:
#  - add files to a tar ball
#    - possibly a very large amount of data, which may not fir in RAM or on permanent storage
#  - calculate sha256sums on the fly, save in an external file and add to the archive
# dependencies:
#  - mktemp
#  - GNU parallel
#  - pv
#  - ionice

# BLOCKSIZE must be 512 * BLOCKING_FACTOR
BLOCKING_FACTOR="1000"
BLOCKSIZE="512000"

ROOT="$1"
shift
TARGET="$1"
shift
SHAFILE="$1"
shift
# remaining parameters are arguments to find

TEMP=$(mktemp -d)
#[ "x$TEMP" != "x" ] && exit 1
TF_FIFO="$TEMP/tape-finished.fifo"
CF_FIFO="$TEMP/checksums-finished.fifo"
mkfifo "$TF_FIFO"

pushd "$ROOT" || exit 1
echo "Adding files to archive ..."
find "$@" -type f -print0 | tee >(ionice -c2 -n7 parallel -0 sha256sum | sort -k2 > "$TEMP/sha256sums"; : > "$CF_FIFO") | ionice -c2 -n4 tar -cf >(ionice -c2 -n4 pv -B ${BLOCKSIZE} > "$TARGET"; : > "$TF_FIFO") --null -T -
#find "$ROOT" -type f -print0 | tee >(parallel -0 sha256sum > "$TEMP/sha256sums") > "$TARGET.list"
echo "Waiting for tape drive to finish ..."
read < "$TF_FIFO"
echo "Waiting for checksum calculations to finish ..."
read < "$CF_FIFO"
sleep 5
echo "Adding checksums to archive ..."
tar -C "$TEMP" -b ${BLOCKING_FACTOR} -rf "$TARGET" sha256sums
head "$TEMP/sha256sums"
if [ "x${SHAFILE}" != "x" ]; then
	cp "$TEMP/sha256sums" "$SHAFILE"
fi
rm -r "$TEMP"
popd
