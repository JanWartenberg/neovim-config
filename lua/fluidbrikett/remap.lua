vim.g.mapleader = " "

-- open same file again (split vertically) and scroll down
vim.keymap.set("n", "<leader>ss", "<C-w>v<C-w>w100j")

-- jumpt to netrw
vim.keymap.set("n", "<leader>ff", vim.cmd.Ex)
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Selected lines can be moved with Shift+J / Shift+K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- join line below to the current one with one space in between
vim.keymap.set("n", "J", "mzJ`z")
-- when scrolling, center cursor vertically
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

--if text is pasted over selected text, keep the pasted text in the buffer
vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>fo", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Space s: replace all findings of the word under the cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- replace all findings, after having selected in visual line mode
vim.keymap.set("v", "<leader>s", [[:<del><del><del><del><del>%s/\%V\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- FloaTerm configuration
vim.keymap.set('n', "<leader>ft", ":FloatermNew --name=myfloat --height=0.8 --width=0.7 --autoclose=0 <CR>")
vim.keymap.set('n', "<leader>fn", ":FloatermNext <CR>")
vim.keymap.set('t', "<leader>fn", "<C-\\><C-n>:FloatermNext <CR>")
vim.keymap.set('n', "t", ":FloatermToggle myfloat <CR>")
vim.keymap.set('t', "<Esc>", "<C-\\><C-n>:q<CR>")
