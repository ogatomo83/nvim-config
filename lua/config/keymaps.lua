-- グローバルキーマップ

-- ウィンドウ移動
vim.keymap.set("n", "<C-j>", "<C-w>h")
vim.keymap.set("n", "<C-k>", "<C-w>l")

-- ビジュアルモードで選択行をJ/Kで移動
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- ターミナルモードからダブルEscでノーマルモードに戻る
-- (シングルEscだとClaude Code等のTUIアプリと干渉するため)
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")

-- ターミナルモードで Ctrl-L で強制再描画
vim.keymap.set("t", "<C-l>", function()
	local chan = vim.b.terminal_job_id
	if chan then
		vim.api.nvim_chan_send(chan, "\x0c") -- Ctrl-L (clear/redraw)
	end
end, { desc = "Force terminal redraw" })
