-- see more configuration options on: https://github.com/stevearc/aerial.nvim
require("aerial").setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
  backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },
  layout = {
    max_width = { 40, 0.15 },
    min_width = 12,
    default_direction = "prefer_left",
  }
})

-- keymap to toggle aerial: o for "overview"
vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle!<CR>")
