#!/bin/bash


# Convert the archive of the Flutter app to a Flatpak.


# Exit if any command fails
set -e

# Echo all commands for debug purposes
set -x


# No spaces in project name.
projectName=Musily
projectId=org.app.musily
executableName=musily


# ------------------------------- Build Flatpak ----------------------------- #

buildDir=build/linux/x64/release/bundle
mkdir -p $projectName
cp -r $buildDir/* $projectName

# Copy the portable app to the Flatpak-based location.

mkdir -p /app/bin
cp -r $projectName/* /app/bin
chmod +x /app/bin/$executableName

# Install the icon.
iconDir=/app/share/icons/hicolor/scalable/apps
mkdir -p $iconDir
cp -r assets/icons/$projectId.svg $iconDir/

# Install the desktop file.
desktopFileDir=/app/share/applications
mkdir -p $desktopFileDir
cp -r flatpak/$projectId.desktop $desktopFileDir/

# Install the AppStream metadata file.
metadataDir=/app/share/metainfo
mkdir -p $metadataDir
cp -r flatpak/$projectId.metainfo.xml $metadataDir/