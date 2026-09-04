require("basics")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local treesitter_parsers = {
	"lua",
	"vim",
	"vimdoc",
	"query",
	"markdown",
	"markdown_inline",
	"javascript",
	"typescript",
	"tsx",
	"html",
	"css",
	"json",
	"jsonc",
	"svelte",
	"python",
	"bash",
	"fish",
	"yaml",
	"toml",
	"go",
	"rust",
}

require("lazy").setup({
	spec = {
		-- Colorscheme. Loaded first so everything else draws into it.
		{
			"navarasu/onedark.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				require("onedark").setup({
					-- dark | darker | cool | deep | warm | warmer | light
					style = "dark",
					transparent = false,
					lualine = { transparent = false },
				})
				require("onedark").load()
			end,
		},

		-- Lua utility library, pulled in by telescope and others.
		{ "nvim-lua/plenary.nvim", lazy = true },

		-- Detect and apply per-file indentation.
		{ "tpope/vim-sleuth" },

		{
			"nvim-telescope/telescope.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
			opts = {
				pickers = {
					git_branches = { previewer = false, theme = "ivy", show_remote_tracking_branches = false },
					git_commits = { previewer = false, theme = "ivy" },
					grep_string = { previewer = false, theme = "ivy" },
					diagnostics = { previewer = false, theme = "ivy" },
					find_files = { previewer = true, theme = "ivy" },
					buffers = { previewer = false, theme = "ivy" },
					current_buffer_fuzzy_find = { theme = "ivy" },
					resume = { previewer = true, theme = "ivy" },
					live_grep = { theme = "ivy" },
				},
				defaults = {
					layout_config = { prompt_position = "bottom" },
				},
			},
			keys = {
				{ "<leader>z", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "File fuzzy find" },
				{ "<leader>d", "<cmd>Telescope diagnostics<cr>", desc = "Show diagnostics" },
				{ "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git branches" },
				{ "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
				{ "<leader>w", "<cmd>Telescope grep_string<cr>", desc = "Grep string" },
				{ "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Find files" },
				{ "<leader>c", "<cmd>Telescope resume<cr>", desc = "Resume search" },
				{ "<leader>s", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
				{ "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			},
		},

		{
			"stevearc/oil.nvim",
			lazy = false,
			opts = {
				view_options = { show_hidden = true },
				default_file_explorer = true,
			},
			keys = {
				{ "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
			},
		},

		{ "kylechui/nvim-surround", event = "VeryLazy", opts = {} },

		{
			"christoomey/vim-tmux-navigator",
			lazy = false,
			keys = {
				{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
				{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
				{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
				{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			},
		},

		{
			"nvim-treesitter/nvim-treesitter",
			branch = "main",
			lazy = false,
			build = function()
				-- install() is async; lazy's build step must block on it or
				-- most parsers never finish downloading.
				require("nvim-treesitter").install(treesitter_parsers):wait(300000)
			end,
			config = function()
				vim.api.nvim_create_autocmd("FileType", {
					callback = function(ev)
						pcall(vim.treesitter.start, ev.buf)
					end,
				})
			end,
		},

		{
			"MeanderingProgrammer/render-markdown.nvim",
			ft = { "markdown" },
			opts = {
				completions = { lsp = { enabled = true } },
			},
		},

		{ "windwp/nvim-ts-autotag", event = "InsertEnter", opts = {} },

		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			opts = {
				disable_filetype = { "TelescopePrompt", "vim" },
			},
		},

		{ "folke/ts-comments.nvim", event = "VeryLazy", opts = {} },

		{
			"folke/which-key.nvim",
			event = "VeryLazy",
			opts = { preset = "helix" },
		},

		{
			"lewis6991/gitsigns.nvim",
			event = { "BufReadPre", "BufNewFile" },
			opts = {
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })

					map("n", "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })

					-- Actions
					map("n", "<leader>hs", gs.stage_hunk)
					map("n", "<leader>hr", gs.reset_hunk)
					map("v", "<leader>hs", function()
						gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end)
					map("v", "<leader>hr", function()
						gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end)
					map("n", "<leader>hS", gs.stage_buffer)
					map("n", "<leader>hu", gs.undo_stage_hunk)
					map("n", "<leader>hR", gs.reset_buffer)
					map("n", "<leader>hp", gs.preview_hunk)
					map("n", "<leader>hb", function()
						gs.blame_line({ full = true })
					end)
					map("n", "<leader>tb", gs.toggle_current_line_blame)
					map("n", "<leader>hd", gs.diffthis)
					map("n", "<leader>hD", function()
						gs.diffthis("~")
					end)
					map("n", "<leader>td", gs.toggle_deleted)

					-- Text object
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
				end,
			},
		},

		{
			"stevearc/conform.nvim",
			event = { "BufWritePre" },
			cmd = { "ConformInfo" },
			opts = {
				formatters_by_ft = {
					javascriptreact = { "prettierd" },
					typescriptreact = { "prettierd" },
					javascript = { "prettierd" },
					typescript = { "prettierd" },
					graphql = { "prettierd" },
					html = { "prettierd", "djlint" },
					json = { "prettierd" },
					jsonc = { "prettierd" },
					css = { "prettierd" },
					svelte = { "prettierd" },
					lua = { "stylua" },
					python = { "black" },
				},
				format_on_save = {},
			},
		},

		{
			"saghen/blink.cmp",
			event = "InsertEnter",
			dependencies = {
				"saghen/blink.lib",
				"rafamadriz/friendly-snippets",
			},
			opts = {
				keymap = { preset = "default" },
				appearance = { nerd_font_variant = "mono" },
				completion = { documentation = { auto_show = true } },
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
				},
				fuzzy = { implementation = "lua" },
			},
		},

		{ "williamboman/mason.nvim", cmd = "Mason", opts = {} },

		{
			"neovim/nvim-lspconfig",
			event = { "BufReadPre", "BufNewFile" },
			dependencies = {
				"williamboman/mason.nvim",
				"williamboman/mason-lspconfig.nvim",
				"saghen/blink.cmp",
			},
			config = function()
				vim.api.nvim_create_autocmd("LspAttach", {
					group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
					callback = function(event)
						local map = function(keys, func, desc)
							vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
						end

						map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
						map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
						map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
						map("<leader>.", vim.lsp.buf.code_action, "[C]ode [A]ction")
						map("<leader>i", "<cmd>TSToolsAddMissingImports<cr>", "TSToolsAddMissingImports")
					end,
				})

				local capabilities = vim.lsp.protocol.make_client_capabilities()
				capabilities = vim.tbl_deep_extend(
					"force",
					capabilities,
					require("blink.cmp").get_lsp_capabilities({}, false)
				)
				capabilities = vim.tbl_deep_extend("force", capabilities, {
					textDocument = {
						foldingRange = {
							dynamicRegistration = false,
							lineFoldingOnly = true,
						},
					},
				})

				vim.lsp.config("*", { capabilities = capabilities })

				require("mason").setup()
				require("mason-lspconfig").setup()

				require("typescript-tools").setup({
					capabilities = capabilities,
				})
			end,
		},

		{
			"pmizio/typescript-tools.nvim",
			ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
			dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		},
	},

	install = { colorscheme = { "onedark" } },
	checker = { enabled = false },
	change_detection = { notify = false },
})
