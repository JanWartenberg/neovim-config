local Config = {}

-- lua has no ENUMs but we can do this:
Config.ENVS = {
    WORK_PC = {},
    PRIVATE = {},
}


-- CHANGE THIS PART ONLY
-- Set the environment to WORK_PC or PRIVATE
-- Example: local environment = Config.ENVS.WORK_PC
local environment = Config.ENVS.PRIVATE

-- Configuration based on environment
if environment == Config.ENVS.WORK_PC then
    vim.g.homedir = 'C:\\Users\\z659785'
    vim.g.Nvimconfig = "C:\\Users\\z659785\\Appdata\\Local\\nvim"
    vim.g.Source = "D:\\src\\"

    Config.Default_startup = function()
        -- blank for WORK_PC
        print("we have not Default_startup for WORK_PC")
    end

    vim.g.Scratches = "C:\\Users\\Z659785\\AppData\\Roaming\\JetBrains\\PyCharm2023.2\\scratches"

    vim.api.nvim_create_user_command('Scratches', function()
        vim.fn.chdir(vim.g.Scratches)
        vim.cmd("e " .. vim.g.Scratches)
    end, {})
else
    -- else: ENVS.PRIVATE in our case as long as we have 2 setups only
    require("my_plugins.test_lsp.lua.load_test_lsp")
    vim.g.homedir = 'C:\\Users\\janwa'
    vim.g.Source = "D:\\Docs\\Code"
    vim.g.Nvimconfig = vim.g.homedir .. "\\Appdata\\Local\\nvim"

    Config.Default_startup = function()
        vim.cmd("Dropbox")
    end

    vim.g.Dropbox = vim.g.homedir .. "\\Dropbox"
    vim.g.DropboxCode = vim.g.homedir .. "\\Dropbox\\wichtiges\\Code"
    vim.g.DropboxGitarre = vim.g.homedir .. "\\Dropbox\\wichtiges\\Gitarre\\Tabs"

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
end

return Config
