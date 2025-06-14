local Config = {}

-- lua has no ENUMs but we can do this:
Config.ENVS = {
    WORK_PC = {},
    PRIVATE = {},
    BM_WSL = {},
    DOCKER = {},
}

function Config.path_join(...)
  local args = {...}
  local sep = package.config:sub(1,1) -- platform-specific separator
  return table.concat(args, sep)
end

-- CHANGE THIS PART ONLY
-- Set the environment to any of the ones defined in Config.ENVS
-- Example: local environment = Config.ENVS.BM_WSL
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
elseif environment == Config.ENVS.BM_WSL then
    vim.g.homedir = '~'
    vim.g.Nvimconfig = "~/.config/nvim"
    vim.g.Source = "C:\\Users\\JAWA\\src"
    -- path to python (python env including pynim)
    --vim.g.python3_host_prog = vim.g.homedir .. ''

    Config.Default_startup = function()
        print("No Default startup for BM WSL.")
    end
elseif environment == Config.ENVS.DOCKER then
    vim.g.homedir= '~'
    vim.g.Nvimconfig = "/root/.config/nvim"
    vim.g.Source = "/tmp/"
else
    -- else: ENVS.PRIVATE in our case
    require("my_plugins.test_lsp.lua.load_test_lsp")
    vim.g.homedir = 'C:\\Users\\janwa'
    vim.g.Source = "D:\\Docs\\Code"
    vim.g.Nvimconfig = vim.g.homedir .. "\\Appdata\\Local\\nvim"
    -- path to python (python env including pynim)
    vim.g.python3_host_prog = vim.g.homedir .. '\\AppData\\Local\\Programs\\Venv\\pynvim\\Scripts\\python.exe'

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
