-- let this be my central nvim config
require("fluidbrikett.remap")
require("fluidbrikett.vim-plug")
require("fluidbrikett.shortcuts")

print("hello from the nested lua")

-- path to python (python env including pynim)
vim.g.python3_host_prog = 'C:/Users/janwa/AppData/Local/Programs/Venv/pynvim/Scripts/python.exe'

-- tabs
vim.opt.expandtab = true -- insert spaces on tab
vim.opt.tabstop = 4      -- existing tab: show 4 spaces
vim.opt.softtabstop = 4  -- how many spaces the cursor moves
vim.opt.shiftwidth = 4   -- when indenting with '>', use 4 spaces

-- line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = "C:\\Users\\janwa\\AppData\\Local\\nvim\\undodir"
vim.opt.undofile = true

vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- auto change dir in net rw
vim.opt.autochdir = true


--vim.o.shell = vim.fn.executable('pwsh') -- use powershell
-- tried to set the shell, that external commands can be executed
-- this SHIT is NOT WORKING
--vim.cmd([[set shell=\"C:\Program\ Files\Git\bin\bash.exe\"]])
--vim.opt.shellcmdflag = "-c"

-- Sets the shell to use for system() and ! commands  (use powershell)
vim.opt.shell = 'pwsh.exe'
vim.opt.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command '
vim.opt.shellxquote = ''
vim.opt.shellquote = ''


-- at startup: split window
vim.cmd("vs")
vim.cmd("wincmd l") -- jump to other window
vim.cmd("Dropbox")  -- open Dropbox in it
vim.cmd("wincmd h")

