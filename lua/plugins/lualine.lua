return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    options = {
      theme = "auto",
      globalstatus = true,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = {
        {
          function()
            -- ホームディレクトリを~に置換して表示
            local cwd = vim.fn.getcwd()
            local home = vim.env.HOME
            if home then
              cwd = cwd:gsub("^" .. home, "~")
            end
            return cwd
          end,
          icon = "",
          color = { bg = "#50fa7b", fg = "#282a36", gui = "bold" },  -- 緑背景、黒文字
        },
      },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = { "filename" },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
  },
}
