local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<C-f>', builtin.find_files, {})
vim.keymap.set('n', '<C-g>', function()
    -- changes the working directory to the directory of the current file
    vim.cmd("cd %:p:h")
    -- alternative would be   :vimgrep /pattern/ **/*
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
vim.keymap.set('n', '<C-h>', builtin.oldfiles, {})
vim.keymap.set('n', '<C-q>', builtin.quickfix, {}) -- quickfixhistory would be an alternative
