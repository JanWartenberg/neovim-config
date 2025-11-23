-- start copilot first
require("copilot").setup({})

require("codecompanion").setup({
  strategies = {
    chat = { adapter = "copilot" },
    inline = { adapter = "copilot" },
  },
})

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- CMD + a for chat toggle
map("n", "<C-a>", "<cmd>CodeCompanionChat Toggle<cr>", opts)
map("v", "<C-a>", "<cmd>CodeCompanionChat Toggle<cr>", opts)

-- Leader + a for Inline Prompt
map("n", "<leader>a", "<cmd>CodeCompanion<cr>", opts)
map("v", "<leader>a", "<cmd>CodeCompanion<cr>", opts)

-- ga for Actions (Explain, Fix...)
map("n", "ga", "<cmd>CodeCompanionActions<cr>", opts)
map("v", "ga", "<cmd>CodeCompanionActions<cr>", opts)
