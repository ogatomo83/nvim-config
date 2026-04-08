-- rust_analyzer設定
return function(capabilities)
	vim.lsp.config.rust_analyzer = {
		cmd = { "rust-analyzer" },
		filetypes = { "rust" },
		root_markers = { "Cargo.toml", "rust-project.json", ".git" },
		capabilities = capabilities,
		settings = {
			["rust-analyzer"] = {
				check = {
					command = "clippy",
				},
			},
		},
	}
	vim.lsp.enable("rust_analyzer")
end
