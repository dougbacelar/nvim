----
-- Options
----
-- make sure to set mapleader before lazy.nvim so the mappings are correct
vim.g.mapleader = " "
-- decrease update time, I think default is 4 seconds. should make plugins respond quicker if they wait for update events
vim.o.updatetime = 250
-- decrease timeout for keybinds, should make shortcuts snappier but potentially harder to press. (also affects which-key plugin)
vim.o.timeoutlen = 300
-- save undo history on disk even after closing file.
vim.o.undofile = true
-- remove line numbers by default. Use :set number to manually turn it on and :set nonumber to manually turn it back off
vim.opt.number = false
-- tells nvim to use the "+" register. This will share the clipboard between nvim/MacOS
vim.opt.clipboard = "unnamedplus"
-- indents wrapped lines so they are easier to read
vim.opt.breakindent = true
-- makes search case-insensitive when all letters are lower case. If at least a single letter is upper case, the search will become case-sensitive
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- sets how neovim will display tabs, trailling spaces and non-breaking spaces in the editor. This helps identify wrong whitespaces inserted accidentally in a file
--  See :help 'list'
--  and :help 'listchars'
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
-- minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8
-- highlight current cursor line
vim.opt.cursorline = true

----
-- Bootstrap plugin manager
----
-- setup lazy.nvim to manage plugin dependencies https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

----
-- Auto Commands
----
-- setup auto save
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
	callback = function(args)
		if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
			-- only way to get format working with auto save is having it in the same autocmd, consider removing it later
			require("conform").format({
				bufnr = args.buf,
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			})
			-- write the file (:w)
			vim.api.nvim_command("silent update")
		end
	end,
})

-- highlight when yanking (copying) text. Adjust `timeout` to change duration of highlight
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ timeout = 200 })
	end,
})

----
-- Plugins
----
require("lazy").setup({
	-- the color theme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				transparent_background = true, -- disables setting the background color.
			})
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},

	-- AST, syntax highlighting and stuff
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				-- A list of parser names, or "all" (the five listed parsers should always be installed)
				ensure_installed = {
					"c",
					"lua",
					"vim",
					"vimdoc",
					"query",
					"javascript",
					"typescript",
					"java",
					"kotlin",
				},

				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,
				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
				auto_install = true,
				---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
				-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
				highlight = {
					enable = true,
					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},

	-- fuzzy finding files and stuff
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.4",
		dependencies = { "nvim-lua/plenary.nvim", { "nvim-telescope/telescope-project.nvim" } },
		config = function()
			require("telescope").load_extension("project")
			require("telescope").setup({
				extensions = {
					project = {
						base_dirs = {
							"~/dev",
							"~/.config/nvim",
							"~/.config/wezterm",
							"~/indeed",
						},
					},
				},
			})
		end,
	},

	-- language server protocol stuff
	{
		"VonHeikemen/lsp-zero.nvim",
		dependencies = {
			--- use mason to manage LSP servers from neovim
			-- type :Mason to see everything currently installed
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- LSP Support
			-- type :LspInstall in a file to install lsp for that file type
			{ "neovim/nvim-lspconfig" },
			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "L3MON4D3/LuaSnip" },
		},
		config = function()
			local lsp_zero = require("lsp-zero")

			lsp_zero.on_attach(function(client, bufnr)
				-- see :help lsp-zero-keybindings
				-- to learn the available actions
				lsp_zero.default_keymaps({ buffer = bufnr })
			end)
			require("mason").setup({})
			require("mason-lspconfig").setup({
				-- Replace the language servers listed here
				-- with the ones you want to install
				ensure_installed = { "lua_ls", "tsserver" },
				handlers = {
					lsp_zero.default_setup,
					lua_ls = function()
						-- https://www.reddit.com/r/neovim/comments/114wlhj/comment/j90sfbw
						-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/neovim-lua-ls.md#fixed-config
						local lua_opts = lsp_zero.nvim_lua_ls()
						require("lspconfig").lua_ls.setup(lua_opts)
					end,
				},
			})
		end,
	},

	-- setup lsp formatters
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")
			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					-- conform will run multiple formatters sequentially
					python = { "isort", "black" },
					-- use a sub-list to run only the first available formatter
					javascript = { { "prettierd", "prettier" } },
					typescript = { { "prettierd", "prettier" } },
					javascriptreact = { { "prettierd", "prettier" } },
					typescriptreact = { { "prettierd", "prettier" } },
					css = { { "prettierd", "prettier" } },
					html = { { "prettierd", "prettier" } },
					json = { { "prettierd", "prettier" } },
					yaml = { { "prettierd", "prettier" } },
					markdown = { { "prettierd", "prettier" } },
					graphql = { { "prettierd", "prettier" } },
				},
				-- format on save is not working due to auto save, moved format code to auto-save autocmd
				-- fomart_on_save = { lsp_fallback = true, async = false, timeout_ms = 500 },
			})

			-- keep this keymap as a fallback for now just in case the autocmd doesn't work
			vim.keymap.set({ "n", "v" }, "<leader>mp", function()
				conform.format({ async = false })
			end, { desc = "[M]ake [P]rettier" })
		end,
	},

	-- detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",

	-- git ui. type :G to open. or :help fugitive for docs
	"tpope/vim-fugitive",

	{
		-- adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				vim.keymap.set(
					"n",
					"<leader>hp",
					require("gitsigns").preview_hunk,
					{ buffer = bufnr, desc = "Preview git hunk" }
				)
				-- don't override the built-in and fugitive keymaps
				local gs = package.loaded.gitsigns
				vim.keymap.set({ "n", "v" }, "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
				vim.keymap.set({ "n", "v" }, "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
			end,
		},
	},

	-- setup auto-workspace and restore cursor on file open
	{
		"echasnovski/mini.misc",
		config = function()
			require("mini.misc").setup()
			-- sets the workspace when you open a project file so telescope works better
			MiniMisc.setup_auto_root()

			-- restore the cursor upon reopening file!
			MiniMisc.setup_restore_cursor()
		end,
	},

	-- setup commenting from normal mode with 'gcc'
	{ "echasnovski/mini.comment", config = true },

	-- useful plugin to show you pending keybinds.
	{ "folke/which-key.nvim", opts = {} },
})

----
-- Key maps
----
-- open explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- telescope
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").git_files, { desc = "[F]ind [G]it Files" })
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "[F]ind [F]iles" })
vim.keymap.set(
	"n",
	"<leader>fp",
	"<cmd>lua require'telescope'.extensions.project.project{}<cr>",
	{ desc = "[F]ind [P]rojects" }
)

-- lsp
-- Jump to the definition of the word under your cursor.
--  This is where a variable was first declared, or where a function is defined, etc.
--  To jump back, press <C-T>.
vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, { desc = "LSP: [G]oto [D]efinition" })

-- Find references for the word under your cursor.
vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { desc = "LSP: [G]oto [R]eferences" })

--
vim.keymap.set("n", "gI", require("telescope.builtin").lsp_incoming_calls, { desc = "LSP: [G]oto [I]ncoming Calls" })

--
vim.keymap.set("n", "gO", require("telescope.builtin").lsp_outgoing_calls, { desc = "LSP: [G]oto [O]utgoing Calls" })

-- Jump to the implementation of the word under your cursor.
--  Useful when your language has ways of declaring types without an actual implementation. Idk how this is different from lsp_incoming_calls
vim.keymap.set("n", "gP", require("telescope.builtin").lsp_implementations, { desc = "LSP: [G]oto Im[P]lementation" })

-- Jump to the type of the word under your cursor.
--  Useful when you're not sure what type a variable is and you want to see
--  the definition of its *type*, not where it was *defined*.
vim.keymap.set("n", "gD", require("telescope.builtin").lsp_type_definitions, { desc = "LSP: Type [D]efinition" })

-- Fuzzy find all the symbols in your current document.
--  Symbols are things like variables, functions, types, etc.
vim.keymap.set("n", "ds", require("telescope.builtin").lsp_document_symbols, { desc = "LSP: [D]ocument [S]ymbols" })

-- Fuzzy find all the symbols in your current workspace
--  Similar to document symbols, except searches over your whole project.
vim.keymap.set(
	"n",
	"<leader>ws",
	require("telescope.builtin").lsp_dynamic_workspace_symbols,
	{ desc = "LSP: [W]orkspace [S]ymbols" }
)

-- Rename the variable under your cursor
--  Most Language Servers support renaming across files, etc.
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP: [R]e[n]ame" })

-- Execute a code action, usually your cursor needs to be on top of an error
-- or a suggestion from your LSP for this to activate.
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: [C]ode [A]ction" })

-- Opens a popup that displays documentation about the word under your cursor
--  See `:help K` for why this keymap
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP: Hover Documentation" })

-- todo
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[F]ind by live [G]rep" })
vim.keymap.set("n", "<leader>fw", require("telescope.builtin").grep_string, { desc = "[F]ind current [W]ord" })
-- vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
-- vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
-- vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
-- vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
-- vim.keymap.set('n', '<leader>fs', builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "[F]ind Buffers" })
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
--
