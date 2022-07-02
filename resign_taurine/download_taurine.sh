#!/bin/bash
set -e
rm -r taurineout || true
mkdir taurineout
cd taurineout
wget https://github.com/Odyssey-Team/Taurine/releases/download/1.1.3/Taurine-1.1.3.ipa
unzip Taurine-1.1.3.ipa
