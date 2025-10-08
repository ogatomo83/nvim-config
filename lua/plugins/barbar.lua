return {
  "romgrk/barbar.nvim",
  version = "^1.0.0",
  dependencies = {
    "lewis6991/gitsigns.nvim",         -- Gitステータス表示（任意）
    "nvim-tree/nvim-web-devicons",     -- ファイルアイコン（任意）
  },
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  opts = {
    animation = true,            -- タブ切り替え時のアニメーション
    auto_hide = false,           -- 1つしかバッファがない時もバーを表示
    insert_at_end = true,        -- 新しいバッファを末尾に追加
    icons = {
      buffer_index = true,       -- バッファ番号表示
      diagnostics = {
        [vim.diagnostic.severity.ERROR] = { enabled = true, icon = " " },
        [vim.diagnostic.severity.WARN]  = { enabled = true, icon = " " },
        [vim.diagnostic.severity.INFO]  = { enabled = true, icon = " " },
      },
    },
  },
  config = function(_, opts)
    require("barbar").setup(opts)

    vim.keymap.set("n", "<leader>bn", "<Cmd>BufferNext<CR>", { desc = "Next buffer" })
    vim.keymap.set("n", "<leader>bp", "<Cmd>BufferPrevious<CR>", { desc = "Previous buffer" })
    vim.keymap.set("n", "<leader>bd", "<Cmd>BufferClose<CR>", { desc = "Close buffer" })
    vim.keymap.set("n", "<leader>bb", "<Cmd>BufferPick<CR>", { desc = "Pick buffer" })

    vim.keymap.set("n", "<Tab>", "<Cmd>BufferNext<CR>", { desc = "Next buffer" })
    vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferPrevious<CR>", { desc = "Previous buffer" })
  end,
}