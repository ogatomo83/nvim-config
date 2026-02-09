-- Mason + LSP設定
return {
	-- Mason: LSPサーバーの自動インストール
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "gopls" },
			})
		end,
	},
	-- LSP設定（Neovim 0.11+ 対応）
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- cmp-nvim-lspの機能をLSPに追加
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			vim.diagnostic.config({
				virtual_text = {
					prefix = "●", -- Could be '■', '▎', 'x
					spacing = 4,
				},
				signs = true,
				update_in_insert = false,
				underline = true,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			})

			-- キーマップ設定
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local opts = { buffer = args.buf }
					-- 定義ジャンプ
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					-- 型定義ジャンプ
					vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
					-- 参照一覧
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					-- 実装ジャンプ
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					-- ドキュメント表示
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					-- リネーム
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					-- コードアクション
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				end,
			})

			-- gopls設定（Neovim 0.11+ API）
			vim.lsp.config.gopls = {
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_markers = { "go.work", "go.mod", ".git" },
				capabilities = capabilities,
			}
			vim.lsp.enable("gopls")
		end,
	},
}
