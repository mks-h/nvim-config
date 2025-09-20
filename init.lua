vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

require("bootstrap-pckr")
require("pckr").add {
	"git@github.com:catppuccin/nvim.git"
}

require("catppuccin").setup({
	flavor = "macchiato",
	transparent_background = true,
	show_end_of_buffer = true,
	color_overrides = {
		all = {
			base = "#252529",
		},
	},
	custom_highlights = function(colors)
		return {
			StatusLine = { bg = colors.base, fg = colors.subtext0 },
			NormalFloat = { bg = colors.base }
		}
	end,
})

vim.cmd.colorscheme "catppuccin"
