-- LSP related plugins
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
  -- 補完プラグイン
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
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
