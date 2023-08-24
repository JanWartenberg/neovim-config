-- shortcuts
-- resp. "user commands", i.e.  something to type in à la 
-- :MyCommand


-- https://vim.fandom.com/wiki/Replace_a_builtin_command_using_cabbrev
-- Vim Script -> converted to lua script
-- function! CommandCabbr(abbreviation, expansion)
--   execute 'cabbr ' . a:abbreviation . ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "' . a:expansion . '" : "' . a:abbreviation . '"<CR>'
-- endfunction
-- command! -nargs=+ CommandCabbr call CommandCabbr(<f-args>)
-- CommandCabbr ccab CommandCabbr
CommandCabbr = function (abbreviation, expansion)
    -- hack for now.. if called as a vim command, args are squished into
    --  abbreviation.args as a string
    --  (for sure there is a better way to expand the args at nvim_create_user_command time,
    --  however I do not know it and this workaround seems to work..)
    if (type(abbreviation) == "table") then
        local args = {}
        for arg in abbreviation.args:gmatch("%w+") do table.insert(args, arg) end
        expansion = args[2]
        abbreviation = args[1]
    end
--     print("cabbr " .. abbreviation ..
--         " <c-r>=getcmdpos() == 1 && getcmdtype() == ':' ? '" .. expansion ..
--         "' : '" .. abbreviation .. "'<CR>")
    vim.cmd("cabbr " .. abbreviation ..
        " <c-r>=getcmdpos() == 1 && getcmdtype() == ':' ? '" .. expansion ..
        "' : '" .. abbreviation .. "'<CR>")
end
vim.api.nvim_create_user_command('CommandCabbr', CommandCabbr,
    { nargs = '*' })
    -- " Use it on itself to define a simpler abbreviation for itself.
vim.cmd("CommandCabbr ccab CommandCabbr")


vim.g.Dropbox = "C:\\Users\\janwa\\Dropbox"
vim.g.DropboxCode = "C:\\Users\\janwa\\Dropbox\\wichtiges\\Code"
vim.g.DropboxGitarre = "C:\\Users\\janwa\\Dropbox\\wichtiges\\Gitarre\\Tabs"
vim.g.Nvimconfig = "C:\\Users\\janwa\\Appdata\\Local\\nvim"

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

-- make wso to write file AND shoutout (execute script) directly
vim.api.nvim_create_user_command('Wso', function ()
   vim.cmd("w")
   vim.cmd("so")
end, {})
vim.cmd("CommandCabbr wso Wso")

