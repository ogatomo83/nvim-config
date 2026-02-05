local opt = vim.opt

-- 行番号を表示
opt.number = true
-- 相対行番号（現在行からの距離を表示、移動に便利）
opt.relativenumber = true

-- インデント設定
opt.expandtab = false   -- Goはタブを使う
opt.tabstop = 4
opt.shiftwidth = 4
opt.autoindent = true
opt.smartindent = true

-- シンタックスハイライト有効化（Treesitterと併用）
vim.cmd("syntax on")
