# Neovim 0.12 Migration TODO

## Required

- [x] **Audit nvim-jdtls for breaking changes** — no breaking changes for Neovim 0.12. All APIs
      used (`start_or_attach`, `setup_dap`, `setup_dap_main_class_configs`) are stable. See
      sub-items below for the actual work identified.

- [ ] **Remove java-debug and java-test from `ftplugin/java.lua`** — these are not used anymore.
      Remove the `bundles` table (lines 7–12), the `nvim-dap` setup in `on_attach`, and the
      `nvim-dap`, `nvim-dap-ui`, `nvim-dap-virtual-text`, and `nvim-jdtls` DAP-related plugins.
      Also remove `lua/plugins/dap-ui.lua` and its keymaps.

- [ ] **Fix `extendedClientCapabilities` placement** (`ftplugin/java.lua`) — currently inside
      `config.settings` (silently ignored by the server); move it to `config.init_options`. The
      plugin auto-fills the default so nothing is broken, but the placement is wrong.

- [ ] **Update lombok to 1.18.44** — `~/dev/lombok` does not exist on disk; needs installing.
      Three releases behind (1.18.38 → 1.18.44). **Breaking change in 1.18.40**: Jackson
      annotation auto-copying (`@JsonProperty` etc.) is now disabled by default. Check each
      project's `lombok.config` and add `lombok.copyJacksonAnnotationsToAccessors = true` if
      needed before upgrading.

- [ ] **Upgrade jdtls via Homebrew** — installed `1.46.1`, latest stable is `1.57.0` (11 versions
      behind). Run `brew upgrade jdtls`. The launcher jar is now detected dynamically so no
      config changes are needed after upgrading.

- [ ] **Update `nvim-treesitter-textobjects` after upgrading** — the plugin does not use the
      removed `all = true` option in `iter_matches()`, so that specific breaking change is a
      non-issue. However, it currently bundles a private copy of `vim.treesitter._range`
      (internal API, see `_range.lua`) with a TODO to replace it with the public `vim.Range`
      once 0.11 support is dropped. Run `:Lazy sync` after upgrading to get the updated version,
      then run `:checkhealth nvim-treesitter` to confirm text object queries still work.

- [ ] **Run `:Lazy sync`** after upgrading Neovim to pull 0.12-compatible plugin versions.

- [ ] **Run `:checkhealth`** after upgrading and fix any reported issues.

## Should Do (cleanup / future-proofing)

- [ ] **Drop `nvim-lspconfig` as a dependency** — the config already uses `vim.lsp.config()` +
      `vim.lsp.enable()` with server files in `lsp/`. The only remaining value from lspconfig is
      the server command definitions (paths, default args). These can be replicated in the `lsp/`
      files or sourced from the bundled configs in 0.12. Removing lspconfig simplifies the setup.

- [ ] **Add `lsp/` configs for remaining servers** — only `basedpyright` has a file in `lsp/`.
      Create minimal files for `gopls`, `html`, `lua_ls`, `sourcekit`, and `ts_ls` so their
      configs are explicit and lspconfig can be dropped cleanly.

## Optional (nice to have)

- [ ] **Evaluate native LSP completion** (`vim.lsp.completion.enable()`) as a replacement for
      `nvim-cmp` — the current cmp setup is minimal (two sources: lsp + path), so this would be
      a clean swap and removes two plugins (`nvim-cmp`, `cmp-nvim-lsp`, `cmp-path`).

- [ ] **Evaluate `vim.pack`** — the new built-in plugin manager. `lazy.nvim` continues to work
      and there is no pressure to switch, but worth evaluating for a simpler setup long-term.
