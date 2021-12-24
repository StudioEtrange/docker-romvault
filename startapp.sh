#!/usr/bin/env sh
#shellcheck shell=sh

set -xe

HOME=/config
export HOME

cd /config

# Set up symlinks.
# We need to launch ROMVault from /config as this is where it will write its config.
for f in /opt/romvault/*; do
    ln -fs $f /config/ || true
done

mono /config/ROMVault3.exe
