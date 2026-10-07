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
        leave_dirs_open = true,
      },
      bind_to_cwd = false,
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
  config = function(_, opts)
    require("neo-tree").setup(opts)

    local float_win = nil

    local function close_float()
      if float_win and vim.api.nvim_win_is_valid(float_win) then
        pcall(vim.api.nvim_win_close, float_win, true)
      end
      float_win = nil
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "neo-tree",
      callback = function(ev)
        vim.api.nvim_create_autocmd("CursorMoved", {
          buffer = ev.buf,
          callback = function()
            close_float()

            local ok, state = pcall(require("neo-tree.sources.manager").get_state_for_window)
            if not ok or not state or not state.tree then return end

            local node_ok, node = pcall(state.tree.get_node, state.tree)
            if not node_ok or not node then return end

            local name = node.name or ""
            local neo_win = vim.api.nvim_get_current_win()
            local win_width = vim.api.nvim_win_get_width(neo_win)
            local depth = node:get_depth()
            -- icon(2) + indent + name で表示幅を概算
            local used = 2 + (depth - 1) * 2 + #name

            if used <= win_width then return end

            local buf = vim.api.nvim_create_buf(false, true)
            vim.bo[buf].bufhidden = "wipe"
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, { " " .. name .. " " })

            local cursor = vim.api.nvim_win_get_cursor(neo_win)
            local win_pos = vim.api.nvim_win_get_position(neo_win)
            local avail = vim.o.columns - (win_pos[2] + win_width) - 2
            if avail < 3 then return end

            float_win = vim.api.nvim_open_win(buf, false, {
              relative = "editor",
              row = win_pos[1] + cursor[1] - 1,
              col = win_pos[2] + win_width + 1,
              width = math.min(#name + 2, avail),
              height = 1,
              style = "minimal",
              border = "rounded",
              focusable = false,
            })
          end,
        })

        vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
          buffer = ev.buf,
          callback = close_float,
        })
      end,
    })
  end,
}
