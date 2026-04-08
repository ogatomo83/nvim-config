-- kotlin_language_server設定
return function(capabilities)
	vim.lsp.config.kotlin_language_server = {
		cmd = { "kotlin-language-server" },
		filetypes = { "kotlin" },
		root_markers = { "settings.gradle", "settings.gradle.kts", "build.gradle", "build.gradle.kts", "pom.xml", ".git" },
		capabilities = capabilities,
	}
	vim.lsp.enable("kotlin_language_server")
end
