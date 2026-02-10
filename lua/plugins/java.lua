-- nvim-jdtls: Java LSP設定
return {
	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" },
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
			local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
			local workspace_dir = vim.env.HOME .. "/.local/share/nvim/jdtls-workspace/" .. project_name

			-- Masonでjdtlsが未インストールならインストール
			local mason_registry = require("mason-registry")
			if not mason_registry.is_installed("jdtls") then
				mason_registry.get_package("jdtls"):install()
			end

			local config = {
				cmd = {
					jdtls_path .. "/bin/jdtls",
					"-data", workspace_dir,
				},
				root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts" }),
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			}

			require("jdtls").start_or_attach(config)
		end,
	},
}
