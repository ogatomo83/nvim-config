-- 括弧の自動補完
return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	opts = {
		check_ts = true, -- treesitterと連携
	},
}
