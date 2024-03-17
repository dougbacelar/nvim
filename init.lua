----
-- Options
----
-- make sure to set mapleader before lazy.nvim so the mappings are correct
vim.g.mapleader = " "
vim.g.maplocalleader = " "

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
-- highlight current cursor line
vim.opt.cursorline = true
-- minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8

----
-- Bootstrap plugin manager
----
-- setup lazy.nvim to manage plugin dependencies
-- See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim
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
-- Key maps
----
-- open explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- window navigation
-- see `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

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
	group = vim.api.nvim_create_augroup("doug-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ timeout = 200 })
	end,
})

--  This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--    function will be executed to configure the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("doug-lsp-attach", { clear = true }),
	callback = function(event)
		-- lsp
		-- Jump to the definition of the word under your cursor.
		--  This is where a variable was first declared, or where a function is defined, etc.
		--  To jump back, press <C-T>.
		vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, { desc = "LSP: [G]oto [D]efinition" })

		-- Find references for the word under your cursor.
		vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { desc = "LSP: [G]oto [R]eferences" })

		--
		vim.keymap.set(
			"n",
			"gI",
			require("telescope.builtin").lsp_incoming_calls,
			{ desc = "LSP: [G]oto [I]ncoming Calls" }
		)

		--
		vim.keymap.set(
			"n",
			"gO",
			require("telescope.builtin").lsp_outgoing_calls,
			{ desc = "LSP: [G]oto [O]utgoing Calls" }
		)

		-- Jump to the implementation of the word under your cursor.
		--  Useful when your language has ways of declaring types without an actual implementation. Idk how this is different from lsp_incoming_calls
		vim.keymap.set(
			"n",
			"gP",
			require("telescope.builtin").lsp_implementations,
			{ desc = "LSP: [G]oto Im[P]lementation" }
		)

		-- Jump to the type of the word under your cursor.
		--  Useful when you're not sure what type a variable is and you want to see
		--  the definition of its *type*, not where it was *defined*.
		vim.keymap.set(
			"n",
			"gD",
			require("telescope.builtin").lsp_type_definitions,
			{ desc = "LSP: Type [D]efinition" }
		)

		-- Fuzzy find all the symbols in your current document.
		--  Symbols are things like variables, functions, types, etc.
		vim.keymap.set(
			"n",
			"ds",
			require("telescope.builtin").lsp_document_symbols,
			{ desc = "LSP: [D]ocument [S]ymbols" }
		)

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
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		-- Jump to the definition of the word under your cursor.
		--  This is where a variable was first declared, or where a function is defined, etc.
		--  To jump back, press <C-t>.
		map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

		-- Find references for the word under your cursor.
		map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

		-- Jump to the implementation of the word under your cursor.
		--  Useful when your language has ways of declaring types without an actual implementation.
		map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

		-- Jump to the type of the word under your cursor.
		--  Useful when you're not sure what type a variable is and you want to see
		--  the definition of its *type*, not where it was *defined*.
		map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

		-- Fuzzy find all the symbols in your current document.
		--  Symbols are things like variables, functions, types, etc.
		map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

		-- Fuzzy find all the symbols in your current workspace
		--  Similar to document symbols, except searches over your whole project.
		map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

		-- Rename the variable under your cursor
		--  Most Language Servers support renaming across files, etc.
		map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

		-- Execute a code action, usually your cursor needs to be on top of an error
		-- or a suggestion from your LSP for this to activate.
		map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

		-- Opens a popup that displays documentation about the word under your cursor
		--  See `:help K` for why this keymap
		map("K", vim.lsp.buf.hover, "Hover Documentation")

		-- WARN: This is not Goto Definition, this is Goto Declaration.
		--  For example, in C this would take you to the header
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

		-- The following two autocommands are used to highlight references of the
		-- word under your cursor when your cursor rests there for a little while.
		--    See `:help CursorHold` for information about when this is executed
		--
		-- When you move your cursor, the highlights will be cleared (the second autocommand).
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client.server_capabilities.documentHighlightProvider then
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				callback = vim.lsp.buf.clear_references,
			})
		end
	end,
})

----
-- Plugins
----
--  To check the current status of your plugins, run
--    :Lazy
--  You can press `?` in this menu for help. Use `:q` to close the window
--  To update plugins, you can run
--    :Lazy update
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
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-project.nvim" },

			{ -- If encountering errors, see telescope-fzf-native README for install instructions
				"nvim-telescope/telescope-fzf-native.nvim",

				-- `build` is used to run some command when the plugin is installed/updated.
				-- This is only run then, not every time Neovim starts up.
				build = "make",

				-- `cond` is a condition used to determine whether this plugin should be
				-- installed and loaded.
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},

			{ "nvim-telescope/telescope-ui-select.nvim" },

			-- Useful for getting pretty icons, but requires a Nerd Font.
			{ "nvim-tree/nvim-web-devicons" },
		},
		config = function()
			-- Telescope is a fuzzy finder that comes with a lot of different things that
			-- it can fuzzy find! It's more than just a "file finder", it can search
			-- many different aspects of Neovim, your workspace, LSP, and more!
			--
			-- The easiest way to use telescope, is to start by doing something like:
			--  :Telescope help_tags
			--
			-- After running this command, a window will open up and you're able to
			-- type in the prompt window. You'll see a list of help_tags options and
			-- a corresponding preview of the help.
			--
			-- Two important keymaps to use while in telescope are:
			--  - Insert mode: <c-/>
			--  - Normal mode: ?
			--
			-- This opens a window that shows you all of the keymaps for the current
			-- telescope picker. This is really useful to discover what Telescope can
			-- do as well as how to actually do it!

			-- [[ Configure Telescope ]]
			-- See `:help telescope` and `:help telescope.setup()`
			-- require("telescope").load_extension("project")
			require("telescope").setup({
				extensions = {
					-- You can put your default mappings / updates / etc. in here
					--  All the info you're looking for is in `:help telescope.setup()`
					--
					-- defaults = {
					--   mappings = {
					--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
					--   },
					-- },
					-- pickers = {}

					project = {
						base_dirs = {
							"~/dev",
							"~/.config/nvim",
							"~/.config/wezterm",
							"~/indeed",
						},
					},
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			-- Enable telescope extensions, if they are installed
			pcall(require("telescope").load_extension, "project")
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			-- See `:help telescope.builtin`
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
			vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
			vim.keymap.set("n", "<leader>fF", builtin.git_files, { desc = "[F]ind Git [F]iles" })
			vim.keymap.set("n", "<leader>fs", builtin.builtin, { desc = "[F]ind [S]elect Telescope" })
			vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" })
			vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
			vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "[F]ind [R]esume" })
			vim.keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
			vim.keymap.set(
				"n",
				"<leader>fp",
				"<cmd>lua require'telescope'.extensions.project.project{}<cr>",
				{ desc = "[F]ind [P]rojects" }
			)

			-- shortcut for searching your neovim configuration files
			vim.keymap.set("n", "<leader>fn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[F]ind [N]eovim files" })
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

			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim", opts = {} },

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
	{
		"folke/which-key.nvim",
		event = "VimEnter",
		config = function()
			require("which-key").setup()

			-- Document existing key chains
			require("which-key").register({
				["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
				["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
				["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
				["<leader>f"] = { name = "[F]ind", _ = "which_key_ignore" },
				["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
			})
		end,
	},
})

