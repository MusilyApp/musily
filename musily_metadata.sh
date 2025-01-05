#!/bin/bash

# Path to the pubspec.yaml and CHANGELOG.md files
pubspec_file="pubspec.yaml"
changelog_file="CHANGELOG.md"

# Function to extract the version from pubspec.yaml
get_version() {
  version=$(grep 'version:' "$pubspec_file" | awk '{print $2}' | awk -F'+' '{print $1}')
  echo $version
}

# Function to extract the description from CHANGELOG.md based on the version
get_description() {
  version=$1
  description=$(awk '/^##[[:blank:]]*'"${version}"'[[:blank:]]*$/ { flag=1; next } flag && /^##/ { flag=0 } flag { buffer=buffer $0 "\n" } END { print buffer }' "$changelog_file")

  # Check if the description was found
  if [ -z "$description" ]; then
    echo "Description not found in $changelog_file for version $version"
    exit 1
  fi

  # Use printf to preserve newlines
  printf "%s" "$description"
}

# Function to display help
show_help() {
  echo "Usage: $0 [--version | --description]"
  echo "  --version       Display the current version from pubspec.yaml"
  echo "  --description   Display the description for the current version from CHANGELOG.md"
}

# Check the passed arguments
case "$1" in
  --version)
    get_version
    ;;
  --description)
    version=$(get_version)
    get_description "$version"
    ;;
  *)
    show_help
    exit 1
    ;;
esac
