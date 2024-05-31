-- plugin list
-- :so  -> to read the file and interpret it
-- :PlugInstall -> check if new Plugins are to be installed
-- :PlugClean -> check if Plugins are removed from here and should be deleted / deinstalled

local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/AppData/Local/nvim/plugged')
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim', { tag = '0.1.5' })
Plug('nvim-treesitter/nvim-treesitter')
Plug('nvim-treesitter/playground')
Plug('tree-sitter/tree-sitter-rust')

Plug('mbbill/undotree')
Plug('tpope/vim-fugitive')

-- LSP Support
Plug('neovim/nvim-lspconfig')             -- Required
Plug('williamboman/mason.nvim')           -- Optional
Plug('williamboman/mason-lspconfig.nvim') -- Optional
-- Autocompletion
Plug('hrsh7th/nvim-cmp')     -- Required
Plug('hrsh7th/cmp-nvim-lsp') -- Required
Plug('L3MON4D3/LuaSnip')     -- Required
-- actual LSP0 wrapping everything
Plug('VonHeikemen/lsp-zero.nvim', { branch = 'v2.x'})

Plug('puremourning/vimspector')

Plug('voldikss/vim-floaterm')

-- show structure of a file?
Plug('stevearc/aerial.nvim')


-- ayu colorscheme
Plug('Shatur/neovim-ayu')

Plug('ThePrimeagen/vim-be-good')



vim.call('plug#end')
