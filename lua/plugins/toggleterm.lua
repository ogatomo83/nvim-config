return {
  "akinsho/toggleterm.nvim",
  version = "*",
  lazy = false,
  config = function()
    -- スクロール位置保存用の共有ステート（バッファ番号 → winsaveview結果）
    local saved_views = {}

    local function is_toggleterm_buf(buf)
      local name = vim.api.nvim_buf_get_name(buf)
      return name:match("#toggleterm#") ~= nil
    end

    require("toggleterm").setup({
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
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
      -- 閉じたときのモード（normal/insert）を記憶する
      persist_mode = true,
      -- 閉じる直前にビューを保存（floatが破棄されるタイミングでも捕まえる）
      on_close = function(t)
        if not (t.window and vim.api.nvim_win_is_valid(t.window)) then
          return
        end
        local mode = vim.api.nvim_get_mode().mode
        if mode == "t" then
          saved_views[t.bufnr] = nil
          return
        end
        saved_views[t.bufnr] = vim.api.nvim_win_call(t.window, vim.fn.winsaveview)
      end,
      -- 開いた直後にビューを復元（内部の startinsert より後に走らせる）
      on_open = function(t)
        local view = saved_views[t.bufnr]
        if not view then return end
        -- 30ms待ってから復元。これより短いと Neovim 側のカーソル配置に負けて復元されない
        vim.defer_fn(function()
          if not (t.window and vim.api.nvim_win_is_valid(t.window)) then
            return
          end
          vim.cmd("stopinsert")
          vim.api.nvim_win_call(t.window, function()
            vim.fn.winrestview(view)
          end)
        end, 30)
      end,
    })

    -- ファイル側ウィンドウでインサートモードだったかと、その時のカーソル位置を覚えておく（ウィンドウID単位）
    local file_win_insert_mode = {}
    local file_win_cursor = {}

    -- <C-t> でターミナルをトグル。ファイル編集中にインサートモードで開いた場合、
    -- 閉じて戻ってきたときにもインサートモードとカーソル位置を復元する。
    -- (ウィンドウを離れる際に暗黙的にインサートモードを抜けると、行末では
    --  カーソルが1つ左にずれるため、startinsert するだけでは元の位置に戻らない)
    local function toggle_terminal_preserve_insert()
      local is_terminal = vim.bo.buftype == "terminal"
      if is_terminal then
        vim.cmd("ToggleTerm")
        local win = vim.api.nvim_get_current_win()
        if file_win_insert_mode[win] then
          file_win_insert_mode[win] = nil
          local cursor = file_win_cursor[win]
          file_win_cursor[win] = nil
          -- on_open のビュー復元処理と同様、即時だと Neovim 側のモード確定に負けることがあるため defer する
          vim.defer_fn(function()
            if vim.api.nvim_win_is_valid(win) and vim.api.nvim_get_current_win() == win then
              vim.cmd("startinsert")
              if cursor then
                pcall(vim.api.nvim_win_set_cursor, win, cursor)
              end
            end
          end, 30)
        end
      else
        local win = vim.api.nvim_get_current_win()
        local is_insert = vim.api.nvim_get_mode().mode:match("^i") ~= nil
        file_win_insert_mode[win] = is_insert
        if is_insert then
          file_win_cursor[win] = vim.api.nvim_win_get_cursor(win)
        end
        vim.cmd("ToggleTerm")
      end
    end
    vim.keymap.set({ "n", "i", "t" }, "<C-t>", toggle_terminal_preserve_insert, { desc = "Toggle terminal (preserve insert mode)" })

    -- ターミナルモードで Ctrl+n で Terminal Normal モードに切り替え
    vim.keymap.set("t", "<C-n>", [[<C-\><C-n>]], { desc = "Terminal normal mode" })

    -- CursorMoved でノーマルモード中のビュー位置を継続的に保存（on_close の補助）
    vim.api.nvim_create_autocmd("CursorMoved", {
      pattern = "*",
      callback = function()
        local buf = vim.api.nvim_get_current_buf()
        if not is_toggleterm_buf(buf) then return end
        saved_views[buf] = vim.fn.winsaveview()
      end,
    })

    -- ターミナルモード(insert)に入ったらクリア（次トグルは末尾でプロンプト待ちが自然）
    vim.api.nvim_create_autocmd("TermEnter", {
      pattern = "*",
      callback = function()
        local buf = vim.api.nvim_get_current_buf()
        if not is_toggleterm_buf(buf) then return end
        saved_views[buf] = nil
      end,
    })

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
