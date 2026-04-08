local opt = vim.opt

-- 行番号を表示
opt.number = true
-- 相対行番号（現在行からの距離を表示、移動に便利）
opt.relativenumber = true

-- インデント設定
opt.expandtab = false -- Goはタブを使う
opt.tabstop = 2
opt.shiftwidth = 2
opt.autoindent = true
opt.smartindent = true

-- クリップボード連携（yankでシステムクリップボードにコピー）
opt.clipboard = "unnamedplus"

-- フォント設定（GUI Neovim用）
opt.guifont = "Hack Nerd Font:h20"
-- 行間（GUI Neovim用）
opt.linespace = 8

-- シンタックスハイライト有効化（Treesitterと併用）
vim.cmd("syntax on")
