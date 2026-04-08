return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>p", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
		{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
	},
	opts = {
		defaults = {
			file_ignore_patterns = { "node_modules", ".git/" },
		},
		pickers = {
			find_files = {
				hidden = true,
				no_ignore = false, -- .gitignoreは尊重
				follow = true, -- シンボリックリンクを追跡
			},
		},
	},
}
