-- gopls設定
return function(capabilities)
	vim.lsp.config.gopls = {
		cmd = { "gopls" },
		filetypes = { "go", "gomod", "gowork", "gotmpl" },
		root_markers = { "go.work", "go.mod", ".git" },
		capabilities = capabilities,
	}
	vim.lsp.enable("gopls")
end
