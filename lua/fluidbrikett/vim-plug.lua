-- plugin list
-- :so  -> to read the file and interpret it
-- :PlugInstall -> check if new Plugins are to be installed
-- :PlugClean -> check if Plugins are removed from here and should be deleted / deinstalled
local config = require("fluidbrikett.config")

local Plug = vim.fn['plug#']

local plugdir = config.path_join(vim.g.Nvimconfig, "plugged")

vim.call('plug#begin', plugdir)
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

Plug('zbirenbaum/copilot.lua')
Plug('olimorris/codecompanion.nvim')

Plug('voldikss/vim-floaterm')

-- show structure of a file?
Plug('stevearc/aerial.nvim')

-- ayu colorscheme
Plug('Shatur/neovim-ayu')


vim.call('plug#end')
