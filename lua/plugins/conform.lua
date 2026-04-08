-- フォーマッター
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true })
			end,
			desc = "Format",
		},
	},
	opts = {
		formatters_by_ft = {
			go = { "goimports", "gofmt" },
			java = { "google-java-format" },
			kotlin = { "ktlint" },
			rust = { "rustfmt" },
			terraform = { "terraform_fmt" },
			["terraform-vars"] = { "terraform_fmt" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
	},
}
