#!/bin/sh
set -e
clang -o spawn_root_x86 -target x86_64-apple-macos12 -Os -fmodules spawn_root.m
clang -o spawn_root_arm64 -target arm64-apple-macos12 -Os -fmodules spawn_root.m
lipo -create -output spawn_root spawn_root_x86 spawn_root_arm64
codesign -s "Worth Doing Badly Developer ID" -f --entitlements spawn_root.entitlements spawn_root
