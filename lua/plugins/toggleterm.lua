return {
  "akinsho/toggleterm.nvim",
  version = "*",
  lazy = false,
  config = function()
    require("toggleterm").setup({
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<C-t>]],
      direction = "float",
      float_opts = {
        border = "curved",
        width = function()
          return math.floor(vim.o.columns * 0.85)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.85)
        end,
        winblend = 0,
      },
      -- TUIアプリとの互換性向上
      auto_scroll = false,
    })

    -- ターミナルモードで Ctrl+n で Terminal Normal モードに切り替え
    vim.keymap.set("t", "<C-n>", [[<C-\><C-n>]], { desc = "Terminal normal mode" })

    -- ターミナルモード内での切り替え (Ctrl+j / Ctrl+k)
    -- <C-j>: Terminal #1 (Claude Code)
    -- <C-k>: Terminal #2 (Shell)
    local function switch_term(id)
      return function()
        local terms = require("toggleterm.terminal")
        for _, t in ipairs(terms.get_all()) do
          if t:is_open() then
            t:close()
          end
        end
        vim.cmd(id .. "ToggleTerm")
        vim.schedule(function()
          vim.cmd("startinsert")
        end)
      end
    end
    vim.keymap.set("t", "<C-j>", switch_term(1), { desc = "Switch to Claude terminal" })
    vim.keymap.set("t", "<C-k>", switch_term(2), { desc = "Switch to Shell terminal" })

    -- ターミナルバッファ内のノーマルモードでも切り替えられるようにする
    -- (グローバルの <C-j>/<C-k> がウィンドウ移動にマップされていてフロート窓を閉じてしまうため、
    --  バッファローカルで上書きする)
    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "term://*toggleterm#*",
      callback = function(args)
        local opts = { buffer = args.buf }
        vim.keymap.set("n", "<C-j>", switch_term(1), vim.tbl_extend("force", opts, { desc = "Switch to Claude terminal" }))
        vim.keymap.set("n", "<C-k>", switch_term(2), vim.tbl_extend("force", opts, { desc = "Switch to Shell terminal" }))
      end,
    })
  end,
}
