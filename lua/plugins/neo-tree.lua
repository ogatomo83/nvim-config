return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-tree" },
    { "<leader>o", "<cmd>Neotree focus<cr>", desc = "Focus Neo-tree" },
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      follow_current_file = {
        enabled = true,
      },
    },
    window = {
      width = 30,
      mappings = {
        ["<space>"] = "none",
        -- hjklで移動
        ["h"] = "close_node",          -- 親ディレクトリに戻る/閉じる
        ["l"] = "open",                -- 開く
        ["<cr>"] = "open",             -- Enterでも開く
        ["gy"] = {
          function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            local relative_path = vim.fn.fnamemodify(path, ":.")
            vim.fn.setreg("+", relative_path)
            vim.notify("Copied: " .. relative_path)
          end,
          desc = "Copy relative path",
        },
      },
    },
  },
}
