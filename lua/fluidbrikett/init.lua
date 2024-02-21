-- let this be my central nvim config
require("fluidbrikett.remap")
require("fluidbrikett.vim-plug")
require("fluidbrikett.shortcuts")

print("hello from the nested lua")

-- path to python (python env including pynim)
vim.g.python3_host_prog = vim.g.homedir .. '\\AppData\\Local\\Programs\\Venv\\pynvim\\Scripts\\python.exe'

vim.opt.encoding="utf-8"

-- tabs
vim.opt.expandtab = true -- insert spaces on tab
vim.opt.tabstop = 4      -- existing tab: show 4 spaces
vim.opt.softtabstop = 4  -- how many spaces the cursor moves
vim.opt.shiftwidth = 4   -- when indenting with '>', use 4 spaces
-- show tabs as greyed out ">~"
vim.opt.listchars =  { tab = '>~' }
vim.opt.list = true

-- line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.g.homedir .. "\\AppData\\Local\\nvim\\undodir"
vim.opt.undofile = true

vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.timeoutlen = 500

vim.opt.guicursor = "n-v-sm:block,i-c-ci-cr-ve:ver20,r-o:hor50"

-- auto change dir in net rw
vim.opt.autochdir = true

-- fix that floaterm opens new instances at toggle
vim.opt.hidden = true

-- Sets the shell to use for system() and ! commands  (use powershell)
vim.opt.shell = 'powershell.exe'
vim.opt.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command '
-- vim.opt.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned '
-- vim.opt.shellcmdflag = '-NoLogo -NoProfile '
vim.opt.shellxquote = ''
vim.opt.shellquote = ''
vim.o.shellpipe = '| Out-File -Encoding UTF8 %s'
vim.o.shellredir = '| Out-File -Encoding UTF8 %s'


-- at startup: open src in it
vim.cmd("Source")  -- vim.cmd("wincmd h")

