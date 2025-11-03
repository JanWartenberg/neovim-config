require("mason").setup {
    log_level = vim.log.levels.DEBUG,
    PATH = "prepend",
}

-- sensible keymaps for autocomplete
local cmp = require('cmp')
cmp.setup{
    mapping = {
        ["<Up>"] = cmp.mapping.select_prev_item(),
        ["<Down>"] = cmp.mapping.select_next_item(),
        -- ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ["<CR>"] = cmp.mapping.confirm { select = false },
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
    }
}

