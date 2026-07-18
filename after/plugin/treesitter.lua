-- nvim-treesitter `main` is the Neovim 0.12 rewrite. It no longer provides
-- `nvim-treesitter.configs`; Neovim itself supplies highlighting and folding.
local treesitter = require('nvim-treesitter')

treesitter.setup({})

treesitter.install({
  'python',
  'vimdoc',
  'javascript',
  'typescript',
  'lua',
  'rust',
  'markdown',
  'markdown_inline',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'python',
    'vimdoc',
    'javascript',
    'typescript',
    'lua',
    'rust',
    'markdown',
  },
  callback = function()
    vim.treesitter.start()
  end,
})

-- Treesitter folding, enable per filetype if wanted:
-- vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
