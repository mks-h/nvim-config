vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.signcolumn = "yes"
vim.opt.winborder = "rounded"
vim.opt.scrolloff = 5

-- Use case-insensitive search by default
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.sessionoptions:append "globals"

vim.opt.exrc = true

vim.g.mapleader = " "
vim.g.maplocalleader = ";"

vim.g.netrw_fastbrowse = 0
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3

local map = vim.keymap.set

map(
	"n",
	"<Esc>",
	"<cmd>fclose<CR><cmd>TSContext enable<CR>",
	{ desc = "Close a floating window" }
)
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

-- map(
-- 	"n",
-- 	"<localleader>l",
-- 	vim.diagnostic.setloclist,
-- 	{ desc = "Open diagnostics locallist" }
-- )

map("n", "<localleader>d", "<cmd>bd<CR>", { desc = "Delete current buffer" })
map(
	"n",
	"<localleader>D",
	"<cmd>bd!<CR>",
	{ desc = "Forcefully delete current buffer" }
)
map("n", "<leader>d", "<cmd>%bd<CR>", { desc = "Delete all buffers" })
map(
	"n",
	"<leader>D",
	"<cmd>%bd|e#|bd#<CR>",
	{ desc = "Delete all buffers except current" }
)
map("n", "<leader>r", "<cmd>e#<CR>", { desc = "Restore last deleted buffer" })

map("n", "<localleader>w", "<cmd>w<CR>", { desc = "Save the file" })

map("n", "<localleader>q", "<cmd>q<CR>", { desc = "Quit current window" })
map(
	"n",
	"<localleader>Q",
	"<cmd>q!<CR>",
	{ desc = "Force quit current window" }
)
map("n", "<leader>q", "<cmd>qa<CR>", { desc = "Quit all windows" })
map("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Force quit all windows" })

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
		"git@github.com:scottmckendry/cyberdream.nvim.git",
		config = function ()
			require("cyberdream").setup {
				variant = "auto",
				transparent = true,
				borderless_pickers = true,
				extensions = {
					default = false,
					base = true,
					gitsigns = true,
					blinkcmp = true,
					fzflua = true,
					treesitter = true,
				},
				overrides = function (colors)
					return {
						TreesitterContext = {
							bg = colors.bg_alt,
						},
						TreesitterContextLineNumber = {
							bg = colors.bg_alt,
						},
					}
				end,
			}

			vim.cmd.colorscheme "cyberdream"
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
		tag = "*",
		config = function ()
			require("treesitter-autoinstall").setup()
		end,
	},

	{
		"git@github.com:nvim-treesitter/nvim-treesitter-context.git",
		config = function ()
			local treesitter_context = require "treesitter-context"
			treesitter_context.setup {
				max_lines = 3,
				trim_scope = "inner",
				line_numbers = vim.go.number,
			}

			map("n", "<localleader>u", function ()
				treesitter_context.go_to_context(vim.v.count1)
			end, { desc = "" })
		end,
	},

	{
		"git@github.com:aaronik/treewalker.nvim.git",
		config = function ()
			map(
				{ "n", "v" },
				"<localleader>h",
				"<cmd>Treewalker Left<cr>",
				{ desc = "Walk out of the node" }
			)
			map(
				{ "n", "v" },
				"<localleader>l",
				"<cmd>Treewalker Right<cr>",
				{ desc = "Walk into the node" }
			)
			map(
				{ "n", "v" },
				"<localleader>k",
				"<cmd>Treewalker Up<cr>",
				{ desc = "Walk to the previous node" }
			)
			map(
				{ "n", "v" },
				"<localleader>j",
				"<cmd>Treewalker Down<cr>",
				{ desc = "Walk to the next node" }
			)

			map(
				{ "n", "v" },
				"<localleader><C-h>",
				"<cmd>Treewalker SwapLeft<cr>",
				{ desc = "Walk out of the node" }
			)
			map(
				{ "n", "v" },
				"<localleader><C-l>",
				"<cmd>Treewalker SwapRight<cr>",
				{ desc = "Walk into the node" }
			)
			map(
				{ "n", "v" },
				"<localleader><C-k>",
				"<cmd>Treewalker SwapUp<cr>",
				{ desc = "Walk to the previous node" }
			)
			map(
				{ "n", "v" },
				"<localleader><C-j>",
				"<cmd>Treewalker SwapDown<cr>",
				{ desc = "Walk to the next node" }
			)
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
			end, { desc = "Format file" })
			map({ "n", "v" }, "<localleader>cw", function ()
				conform.format({
					async = true,
					lsp_format = "fallback",
				}, function ()
					vim.cmd.write()
				end)
			end, { desc = "Format & save file" })
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
					end, { desc = "Next Git hunk" })

					map("n", "]H", function ()
						if vim.wo.diff then
							vim.cmd.normal { "]c", bang = true }
						else
							gitsigns.nav_hunk("last", { target = "all" })
						end
					end, { desc = "Last Git hunk" })

					map("n", "[h", function ()
						if vim.wo.diff then
							vim.cmd.normal { "[c", bang = true }
						else
							gitsigns.nav_hunk("prev", { target = "all" })
						end
					end, { desc = "Previous Git hunk" })

					map("n", "[H", function ()
						if vim.wo.diff then
							vim.cmd.normal { "[c", bang = true }
						else
							gitsigns.nav_hunk("first", { target = "all" })
						end
					end, { desc = "First Git hunk" })

					map(
						"n",
						"<localleader>G",
						gitsigns.preview_hunk_inline,
						{ desc = "Preview Git hunk" }
					)
					map("n", "<localleader>gb", function ()
						gitsigns.blame_line { full = true }
					end, { desc = "Git blame line" })

					map(
						"n",
						"<localleader>gs",
						gitsigns.stage_hunk,
						{ desc = "Stage Git hunk" }
					)
					map("v", "<localleader>gs", function ()
						gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
					end, { desc = "Stage Git hunk" })

					map(
						"n",
						"<localleader>gr",
						gitsigns.reset_hunk,
						{ desc = "Reset Git hunk" }
					)
					map("v", "<localleader>gr", function ()
						gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
					end, { desc = "Reset Git hunk" })
				end,
			}
		end,
	},

	{ "nvim-lua/plenary.nvim" },

	{
		"git@github.com:ibhagwan/fzf-lua.git",
		config = function ()
			local fzf = require "fzf-lua"

			fzf.setup {
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
						treesitter = true,
					},
				},
				hls = {
					preview_normal = "Normal",
				},
				fzf_opts = {
					["--no-separator"] = true,
				},
			}

			fzf.register_ui_select(function (meta, items)
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
				fzf.files()
			end, { desc = "Find files in FZF" })

			map("n", "<leader>/", function ()
				fzf.live_grep()
			end, { desc = "Live grep in FZF" })

			map("n", "<leader>b", function ()
				fzf.buffers()
			end, { desc = "List buffers in FZF" })

			map("n", "<leader>g", function ()
				fzf.builtin()
			end, { desc = "FzfLua pickers" })

			map("n", "<leader>G", function ()
				fzf.resume()
			end, { desc = "Resume last picker in FZF" })
		end,
	},

	{
		"git@github.com:mfussenegger/nvim-dap.git",
		requires = { "git@github.com:jay-babu/mason-nvim-dap.nvim.git" },
		config = function ()
			require("mason-nvim-dap").setup()

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

			for _, lang in ipairs {
				"typescript",
				"typescriptreact",
				"javascript",
				"javascriptreact",
			} do
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
				dap.continue()
			end, { desc = "Continue debugging" })
			map("n", "<leader>cr", function ()
				dap.run_last()
			end, { desc = "Run the last debugging session" })
			map("n", "<leader>ct", function ()
				dap.terminate()
			end, { desc = "Run the last debugging session" })
			map("n", "<leader>cj", function ()
				dap.step_over()
			end, { desc = "Debugger: Step over" })
			map("n", "<leader>cl", function ()
				dap.step_into()
			end, { desc = "Debugger: Step into" })
			map("n", "<leader>ch", function ()
				dap.step_out()
			end, { desc = "Debugger: Step out" })
			map("n", "<localleader>b", function ()
				dap.toggle_breakpoint()
			end, { desc = "Debugger: Toggle breakpoint" })
			map("n", "<localleader>B", function ()
				dap.set_breakpoint()
			end, { desc = "Debugger: Set breakpoint" })
			map("n", "<leader>wd", function ()
				dap.repl.open()
			end, { desc = "Debugger: Open REPL window" })

			local widgets = require "dap.ui.widgets"

			map({ "n", "v" }, "<localleader>K", function ()
				widgets.hover()
			end, { desc = "Debugger: Open hover window" })
			map({ "n", "v" }, "<localleader>P", function ()
				widgets.preview()
			end, { desc = "Debugger: Open preview window" })
			map("n", "<leader>cf", function ()
				widgets.centered_float(widgets.frames)
			end, { desc = "Debugger: Open frames window" })
			map("n", "<leader>cs", function ()
				widgets.centered_float(widgets.scopes)
			end, { desc = "Debugger: Open scopes window" })
		end,
	},

	{
		"git@github.com:mrcjkb/rustaceanvim.git",
		tag = "*",
	},

	{
		"git@github.com:nvim-neotest/neotest.git",
		requires = {
			"git@github.com:nvim-neotest/nvim-nio.git",
			"git@github.com:marilari88/neotest-vitest.git",
		},
		config = function ()
			local neotest = require "neotest"
			neotest.setup {
				adapters = {
					require "rustaceanvim.neotest",
					require "neotest-vitest",
				},
				status = {
					enabled = true,
					signs = true,
				},
			}

			map("n", "<localleader>tr", function ()
				neotest.run.run()
			end, { desc = "Run the nearest test" })

			map("n", "<localleader>td", function ()
				neotest.run.run { strategy = "dap" }
			end, { desc = "Debug the nearest test" })

			map("n", "<localleader>tf", function ()
				neotest.run.run(vim.fn.expand "%")
			end, { desc = "Run the current file" })

			map("n", "<localleader>T", function ()
				neotest.output.open { short = true, enter = true }
			end, { desc = "Open the test hover window" })

			map("n", "<leader>tr", function ()
				neotest.run.run { suite = true }
			end, { desc = "Run the entire test suite" })

			map("n", "<leader>td", function ()
				neotest.run.run { suite = true, strategy = "dap" }
			end, { desc = "Debug the entire test suite" })

			map("n", "<leader><C-W><C-T>", function ()
				neotest.summary.toggle()
			end, { desc = "Toggle tests summary window" })

			map("n", "<leader><C-W>t", function ()
				neotest.summary.toggle()
			end, { desc = "Toggle tests summary window" })
		end,
	},

	{
		"git@github.com:bassamsdata/namu.nvim.git",
		config = function ()
			require("namu").setup {}

			map(
				"n",
				"<localleader>s",
				"<cmd>Namu symbols<CR>",
				{ desc = "View LSP symbols" }
			)
			map(
				"n",
				"<leader>s",
				"<cmd>Namu workspace<CR>",
				{ desc = "View LSP symbols — Workspace" }
			)
		end,
	},

	{
		"git@github.com:mfussenegger/nvim-ansible.git",
	},
}
