-- plugin list
-- :so  -> to read the file and interpret it
-- :PlugInstall -> check if new Plugins are to be installed
-- :PlugClean -> check if Plugins are removed from here and should be deleted / deinstalled
local config = require("fluidbrikett.config")

local Plug = vim.fn['plug#']

local plugdir = config.path_join(vim.g.Nvimconfig, "plugged")

vim.call('plug#begin', plugdir)
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim', { tag = 'v0.1.9' })
-- `master` is the legacy implementation for Neovim 0.11. Neovim 0.12 needs
-- the rewritten plugin on `main`.
Plug('nvim-treesitter/nvim-treesitter', { branch = 'main', ['do'] = ':TSUpdate' })

Plug('mbbill/undotree')
Plug('tpope/vim-fugitive')

-- LSP Support
Plug('neovim/nvim-lspconfig')             -- Required
Plug('williamboman/mason.nvim')           -- Optional
Plug('williamboman/mason-lspconfig.nvim') -- Optional
-- Autocompletion
Plug('hrsh7th/nvim-cmp')     -- Required
Plug('hrsh7th/cmp-nvim-lsp') -- Required

Plug('zbirenbaum/copilot.lua')
Plug('olimorris/codecompanion.nvim')

Plug('voldikss/vim-floaterm')

-- show structure of a file
Plug('stevearc/aerial.nvim')

-- Markdown presenter
Plug('MeanderingProgrammer/render-markdown.nvim')

-- ayu colorscheme
Plug('Shatur/neovim-ayu')


vim.call('plug#end')
