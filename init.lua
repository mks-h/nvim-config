vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.formatoptions:remove { "o" } -- Don't comment out lines unexpectedly

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Stop search highlighting" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Use rounded border in floats by default
local original_open_win = vim.api.nvim_open_win
vim.api.nvim_open_win = function(buf, enter, opts)
	opts = opts or {}
	if opts.border == nil then
		opts.border = "rounded"
	end
	return original_open_win(buf, enter, opts)
end

require("bootstrap-pckr")
require("pckr").add {
	"git@github.com:catppuccin/nvim.git",
	"git@github.com:NMAC427/guess-indent.nvim.git",
	{ "git@github.com:nvim-treesitter/nvim-treesitter.git", branch = "main", run = ":TSUpdate" },
	"git@github.com:mks-h/treesitter-autoinstall.nvim.git",
}

require("catppuccin").setup({
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
		},
		macchiato = {
			base = "#1c1c1f",
			mantle = "#252529",
		}
	},
	highlight_overrides = {
		all = function(colors)
			return {
				StatusLine = { bg = colors.mantle, fg = colors.subtext0, style = { "bold" } },
			}
		end,
	},
})

vim.cmd.colorscheme "catppuccin"

require("guess-indent").setup {}

require("treesitter-autoinstall").setup()
