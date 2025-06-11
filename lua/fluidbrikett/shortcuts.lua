-- shortcuts
-- resp. "user commands", i.e.  something to type in à la
-- :MyCommand


--- Make an abbreviation for a command - even lowercase command possible
--- Take care not to remap core commands, of course.
--- This is a lua rewrite of
---     https://vim.fandom.com/wiki/Replace_a_builtin_command_using_cabbrev
CommandCabbr = function(abbreviation, expansion)
    vim.cmd("cabbr " .. abbreviation ..
        " <c-r>=getcmdpos() == 1 && getcmdtype() == ':' ? '" .. expansion ..
        "' : '" .. abbreviation .. "'<CR>")
end
vim.api.nvim_create_user_command('CommandCabbr', function(opts)
    local args = opts.fargs
    CommandCabbr(args[1], args[2])
end, { nargs = "*", desc = "Fluidbrikett: Make an abbreviation for a command, even lowercase command possible" })
-- Use it on itself to define a simpler abbreviation for itself.
vim.cmd("CommandCabbr ccab CommandCabbr")

-- ---------
-- Path shortcuts
-- (might reuse globals that are set in config)
vim.api.nvim_create_user_command('Source', function()
    vim.fn.chdir(vim.g.Source)
    vim.cmd("e " .. vim.g.Source)
end, { desc = "Fluidbrikett: shorten to change dir to src" })

vim.api.nvim_create_user_command('Nvimconfig', function()
    vim.fn.chdir(vim.g.Nvimconfig)
    vim.cmd("e " .. vim.g.Nvimconfig)
end, { desc = "Fluidbrikett: short to change dir to Neovim Config"})
vim.cmd("CommandCabbr nvc Nvimconfig")
-- Path shortcuts end
-- ---------

function OpenExplorer()
    local current_dir = vim.fn.expand('%:p:h')
    vim.fn.system('explorer.exe "' .. current_dir .. '"')
end

vim.api.nvim_create_user_command('WinExplorer', OpenExplorer,
    { desc = "Fluidbrikett: Open Windows file exlorer for path of current buffer" })

function FormatWhitespace()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    -- Remove dangling carriage returns (e.g. when pasting from PDFs)
    vim.cmd('%s/\r//ge')
    -- Remove trailing whitespace
    vim.cmd([[%s/\s\+$//ge]])
    vim.api.nvim_win_set_cursor(0, cursor_pos)
    vim.cmd [[ :nohlsearch ]]
end

vim.api.nvim_create_user_command('FormatWhitespace', FormatWhitespace,
    { desc = "Fluidbrikett: Format Whitespace, remove dangling CR, remove trailing Whitespace" })


-- join all lines in current buffer, but insert an explicit line break
function JoinAllLines()
    vim.cmd([[%s/\n/\\n/g]])        -- :%s/\n/\\n/g
    vim.cmd [[ :nohlsearch ]]
end
vim.api.nvim_create_user_command('JoinAllLines', JoinAllLines,
    { desc = "Fluidbrikett: Join All Lines of current Buffer" })


-- Kill all other Buffers except this one
function OnlyBuffer()
    vim.cmd [[ :%bd|e# ]]
end

vim.api.nvim_create_user_command('OnlyBuffer', OnlyBuffer,
    { desc = "Fluidbrikett: Delete all other buffers except the current one"})

--  yank path of current buffer into (system) clipboard
function YankCurrentBuffPath()
    local buffpath = vim.api.nvim_buf_get_name(0)
    vim.fn.setreg('+', buffpath)
end

vim.api.nvim_create_user_command('Buffpathyank', YankCurrentBuffPath,
    { desc = "Fluidbrikett: Yank path of current buffer into (system) clipboard" })

local function vim_grep_error_handled(grep_string)
    vim.notify("vimgrep " .. grep_string)
    if pcall(function() vim.cmd("vimgrep " .. grep_string) end)
    then
    else
        vim.notify("No matches found.", vim.log.levels.INFO)
    end
end

-- instead of having to open the diagnostic float
-- just copy the message to system clipboard
function Get_current_diagnostic_message()
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local row = cursor_pos[1] - 1 -- Convert to 0-indexed
    local col = cursor_pos[2]

    -- Get diagnostics for current buffer
    local diagnostics = vim.diagnostic.get(bufnr)
    local function is_cursor_in_diagnostic_range(diagnostic, cursor_row, cursor_col)
        if diagnostic.lnum ~= cursor_row then
            return false
        end

        local start_col = diagnostic.col
        -- there is no guarantee that .end_col is provided by every LSP
        local end_col = diagnostic.end_col or (diagnostic.col + 1)

        return cursor_col >= start_col and cursor_col < end_col
    end

    -- Find diagnostics at current position
    --  cursor on row of diag; cursor at or after diag column
    for _, diagnostic in ipairs(diagnostics) do
        if is_cursor_in_diagnostic_range(diagnostic, row, col) then
            -- yank to system clipboard
            vim.fn.setreg('+', diagnostic.message)
            return diagnostic.message
        end
    end

    vim.fn.setreg('+', "No diagnostic at cursor position")
    return "No diagnostic at cursor position"
end

vim.api.nvim_create_user_command('CurrentDiagnostic', Get_current_diagnostic_message,
    { desc = "Fluidbrikett: Copy the diagnostic message at your cursor into system clipboard" })

-- create search for "Headers"
-- i.e. if I use custom text notes with "====" as headers
-- will add those heading texts into the quickfix list
-- /\(^.*$\)\n=\{4}/g %
vim.api.nvim_create_user_command('Headersearch',
    function() vim_grep_error_handled([[/\(^.*$\)\n=\{4}/g %]]) end,
    { desc = "Fluidbrikett: Search for current 'Headers', defined by '===='" }
)
-- in custom text notes "* " on begin of line is like a list item
vim.api.nvim_create_user_command('Listentrysearch',
    function() vim_grep_error_handled([[/^\* \(.*\)$/g %]]) end,
    { desc = "Fluidbrikett: Search for bullet points, defined by '*'" }
)

vim.api.nvim_create_user_command('Datesearch',
    function() vim_grep_error_handled([[/(\d\+\.\d\+\.\d\+)/g %]]) end,
    { desc = "Fluidbrikett: Search for Dates, like (dd.mm.yyyy)" }
)

-- make wso to write file AND shoutout (execute script) directly
vim.api.nvim_create_user_command('Wso', function()
    vim.cmd("w")
    vim.cmd("so")
end, { desc = "Fluidbrikett: Shortened: save and source current buffer" })
vim.cmd("CommandCabbr wso Wso")
