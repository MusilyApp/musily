#!/bin/bash

# Caminho do arquivo pubspec.yaml e CHANGELOG.md
pubspec_file="pubspec.yaml"
changelog_file="CHANGELOG.md"

# Função para extrair a versão do pubspec.yaml
get_version() {
  version=$(grep 'version:' "$pubspec_file" | awk '{print $2}' | awk -F'+' '{print $1}')
  echo "$version"
}

# Função para extrair a descrição do CHANGELOG.md com base na versão
get_description() {
  version=$1
  description=$(awk '/^##[[:blank:]]*'"${version}"'[[:blank:]]*$/ { flag=1; next } flag && /^##/ { flag=0 } flag { buffer=buffer $0 "\n" } END { print buffer }' "$changelog_file")

  # Verifica se a descrição foi encontrada
  if [ -z "$description" ]; then
    echo "Description not found in $changelog_file for version $version"
    exit 1
  fi

  echo "$description"
}

# Função para exibir ajuda
show_help() {
  echo "Usage: $0 [--version | --description]"
  echo "  --version       Display the current version from pubspec.yaml"
  echo "  --description   Display the description for the current version from CHANGELOG.md"
}

# Verifica os argumentos passados
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
