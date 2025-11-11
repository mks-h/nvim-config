vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.signcolumn = "yes"
vim.opt.winborder = "rounded"
vim.opt.scrolloff = 5

-- Use case-insensitive search by default
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.sessionoptions:append "globals"

vim.g.mapleader = " "
vim.g.maplocalleader = ";"

local map = vim.keymap.set

map("n", "<Esc>", "<cmd>fclose<CR>", { desc = "Close a floating window" })
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
map("t", "<C-Esc>", "<Esc>", { desc = "Press Esc in terminal mode" })

map(
	"n",
	[[<leader>""]],
	[[<cmd>let @+ = @"<CR>]],
	{ desc = "Move register to clipboard" }
)
map(
	"n",
	[[<leader>"0]],
	[[<cmd>let @+ = @0<CR>]],
	{ desc = "Move register to clipboard" }
)

map(
	"n",
	"<localleader>l",
	vim.diagnostic.setloclist,
	{ desc = "Open diagnostics locallist" }
)

require "bootstrap-pckr"
local event = require "pckr.loader.event"
require("pckr").add {
	{
		"git@github.com:willothy/flatten.nvim.git",
		config = function ()
			require("flatten").setup {}
		end,
	},

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
					blink_cmp = {
						style = "solid",
					},
					hop = true,
					mason = true,
					fzf = true,
				},
				highlight_overrides = {
					all = function (colors)
						return {
							StatusLine = {
								bg = colors.mantle,
								fg = colors.subtext0,
								bold = true,
							},
							FloatBorder = {
								fg = colors.green,
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
							SignColumn = {
								fg = colors.subtext0,
							},
						}
					end,
				},
			}

			vim.cmd.colorscheme "catppuccin"
		end,
	},

	{
		"git@github.com:karb94/neoscroll.nvim.git",
		config = function ()
			require("neoscroll").setup {
				duration_multiplier = 0.5,
				easing = "sine",
			}
		end,
	},

	{
		"git@github.com:NMAC427/guess-indent.nvim.git",
		config = function ()
			require("guess-indent").setup {}
		end,
	},

	{
		"git@github.com:nvim-mini/mini.sessions.git",
		config = function ()
			require("mini.sessions").setup {
				autoread = true,
				autowrite = true,
				hooks = {
					pre = {
						write = function ()
							vim.api.nvim_exec_autocmds(
								"User",
								{ pattern = "SessionSavePre" }
							)
						end,
					},
				},
			}
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
					vim.opt.formatoptions:remove "o" -- Don't comment out lines unexpectedly
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

			map({ "x", "o" }, "af", function ()
				select.select_textobject("@function.outer", "textobjects")
			end)
			map({ "x", "o" }, "if", function ()
				select.select_textobject("@function.inner", "textobjects")
			end)
			map({ "x", "o" }, "ac", function ()
				select.select_textobject("@class.outer", "textobjects")
			end)
			map({ "x", "o" }, "ic", function ()
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

	{ "git@github.com:rafamadriz/friendly-snippets.git" },

	{
		"git@github.com:Saghen/blink.cmp.git",
		tag = "*",
		config = function ()
			require("blink.cmp").setup {
				completion = {
					documentation = { auto_show = true },
					list = { selection = { auto_insert = false } },
					accept = { auto_brackets = { enabled = false } },
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
					ghost_text = { enabled = true },
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
				auto_hide = 2,
				icons = {
					filetype = { enabled = false },
					button = "×",

					pinned = { button = "—", filename = true },
				},
			}

			map("n", "]b", "<cmd>BufferNext<CR>", { desc = "Next buffer" })
			map("n", "]B", "<cmd>BufferLast<CR>", { desc = "Last buffer" })
			map(
				"n",
				"[b",
				"<cmd>BufferPrevious<CR>",
				{ desc = "Previous buffer" }
			)
			map("n", "[B", "<cmd>BufferFirst<CR>", { desc = "First buffer" })
			map(
				"n",
				"<localleader>d",
				"<cmd>BufferClose<CR>",
				{ desc = "Delete current buffer" }
			)
			map(
				"n",
				"<leader>T",
				"<cmd>BufferRestore<CR>",
				{ desc = "Restore deleted buffer" }
			)
			map(
				"n",
				"<localleader>p",
				"<cmd>BufferPin<CR>",
				{ desc = "Pin current buffer" }
			)
			map(
				"n",
				"<leader>f",
				"<cmd>BufferPick<CR>",
				{ desc = "Hop for buffer" }
			)
			map(
				"n",
				"<leader>d",
				"<cmd>BufferPickDelete<CR>",
				{ desc = "Pick buffer to delete" }
			)
			map("n", "<leader>D", "<cmd>BufferCloseAllButPinned<CR>", {
				desc = "Close all but pinned buffers",
			})
			map(
				"n",
				"<localleader>D",
				"<cmd>BufferCloseAllButCurrentOrPinned<CR>",
				{
					desc = "Close all but current or pinned buffers",
				}
			)
			map(
				"n",
				"<localleader>L",
				"<cmd>BufferMoveNext<CR>",
				{ desc = "Move buffer forward" }
			)
			map(
				"n",
				"<localleader>H",
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

			map(
				{ "n", "x" },
				"<localleader>f",
				"<cmd>HopCamelCase<CR>",
				{ desc = "Hop somewhere" }
			)
			map(
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

			map({ "n", "v" }, "<localleader>cf", function ()
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

					map("n", "]h", function ()
						if vim.wo.diff then
							vim.cmd.normal { "]c", bang = true }
						else
							gitsigns.nav_hunk("next", { target = "all" })
						end
					end)

					map("n", "]H", function ()
						if vim.wo.diff then
							vim.cmd.normal { "]c", bang = true }
						else
							gitsigns.nav_hunk("last", { target = "all" })
						end
					end)

					map("n", "[h", function ()
						if vim.wo.diff then
							vim.cmd.normal { "[c", bang = true }
						else
							gitsigns.nav_hunk("prev", { target = "all" })
						end
					end)

					map("n", "[H", function ()
						if vim.wo.diff then
							vim.cmd.normal { "[c", bang = true }
						else
							gitsigns.nav_hunk("first", { target = "all" })
						end
					end)

					map("n", "<localleader>hi", gitsigns.preview_hunk_inline)
					map("n", "<localleader>hb", function ()
						gitsigns.blame_line { full = true }
					end)

					map("n", "<localleader>hs", gitsigns.stage_hunk)
					map("v", "<localleader>hs", function ()
						gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
					end)

					map("n", "<localleader>hr", gitsigns.reset_hunk)
					map("v", "<localleader>hr", function ()
						gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
					end)
				end,
			}
		end,
	},

	{ "nvim-lua/plenary.nvim" },

	{
		"git@github.com:ibhagwan/fzf-lua.git",
		config = function ()
			require("fzf-lua").setup {
				"telescope",
				winopts = {
					fullscreen = true,
					preview = {
						layout = "vertical",
						vertical = "up:70%",
						border = "noborder",
						winopts = {
							signcolumn = vim.o.signcolumn,
						},
					},
				},
				hls = {
					preview_normal = "Normal",
				},
				fzf_opts = {
					["--no-separator"] = true,
				},
			}

			require("fzf-lua").register_ui_select(function (meta, items)
				local is_codeaction = meta.kind == "codeaction"

				local width = is_codeaction and 0.6 or 1
				local height = #items + 3

				if not is_codeaction then
					return {
						winopts = {
							fullscreen = false,
							row = 1,
							col = 0,
							width = width,
							height = height,
						},
					}
				end

				local pos = vim.api.nvim_win_get_cursor(0)

				local options = {
					fzf_opts = {},
					winopts = {
						fullscreen = false,
						title = false,
						relative = "cursor",
						row = 1,
						col = -math.floor((vim.o.columns * width) / 2),
						width = width,
						height = height,
						preview = { hidden = "hidden" },
					},
				}

				if (pos[1] + height) < vim.api.nvim_win_get_height(0) then
					options.fzf_opts["--layout"] = "reverse"
				else
					options.winopts.row = -height
				end

				return options
			end)

			map("n", "<leader>e", function ()
				FzfLua.files()
			end, { desc = "Find files" })
			map("n", "<leader>/", function ()
				FzfLua.live_grep {
					resume = true,
				}
			end, { desc = "Live grep" })
			map("n", "<leader>g", function ()
				FzfLua.builtin()
			end, { desc = "FzfLua pickers" })
		end,
	},

	{
		"git@github.com:mfussenegger/nvim-dap.git",
		config = function ()
			local dap = require "dap"
			local vscode = require "dap.ext.vscode"

			---@param type string Adapter type without the "pwa" prefix
			---@param pwaConfig dap.Adapter
			local function adapter (type, pwaConfig)
				local pwaType = "pwa-" .. type

				if not dap.adapters[pwaType] then
					dap.adapters[pwaType] = pwaConfig
				end

				if not dap.adapters[type] then
					dap.adapters[type] = function (cb, config)
						local nativeAdapter = dap.adapters[pwaType]

						config.type = pwaType

						if type(nativeAdapter) == "function" then
							nativeAdapter(cb, config)
						else
							cb(nativeAdapter)
						end
					end
				end
			end

			for _, type in ipairs { "node", "chrome" } do
				adapter(type, {
					type = "server",
					host = "localhost",
					port = "${port}",
					executable = {
						command = "js-debug-adapter",
						args = { "${port}" },
					},
				})
			end

			for _, lang in ipairs { "typescript", "typescriptreact", "javascript", "javascriptreact" } do
				dap.configurations[lang] = {
					{
						name = "Attach to Node",
						type = "pwa-node",
						request = "attach",
						port = function ()
							return tonumber(vim.fn.input {
								prompt = "Port: ",
								default = "9229",
							})
						end,
						restart = true,
						autoAttachChildProcesses = false,
						skipFiles = {
							"<node_internals>/**",
							"<workspaceFolder>/node_modules/**",
						},
					},
					{
						name = "Attach to Chrome",
						type = "pwa-chrome",
						request = "attach",
						port = function ()
							return tonumber(vim.fn.input {
								prompt = "Port: ",
								default = "9222",
							})
						end,
						restart = true,
						autoAttachChildProcesses = false,
						skipFiles = {
							"<node_internals>/**",
							"<workspaceFolder>/node_modules/**",
						},
					},
				}
			end

			---@diagnostic disable-next-line: duplicate-set-field
			vscode.json_decode = function (str)
				local plenary = require "plenary.json"
				return vim.json.decode(plenary.json_strip_comments(str))
			end

			map("n", "<leader>cc", function ()
				require("dap").continue()
			end)
			map("n", "<leader>cj", function ()
				require("dap").step_over()
			end)
			map("n", "<leader>cl", function ()
				require("dap").step_into()
			end)
			map("n", "<leader>ch", function ()
				require("dap").step_out()
			end)
			map("n", "<localleader>t", function ()
				require("dap").toggle_breakpoint()
			end)
			map("n", "<localleader>T", function ()
				require("dap").set_breakpoint()
			end)
			map("n", "<localleader>L", function ()
				require("dap").set_breakpoint(
					nil,
					nil,
					vim.fn.input "Log point message: "
				)
			end)
			map("n", "<localleader>C", function ()
				require("dap").set_breakpoint(
					vim.fn.input "Condition: ",
					nil,
					nil
				)
			end)
			map("n", "<leader>cr", function ()
				require("dap").repl.open()
			end)
			map("n", "<leader>cl", function ()
				require("dap").run_last()
			end)
			map({ "n", "v" }, "<localleader>K", function ()
				require("dap.ui.widgets").hover()
			end)
			map({ "n", "v" }, "<localleader>P", function ()
				require("dap.ui.widgets").preview()
			end)
			map("n", "<leader>cf", function ()
				local widgets = require "dap.ui.widgets"
				widgets.centered_float(widgets.frames)
			end)
			map("n", "<leader>cs", function ()
				local widgets = require "dap.ui.widgets"
				widgets.centered_float(widgets.scopes)
			end)
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
