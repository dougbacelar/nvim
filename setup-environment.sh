#!/bin/bash
set -e # exit immediately if anything returns a non-zero status

brew update

# list of packages to install via homebrew.
packages=(
  # window management
  yabai                           # window manager for macos
  skhd                            # shortcut daemon for macos
  # lsps
  typescript-language-server      # aka ts_ls. LSP implementation for TypeScript wrapping tsserver.
  vscode-langservers-extracted    # collection of language servers extracted from vscode (e.g., for html)
  basedpyright                    # python LSP server forked from pyright
  lua-language-server             # language server for lua (used for lua_ls)
  kotlin-language-server          # language server for kotlin
  # linters and formatters
  stylua                          # lua code formatter
  ktlint                          # kotlin linter/formatter
)

for item in "${packages[@]}"; do
  printf "\n\n* installing $item...\n"
  brew install "$item"
done

echo "all homebrew installations complete."


# ---
# manually install tools that are unavailable in homebrew
# ---

dev_dir="$HOME/dev"

# helper function to install a VSIX package
install_vsix() {
  local name="$1"      # name of the tool (for messages)
  local output_dir="$dev_dir/$1"       # target directory for extraction
  local output_file_path="$output_dir/$1.vsix"      # full path to the downloaded VSIX file
  local vsix_url="$2"       # download URL for the VSIX package

  echo -e "\n\n* installing ${name} manually..."
  if [ ! -d "$output_dir" ]; then
    mkdir -p "$output_dir"
    echo "downloading ${name} from ${vsix_url}..."
    curl -L -o "$output_file_path" "$vsix_url"
    unzip "$output_file_path" -d "$output_dir"
    echo "${name} extracted to ${output_dir}"
    echo "jar files should be under extension/server/"
  else
    echo "${name} is already installed in ${output_dir}"
  fi
}

# --- vscode-java-test installation ---
# https://github.com/microsoft/vscode-java-test
# based on: https://github.com/mason-org/mason-registry/blob/31d2e44bd36de98e8d5f5b9895a1f314e3b40a5b/packages/java-test/package.yaml#L2
# ---
java_test_version="0.43.0"
java_test_url="https://open-vsx.org/api/vscjava/vscode-java-test/${java_test_version}/file/vscjava.vscode-java-test-${java_test_version}.vsix"
install_vsix "java-test" "$java_test_url"

# --- vscode-java-debug installation ---
# https://github.com/microsoft/java-debug
# based on: https://github.com/mason-org/mason-registry/blob/31d2e44bd36de98e8d5f5b9895a1f314e3b40a5b/packages/java-debug-adapter/package.yaml
java_debug_version="0.58.1"
java_debug_url="https://open-vsx.org/api/vscjava/vscode-java-debug/${java_debug_version}/file/vscjava.vscode-java-debug-${java_debug_version}.vsix"
install_vsix "java-debug" "$java_debug_url"
