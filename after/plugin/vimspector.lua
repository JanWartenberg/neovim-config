-- Vimspector options
vim.g.vimspector_sidebar_width = 85
vim.g.vimspector_bottombar_height = 15
vim.g.vimspector_terminal_maxwidth = 70

-- Vimspector
-- Reset also ends the debug session and closes the Vimspector windows
-- PyCharm: F5: StepOver F6: StepInto F7: StepOut, Ctrl-F2: Stop Run/Debug
-- might only work if source file opened and breakpoint is set
vim.keymap.set('n', "<F9>", ":call vimspector#Launch()<cr>")
vim.keymap.set('n', "<F5>", ":call vimspector#StepOver()<cr>")
vim.keymap.set('n', "<F6>", ":call vimspector#StepInto()<cr>")
vim.keymap.set('n', "<F7>", ":call vimspector#StepOut()<cr>")
vim.keymap.set('n', "<F12>", ":call vimspector#Reset()<cr>")


vim.keymap.set('n', "Db", ":call vimspector#ToggleBreakpoint()<cr>")
vim.keymap.set('n', "Dw", ":call vimspector#AddWatch()<cr>")
vim.keymap.set('n', "De", ":call vimspector#Evaluate()<cr>")
