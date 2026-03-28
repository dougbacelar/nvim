#!/bin/bash
set -e # exit immediately if anything returns a non-zero status

brew update

# Neovim 0.12 HEAD — install separately because --HEAD can't go in the packages array.
# TODO: replace with `brew install neovim` once 0.12 releases stable.
brew install neovim --HEAD

# list of packages to install via homebrew.
packages=(
  # window management
  asmvik/formulae/yabai           # window manager for macos
  skhd                            # shortcut daemon for macos
  # ide
  tree-sitter-cli                 # CLI for compiling tree-sitter parsers (core nvim-treesitter requirement)
  # lsps
  typescript-language-server      # aka ts_ls. LSP implementation for TypeScript wrapping tsserver.
  vscode-langservers-extracted    # collection of language servers extracted from vscode (e.g., for html)
  basedpyright                    # python LSP server forked from pyright
  lua-language-server             # language server for lua (used for lua_ls)
  jdtls                           # java language server (eclipse.jdt.ls)
  # linters and formatters
  prettierd                       # javascript's formatter, prettier as a daemon
  stylua                          # lua code formatter
  # tools
  openjdk                         # JDK 25 — runs jdtls itself (ftplugin/java.lua: java_home -v 25+)
  fzf                             # add `source <(fzf --zsh)` to .zprofile
  sqlite3                         # sqlite CLI used by snacks.picker neovim plugin
  fd                              # quicker finder required for snacks.picker to search for projects
  rg                              # quicker grep, required for snacks.picker
  go                              # install go compiler, package manager, etc
)

for item in "${packages[@]}"; do
  printf "\n\n* installing $item...\n"
  brew install "$item"
done

echo "all homebrew installations complete."

# install gopls (the official Go language server), can also do via homebrew but prefer it here
go install golang.org/x/tools/gopls@latest # don't forget to add go to PATH on .zprofile or .zshrc

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

# --- Lombok installation ---
lombok_version="1.18.44"
lombok_jar="lombok-${lombok_version}.jar"
lombok_dir="$dev_dir/lombok"
lombok_url="https://projectlombok.org/downloads/$lombok_jar"
mkdir -p "$lombok_dir"
echo "downloading lombok from ${lombok_url}..."
curl -L -o "$lombok_dir/$lombok_jar" $lombok_url
