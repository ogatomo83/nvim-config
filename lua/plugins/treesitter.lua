return {
  "nvim-treesitter/nvim-treesitter",
  version = "v0.9.*",  -- 安定版を使用
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = { 'go', 'lua', 'typescript', 'javascript', 'json', 'yaml', 'html', 'css', 'bash', 'python', 'markdown', 'scala' },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true
      },
    })
  end
}
