-- ターミナル関連autocmd

-- ターミナルバッファの設定
vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		local opts = { scope = "local" }
		vim.api.nvim_set_option_value("number", false, opts)
		vim.api.nvim_set_option_value("relativenumber", false, opts)
		vim.api.nvim_set_option_value("signcolumn", "no", opts)
		vim.api.nvim_set_option_value("scrolloff", 0, opts)
	end,
})

-- ターミナルバッファに戻った時に自動でターミナルモードに入る
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
	pattern = "term://*",
	callback = function()
		vim.cmd("startinsert")
	end,
})
