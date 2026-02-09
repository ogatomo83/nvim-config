-- Add your plugins here
return {
  -- カラースキーム
  {
    "neanias/everforest-nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("everforest").setup({
        background = "hard",
      })
      vim.cmd("colorscheme everforest")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>p", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    },
    opts = {
      defaults = {
        file_ignore_patterns = { "node_modules", ".git/" },
      },
      pickers = {
        find_files = {
          hidden = true,
          no_ignore = false,  -- .gitignoreは尊重
          follow = true,      -- シンボリックリンクを追跡
        },
      },
    },
  },
  -- 括弧の自動補完
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,  -- treesitterと連携
    },
  },
  -- フォーマッター
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      { "<leader>f", function() require("conform").format({ async = true }) end, desc = "Format" },
    },
    opts = {
      formatters_by_ft = {
        go = { "goimports", "gofmt" },
        terraform = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
  -- コマンドラインを画面上部中央にポップアップ表示
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
      },
      views = {
        cmdline_popup = {
          position = {
            row = 5,  -- 上から5行目
            col = "50%",  -- 水平方向は中央
          },
        },
      },
      messages = {
        enabled = true,
      },
      popupmenu = {
        enabled = true,
      },
    },
  },
}
