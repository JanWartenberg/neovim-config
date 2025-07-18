-- let this be my central nvim config
local config = require("fluidbrikett.config")
local remap = require("fluidbrikett.remap")
require("fluidbrikett.vim-plug")
require("fluidbrikett.shortcuts")
require("fluidbrikett.lsp")
require("fluidbrikett.load_present")
require("fluidbrikett.menu")
require("fluidbrikett.multigrep")

vim.g.netrw_sort_sequence = [[[\/]$,\~$]]

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

local undodir = vim.fn.expand(config.path_join(vim.g.Nvimconfig, "undodir"))
vim.opt.undodir = undodir
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

vim.opt.scrolloff = remap.scrolloff
vim.opt.signcolumn = "yes"      --sign column: dedicated area on the left side of the editor 
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.timeoutlen = 500

-- block shaped cursor in normal/visual/select mode
-- vertical bar cursor with 20% width in insert/command-line/insert-completion/virtual replace mode
-- horizontal bar cursor with height of 50% in replace / operator-pending mode
vim.opt.guicursor = "n-v-sm:block,i-c-ci-cr-ve:ver20,r-o:hor50"

-- auto change dir in net rw
vim.opt.autochdir = true

-- fix that floaterm opens new instances at toggle
vim.opt.hidden = true

-- Sets the shell to use for system() and ! commands  (use powershell)
vim.opt.shell = 'powershell.exe'
vim.opt.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command '
vim.opt.shellxquote = ''
vim.opt.shellquote = ''
vim.o.shellpipe = '| Out-File -Encoding UTF8 %s'
vim.o.shellredir = '| Out-File -Encoding UTF8 %s'


-- -------------------
-- This might be a stupid hack,
-- but if I want to open the netrw in Dropbox folder per default I override the possibility
-- to open a specific text file passed in via cmd line.
-- -------------
local uv = vim.loop

-- Check if something is a file
local function is_file(path)
  local st = uv.fs_stat(path)
  return st and st.type == "file"
end
local function is_dir(path)
  local st = uv.fs_stat(path)
  return st and st.type == "directory"
end

local open_target = false
-- parse neovim's argv
for k, v in pairs(vim.v.argv) do
    if k == 3 then
        local escpath = vim.fn.fnameescape(v)
        if is_file(v) then
            print("trying to open " .. escpath)
            vim.cmd("e " .. v)
            open_target = true
        elseif is_dir(v) then
            print("trying to list " .. escpath)
            vim.cmd("silent! Explore " .. escpath)
            open_target = true
        else
        end
    end
end

-- at startup: open Dropbox
-- if we did not pass in a file name
if not open_target then
    config.Default_startup()
end
-- end of stupid hack
-- -----------------------
