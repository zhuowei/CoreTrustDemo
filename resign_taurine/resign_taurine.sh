#!/bin/bash
set -e
rm -r taurinedeb || true
mkdir -p taurinedeb/Applications
cp -a DEBIAN taurinedeb/
cp -a taurineout/Payload/Taurine.app taurinedeb/Applications
codesign -s "Worth Doing Badly iPhone OS Application Signing" -f --entitlements=taurine.entitlements taurinedeb/Applications/Taurine.app
dpkg-deb --root-owner-group -b taurinedeb Taurine.deb
