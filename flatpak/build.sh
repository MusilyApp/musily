#!/bin/bash

set -e

set -x

cd ..

# flutter clean
# flutter pub get
# flutter build linux

flatpak-builder --force-clean build-dir ./flatpak/org.app.musily.json --repo=repo --delete-build-dirs
flatpak build-bundle repo org.app.musily.flatpak org.app.musily