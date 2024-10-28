-- let this be my central nvim config
require("fluidbrikett.remap")
require("fluidbrikett.vim-plug")
require("fluidbrikett.shortcuts")

-- path to python (python env including pynim)
vim.g.python3_host_prog = vim.g.homedir .. '\\AppData\\Local\\Programs\\Venv\\pynvim\\Scripts\\python.exe'
-- vim.g.python3_host_prog = 'D:\\Docs\\Code\\venv\\Scripts\\python.exe'

vim.opt.encoding="utf-8"

-- tabs
vim.opt.expandtab = true -- insert spaces on tab
vim.opt.tabstop = 4      -- existing tab: show 4 spaces
vim.opt.softtabstop = 4  -- how many spaces the cursor moves
vim.opt.shiftwidth = 4   -- when indenting with '>', use 4 spaces
-- show tabs as greyed out ">~"
vim.opt.listchars =  { tab = '>~' }
vim.opt.list = true     -- this is magically needed to make listchars work

-- line numbers
vim.opt.relativenumber = true   -- relative line numbers
vim.opt.nu = true               -- still show absolute line number for the current one

-- rely on undo files and plugin "undotree", not on swap files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.g.homedir .. "\\AppData\\Local\\nvim\\undodir"
vim.opt.undofile = true

-- set shada     see :help 'shada'
-- Maximum number of previously edited files for which the marks are remembered
-- could be, that default is already set, however then the newer value "wins"
-- vim.opt.shada:append( "'300" )
-- alternative:  vim.opt.shada = "!,'300,<50,s10,h"
vim.opt.shada = "!,'400,<400,s200,h"
-- !        save and restore global variables that start with an uppercase letter
-- '300     for a maximum of 300 files marks are stored (incl. jumplist/changelist)
-- <300     Maximum number of lines saved for each register
-- s100     Maximum size of an item contents in KiB.
-- h        Disable the effect of 'hlsearch' when loading the shada file.

vim.opt.incsearch = true        --enable incremental search

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"      --sign column: dedicated area on the left side of the editor 
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


-- -------------------
-- This might be a stupid hack,
-- but if I want to open the netrw in Dropbox folder per default I override the possibility
-- to open a specific text file passed in via cmd line.
-- -------------
-- Check if something is a file
local function is_file(filename)
  local file = io.open(filename, "r")
  print("file: " .. filename)

  if file then
    file:close()
    return true
  else
    return false
  end
end


local open_filename = false
-- parse neovim's argv
for k, v in pairs(vim.v.argv) do
    if k == 3 then
        if is_file(v) then
            print("trying to open " .. v)
            vim.cmd("e " .. v)
            open_filename = true
        else
        end
    end
end

-- at startup: open Dropbox
-- if we did not pass in a file name
if not open_filename then
    vim.cmd("Dropbox")  -- vim.cmd("wincmd h")
end
-- end of stupid hack
-- -----------------------
