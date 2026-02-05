require("config.options")
require("config.lazy")

vim.keymap.set('n', '<C-j>', '<C-w>h')
vim.keymap.set('n', '<C-k>', '<C-w>l')
vim.opt.autoindent = true
vim.opt.smartindent = true