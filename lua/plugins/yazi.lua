return {
  "mikavilpas/yazi.nvim",
  cmd = { "Yazi" },
  keys = {
    {
      "<leader>e",
      "<Cmd>Yazi<CR>",
      desc = "Open Yazi file manager",
      mode = { "n", "v" },
    },
  },
  dependencies = { "nvim-lua/plenary.nvim" },
  init = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
  config = function()
    require("yazi").setup()
  end,
}

-- 以下コマンド必要なものをインストールする
-- brew install yazi ffmpeg sevenzip jq poppler fd ripgrep fzf zoxide resvg imagemagick font-symbols-only-nerd-font