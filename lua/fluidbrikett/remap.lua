require("fluidbrikett.shortcuts")

local M = {}
M.scrolloff = 8
vim.g.mapleader = " "

-- open same file again (split vertically) and scroll down
-- instead of a wild guess, now take window size into account
vim.keymap.set("n", "<leader>ss", function ()
    local winheight = vim.fn.winheight(vim.fn.winnr())  - M.scrolloff
    local command = string.format("<C-w>v<C-w>w%d<C-e>", winheight)
    command = vim.api.nvim_replace_termcodes(command, false, false, true)
    vim.api.nvim_feedkeys(command, "n", false)
end)

-- jumpt to netrw
vim.keymap.set("n", "<leader>ff", vim.cmd.Ex)
vim.keymap.set("n", "-", vim.cmd.Ex)

-- Selected lines can be moved with Shift+J / Shift+K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- join line below to the current one with one space in between
vim.keymap.set("n", "J", "mzJ`z")
-- when scrolling, center cursor vertically
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

--if text is pasted over selected text, keep the pasted text in the buffer
vim.keymap.set("x", "<leader>p", [["_dP]])
-- system clipboard for convenience
vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
-- y$  yank till end of line (without linebreak)
-- "+y$  yank to system clip till end of line
vim.keymap.set({ "n" }, "<leader>c", [["+y$]])

vim.keymap.set({ "n", "v" }, "<leader>b", YankCurrentBuffPath)

-- yank+replace current word
vim.keymap.set({ "n" }, "<leader>r", [[viw"0p]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")
-- commonly used remap to go from insert to normal..
vim.keymap.set("i", "jk", "<Esc>")
-- remap this, which is short for :q! per default
vim.keymap.set("n", "Q", "<nop>")


vim.keymap.set('n', 'grn', vim.lsp.buf.rename)
vim.keymap.set('n', 'gra', vim.lsp.buf.code_action)
vim.keymap.set('n', 'grr', vim.lsp.buf.references)
vim.keymap.set("n", "<leader>fo", vim.lsp.buf.format)
-- Show LSP diagnostic (i.e. Warning/Errors) in floating window 
-- (in case message is cropped in small window)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
-- Show LSP hover, which should show the docstring of an element
vim.keymap.set("n", "<leader>ee", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action)
-- jump to next lsp error
vim.keymap.set("n", "<leader>ä", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>ö", vim.diagnostic.goto_prev)

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz")

-- more ease on navigation on German Keyboard
vim.keymap.set({ "n", "v" }, "ö", "{")
vim.keymap.set({ "n", "v" }, "ä", "}")
vim.keymap.set({ "n", "v" }, "Ö", "[")
vim.keymap.set({ "n", "v" }, "Ä", "]")

-- for some reason Ctrl-V is now broken.. (Windows 11??)
-- allow Block editing:
vim.keymap.set("n", "<C-b>", "<C-v>")
-- allow inserting explicit chars, like <Tab>
vim.keymap.set("i", "<C-b>", "<C-v>")

-- Space s: replace all findings of the word under the cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- Space s in Visual mode: search/replace only within selection
-- replace all findings, after having selected in visual line mode
vim.keymap.set("v", "<leader>s", [[:s/\%V<C-r><C-w>\%V/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set({"n", "v"}, "<leader>h", "<cmd>nohlsearch<CR>")

-- FloaTerm configuration
vim.keymap.set('n', "<leader>ft", ":FloatermNew --name=myfloat --height=0.8 --width=0.7 --autoclose=0 <CR>")
vim.keymap.set('n', "<leader>fn", ":FloatermNext <CR>")
vim.keymap.set('t', "<leader>fn", "<C-\\><C-n>:FloatermNext <CR>")
vim.keymap.set('t', "<leader>fp", "<C-\\><C-n>:FloatermPrev <CR>")
vim.keymap.set('n', "<leader>fp", ":FloatermPrev <CR>")
vim.keymap.set('n', "<leader>fs", ":FloatermShow <CR>")

vim.keymap.set('n', "<C-t>", ":FloatermToggle myfloat <CR>")
vim.keymap.set('t', "<Esc>", "<C-\\><C-n>:q<CR>")

vim.keymap.set('n', "<leader>lf", "<C-^>")
vim.keymap.set('n', "<leader>lb", "<cmd>e #<CR>")


vim.keymap.set("x", "<C-v>", "<nop>")

return M
