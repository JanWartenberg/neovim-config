-- visual highlighting
--   independent of plugins like treesitter

vim.opt.termguicolors = true

-- local golden = { fg = "#FFD700", bold = true }
local boldblue = { fg = "#87CEFA", italic = true, bold = true }
local lightblue = { fg = "#87CEFA", italic = true }

local aug = vim.api.nvim_create_augroup("GlobalTodoHighlight", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost" }, {
  group = aug,
  callback = function()
    -- matchadd: global word markers even inside treesitter comments

    -- highlight whole line
    vim.fn.matchadd("TodoGlobal", "^.*\\<TODO\\>.*$")
    -- highlight keyword only
    --vim.fn.matchadd("TodoGlobal", "\\<TODO\\>")
    --vim.fn.matchadd("NoteGlobal", "\\<NOTE\\>")
    vim.fn.matchadd("NoteGlobal", "^.*\\<NOTE\\>.*$")

    vim.api.nvim_set_hl(0, "TodoGlobal", boldblue)
    vim.api.nvim_set_hl(0, "NoteGlobal", lightblue)
  end,
})



-- I thought about a custom queries/lua/highlights.scm
--    (would have been nice since we'd only check for the keywords in comments)
--    but with this loading highlighting in lua becomes unbearably slow
--    
-- ((comment) @comment.todo
--   (#match? @comment.todo "TODO"))
-- 
-- ((comment) @comment.note
--   (#match? @comment.note "NOTE"))
-- vim.api.nvim_set_hl(0, "@comment.todo", boldblue)
-- vim.api.nvim_set_hl(0, "@comment.note", lightblue)
