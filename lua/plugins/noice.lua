-- コマンドラインを画面上部中央にポップアップ表示
return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	opts = {
		cmdline = {
			enabled = true,
			view = "cmdline_popup",
		},
		views = {
			cmdline_popup = {
				position = {
					row = 5, -- 上から5行目
					col = "50%", -- 水平方向は中央
				},
			},
		},
		messages = {
			enabled = true,
		},
		popupmenu = {
			enabled = true,
		},
	},
}
