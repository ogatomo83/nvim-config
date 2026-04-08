-- terraformls設定
return function(capabilities)
	vim.lsp.config.terraformls = {
		cmd = { "terraform-ls", "serve" },
		filetypes = { "terraform", "terraform-vars" },
		root_markers = { ".terraform", ".git" },
		capabilities = capabilities,
	}
	vim.lsp.enable("terraformls")
end
