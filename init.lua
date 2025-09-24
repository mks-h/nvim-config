vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.formatoptions:remove { "o" } -- Don't comment out lines unexpectedly
vim.opt.signcolumn = "yes"
vim.opt.winborder = "rounded"
vim.opt.scrolloff = 5

vim.g.mapleader = " "
vim.g.maplocalleader = ";"

vim.keymap.set(
	"t",
	"<Esc><Esc>",
	"<C-\\><C-n>",
	{ desc = "Exit terminal mode" }
)

require "bootstrap-pckr"
local event = require "pckr.loader.event"
require("pckr").add {
	{
		"git@github.com:catppuccin/nvim.git",
		config = function ()
			require("catppuccin").setup {
				flavour = "auto",
				background = {
					ligth = "latte",
					dark = "macchiato",
				},
				transparent_background = true,
				show_end_of_buffer = true,
				color_overrides = {
					latte = {
						base = "#ffffff",
						mantle = "#f5f5f5",
						surface0 = "#ebebeb",
						surface1 = "#e0e0e0",
						surface2 = "#d6d6d6",
					},
					macchiato = {
						base = "#1c1c1f",
						mantle = "#252529",
						surface0 = "#2e2e32",
						surface1 = "#434346",
						surface2 = "#38383b",
					},
				},
				integrations = {
					barbar = true,
					gitsigns = {
						enabled = true,
						transparent = false,
					},
				},
				highlight_overrides = {
					all = function (colors)
						return {
							StatusLine = {
								bg = colors.mantle,
								fg = colors.subtext0,
								bold = true,
							},
							BlinkCmpMenu = { bg = colors.mantle },
							BufferCurrent = { bg = colors.mantle, bold = true },
							BufferCurrentSign = {
								bg = colors.mantle,
								fg = colors.peach,
							},
							BufferInactiveSign = { fg = colors.mantle },
							BufferCurrentMod = {
								bg = colors.mantle,
								fg = colors.peach,
							},
							BufferCurrentModBtn = {
								bg = colors.mantle,
								fg = colors.peach,
							},
							TreesitterContextLineNumber = {
								bg = colors.mantle,
								fg = colors.surface1,
							},
							TreesitterContextSeparator = {
								underline = true,
								sp = colors.green,
								bg = colors.mantle,
								fg = colors.surface1,
							},
						}
					end,
				},
			}

			vim.cmd.colorscheme "catppuccin"
		end,
	},

	{
		"git@github.com:NMAC427/guess-indent.nvim.git",
		config = function ()
			require("guess-indent").setup {}
		end,
	},

	{
		"git@github.com:nvim-treesitter/nvim-treesitter.git",
		branch = "main",
		run = ":TSUpdate",
		config = function ()
			require("nvim-treesitter").install { "lua", "vim", "vimdoc" }

			vim.api.nvim_create_autocmd("FileType", {
				callback = function ()
					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.wo.foldmethod = "expr"
					vim.wo.foldtext = ""
					vim.wo.foldlevel = 99
					vim.bo.indentexpr =
						"v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},

	{
		"git@github.com:mks-h/treesitter-autoinstall.nvim.git",
		config = function ()
			require("treesitter-autoinstall").setup()
		end,
	},

	{
		"git@github.com:nvim-treesitter/nvim-treesitter-context.git",
		config = function ()
			require("treesitter-context").setup {
				max_lines = 3,
				trim_scope = "inner",
				separator = "~",
			}
		end,
	},

	{
		"git@github.com:nvim-treesitter/nvim-treesitter-textobjects.git",
		branch = "main",
		config = function ()
			require("nvim-treesitter-textobjects").setup {}
			local select = require "nvim-treesitter-textobjects.select"

			vim.keymap.set({ "x", "o" }, "af", function ()
				select.select_textobject("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "if", function ()
				select.select_textobject("@function.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ac", function ()
				select.select_textobject("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ic", function ()
				select.select_textobject("@class.inner", "textobjects")
			end)
		end,
	},

	{ "git@github.com:neovim/nvim-lspconfig.git" },

	{
		"git@github.com:mason-org/mason.nvim.git",
		config = function ()
			require("mason").setup {}
		end,
	},

	{
		"git@github.com:Saghen/blink.cmp.git",
		tag = "*",
		config = function ()
			require("blink.cmp").setup {
				completion = {
					documentation = { auto_show = true },
					menu = {
						auto_show = false,
						draw = {
							treesitter = { "lsp" },
							columns = {
								{ "label", "label_description", gap = 1 },
								{ "kind" },
							},
						},
					},
				},
			}
		end,
	},

	{
		"git@github.com:mason-org/mason-lspconfig.nvim.git",
		config = function ()
			require("mason-lspconfig").setup {
				ensure_installed = { "lua_ls", "vimls" },
				handlers = {
					function (server_name)
						local lspconfig = require "lspconfig"
						local blink = require "blink.cmp"

						local server = lspconfig.servers[server_name] or {}
						server.capabilities = blink.get_lsp_capabilities()
						lspconfig[server_name].setup(server)
					end,
				},
			}
		end,
	},

	{
		"git@github.com:folke/lazydev.nvim.git",
		---@diagnostic disable-next-line: param-type-mismatch
		cond = event("FileType", "lua"),
		config = function ()
			require("lazydev").setup {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			}
		end,
	},

	{
		"git@github.com:romgrk/barbar.nvim.git",
		config = function ()
			require("barbar").setup {
				auto_hide = 1,
				icons = {
					filetype = { enabled = false },
					button = "×",

					pinned = { button = "—", filename = true },
				},
			}

			vim.keymap.set(
				"n",
				"]b",
				"<cmd>BufferNext<CR>",
				{ desc = "Next buffer" }
			)
			vim.keymap.set(
				"n",
				"]B",
				"<cmd>BufferFirst<CR>",
				{ desc = "First buffer" }
			)
			vim.keymap.set(
				"n",
				"[b",
				"<cmd>BufferPrevious<CR>",
				{ desc = "Previous buffer" }
			)
			vim.keymap.set(
				"n",
				"[B",
				"<cmd>BufferLast<CR>",
				{ desc = "Last buffer" }
			)
			vim.keymap.set(
				"n",
				"<localleader>bd",
				"<cmd>BufferClose<CR>",
				{ desc = "Delete current buffer" }
			)
			vim.keymap.set(
				"n",
				"<leader>T",
				"<cmd>BufferRestore<CR>",
				{ desc = "Restore deleted buffer" }
			)
			vim.keymap.set(
				"n",
				"<localleader>bp",
				"<cmd>BufferPin<CR>",
				{ desc = "Pin current buffer" }
			)
			vim.keymap.set(
				"n",
				"<leader>f",
				"<cmd>BufferPick<CR>",
				{ desc = "Hop for buffer" }
			)
			vim.keymap.set(
				"n",
				"<leader>bd",
				"<cmd>BufferPickDelete<CR>",
				{ desc = "Pick buffer to delete" }
			)
			vim.keymap.set(
				"n",
				"<leader>bad",
				"<cmd>BufferCloseAllButPinned<CR>",
				{
					desc = "Close all but pinned buffers",
				}
			)
			vim.keymap.set(
				"n",
				"<leader>bod",
				"<cmd>BufferCloseAllButCurrentOrPinned<CR>",
				{
					desc = "Close all but current or pinned buffers",
				}
			)
			vim.keymap.set(
				"n",
				"<localleader>bl",
				"<cmd>BufferMoveNext<CR>",
				{ desc = "Move buffer forward" }
			)
			vim.keymap.set(
				"n",
				"<localleader>bh",
				"<cmd>BufferMovePrevious<CR>",
				{ desc = "Move buffer backward" }
			)
		end,
	},

	{
		"git@github.com:smoka7/hop.nvim.git",
		tag = "*",
		config = function ()
			local hop = require "hop"
			hop.setup()

			vim.keymap.set(
				{ "n", "x" },
				"<localleader>f",
				"<cmd>HopCamelCase<CR>",
				{ desc = "Hop somewhere" }
			)
			vim.keymap.set(
				{ "n", "x" },
				"<localleader>/",
				"<cmd>HopPattern<CR>",
				{ desc = "Hop somewhere by pattern" }
			)
		end,
	},

	{
		"git@github.com:stevearc/conform.nvim.git",
		config = function ()
			local conform = require "conform"

			conform.setup {
				formatters_by_ft = {
					lua = { "stylua" },
				},
			}

			vim.keymap.set("n", "<localleader>cf", function ()
				conform.format { async = true, lsp_format = "fallback" }
			end)
		end,
	},

	{
		"git@github.com:lewis6991/gitsigns.nvim.git",
		config = function ()
			require("gitsigns").setup {
				on_attach = function (bufnr)
					local gitsigns = require "gitsigns"

					vim.keymap.set("n", "]c", function ()
						if vim.wo.diff then
							vim.cmd.normal { "]c", bang = true }
						else
							gitsigns.nav_hunk "next"
						end
					end)

					vim.keymap.set("n", "[c", function ()
						if vim.wo.diff then
							vim.cmd.normal { "[c", bang = true }
						else
							gitsigns.nav_hunk "prev"
						end
					end)

					vim.keymap.set(
						"n",
						"<localleader>hi",
						gitsigns.preview_hunk_inline
					)
					vim.keymap.set("n", "<localleader>hb", function ()
						gitsigns.blame_line { full = true }
					end)

					vim.keymap.set("n", "<localleader>hs", gitsigns.stage_hunk)
					vim.keymap.set("v", "<localleader>hs", function ()
						gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
					end)

					vim.keymap.set("n", "<localleader>hr", gitsigns.reset_hunk)
					vim.keymap.set("v", "<localleader>hr", function ()
						gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
					end)
				end,
			}
		end,
	},
}

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				disable = { "missing-fields" },
			},
		},
	},
})
