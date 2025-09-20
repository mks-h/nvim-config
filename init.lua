vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

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
			NormalFloat = { bg = colors.base },
			FloatBorder = { bg = colors.base, fg = colors.blue },
		}
	end,
})

vim.cmd.colorscheme "catppuccin"
