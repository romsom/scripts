#!/bin/bash
libs="libstdc++ libgpg libgcc"
for lib in $libs; do
    find ~/.local/share/Steam/ -name "$lib""*so*[!y]" -exec rm -f {} \;
done
true
