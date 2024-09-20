-- shortcuts
-- resp. "user commands", i.e.  something to type in à la 
-- :MyCommand

vim.g.homedir = 'C:\\Users\\janwa'

--- Make an abbreviation for a command - even lowercase command possible
--- Take care not to remap core commands, of course.
--- This is a lua rewrite of
---     https://vim.fandom.com/wiki/Replace_a_builtin_command_using_cabbrev
CommandCabbr = function (abbreviation, expansion)
    vim.cmd("cabbr " .. abbreviation ..
        " <c-r>=getcmdpos() == 1 && getcmdtype() == ':' ? '" .. expansion ..
        "' : '" .. abbreviation .. "'<CR>")
end
vim.api.nvim_create_user_command('CommandCabbr', function (opts)
    local args = opts.fargs
    CommandCabbr(args[1], args[2])
end, { nargs = '*' })
-- Use it on itself to define a simpler abbreviation for itself.
vim.cmd("CommandCabbr ccab CommandCabbr")

vim.g.Dropbox = vim.g.homedir .. "\\Dropbox"
vim.g.DropboxCode = vim.g.homedir .. "\\Dropbox\\wichtiges\\Code"
vim.g.DropboxGitarre = vim.g.homedir .. "\\Dropbox\\wichtiges\\Gitarre\\Tabs"
vim.g.Nvimconfig = vim.g.homedir .. "\\Appdata\\Local\\nvim"

vim.api.nvim_create_user_command('Dropbox', function()
    vim.fn.chdir(vim.g.Dropbox)
    vim.cmd("e " .. vim.g.Dropbox)
end, {})
vim.api.nvim_create_user_command('Gitarre', function()
    vim.fn.chdir(vim.g.DropboxGitarre)
    vim.cmd("e " .. vim.g.DropboxGitarre)
end, {})
vim.api.nvim_create_user_command('DropboxCode', function()
    vim.fn.chdir(vim.g.DropboxCode)
    vim.cmd("e " .. vim.g.DropboxCode)
end, {})
vim.api.nvim_create_user_command('Nvimconfig', function()
    vim.fn.chdir(vim.g.Nvimconfig)
    vim.cmd("e " .. vim.g.Nvimconfig)
end, {})
vim.api.nvim_create_user_command('Nvconf', function()
    vim.cmd("Nvimconfig")
end, {})
vim.cmd("CommandCabbr nvc Nvconf")


local function vim_grep_error_handled (grep_string)
    vim.notify("vimgrep "..grep_string)
    if pcall(function () vim.cmd("vimgrep "..grep_string) end)
    then
    else
        vim.notify("No matches found.", vim.log.levels.INFO)
    end
end

-- create search for "Headers"
-- i.e. if I use custom text notes with "====" as headers
-- will add those heading texts into the quickfix list
-- /\(^.*$\)\n=\{4}/g %
vim.api.nvim_create_user_command('Headersearch',
    function () vim_grep_error_handled([[/\(^.*$\)\n=\{4}/g %]]) end,
    {}
)
-- in custom text notes "* " on begin of line is like a list item
vim.api.nvim_create_user_command('Listentrysearch',
    function () vim_grep_error_handled([[vimgrep /^\\* \\(.*\\)$/g %]]) end,
    {}
)

function OpenExplorer()
  local current_dir = vim.fn.expand('%:p:h')
  vim.fn.system('explorer.exe "' .. current_dir .. '"')
end
vim.api.nvim_create_user_command('WinExplorer', OpenExplorer, {})

-- make wso to write file AND shoutout (execute script) directly
vim.api.nvim_create_user_command('Wso', function ()
   vim.cmd("w")
   vim.cmd("so")
end, {})
vim.cmd("CommandCabbr wso Wso")
vim.cmd("CommandCabbr dbc DropboxCode")
