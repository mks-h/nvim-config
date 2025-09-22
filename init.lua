vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.formatoptions:remove { "o" } -- Don't comment out lines unexpectedly
vim.opt.signcolumn = "yes"

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Use rounded border in floats by default
local original_open_win = vim.api.nvim_open_win
---@diagnostic disable-next-line: duplicate-set-field
vim.api.nvim_open_win = function(buf, enter, opts)
	opts = opts or {}
	if opts.border == nil then
		opts.border = "rounded"
	end
	return original_open_win(buf, enter, opts)
end

require("bootstrap-pckr")
local event = require("pckr.loader.event")
require("pckr").add {
	{ "git@github.com:catppuccin/nvim.git", config = function()
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
				},
				macchiato = {
					base = "#1c1c1f",
					mantle = "#252529",
					surface0 = "#2e2e32",
					surface1 = "#434346",
				}
			},
			highlight_overrides = {
				all = function(colors)
					return {
						StatusLine = { bg = colors.mantle, fg = colors.subtext0, style = { "bold" } },
						BlinkCmpMenu = { bg = colors.mantle },
					}
				end,
			},
		}

		vim.cmd.colorscheme "catppuccin"
	end },

	{ "git@github.com:NMAC427/guess-indent.nvim.git", config = function()
		require("guess-indent").setup {}
	end },

	{ "git@github.com:nvim-treesitter/nvim-treesitter.git", branch = "main", run = ":TSUpdate", config = function()
		require("nvim-treesitter").install { "lua", "vim", "vimdoc" }
	end},

	{ "git@github.com:mks-h/treesitter-autoinstall.nvim.git", config = function()
		require("treesitter-autoinstall").setup()
	end},

	{ "git@github.com:neovim/nvim-lspconfig.git" },

	{ "git@github.com:mason-org/mason.nvim.git", config = function()
		require("mason").setup {}
	end },

	{ "git@github.com:Saghen/blink.cmp.git", tag = "*", config = function()
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
	end },

	{ "git@github.com:mason-org/mason-lspconfig.nvim.git", config = function()
		require("mason-lspconfig").setup {
			ensure_installed = { "lua_ls", "vimls" },
			handlers = {
				function(server_name)
					local lspconfig = require("lspconfig")
					local blink = require("blink.cmp")

					local server = lspconfig.servers[server_name] or {}
					server.capabilities = blink.get_lsp_capabilities()
					lspconfig[server_name].setup(server)
				end
			}
		}
	end },

	{ "git@github.com:folke/lazydev.nvim.git",
		---@diagnostic disable-next-line: param-type-mismatch
		cond = event("FileType", "lua"),
		config = function()
			require("lazydev").setup {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			}
		end
	},
}

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				disable = { "missing-fields" }
			}
		}
	}
})
