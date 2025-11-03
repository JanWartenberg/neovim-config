-- This file is supposed to carry enviroment configs
-- for needed distinctions between installations.
--  i.e. Paths might be different on private Laptop than WSL on Work PC..
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


    -- explicit start of LSPs right now only needed for 0.11.5 on WSL
    Config.Default_startup = function()
      -- check, if Configs are defined
      local ok, cfg_tbl = pcall(function()
        return vim.lsp.config._configs or {}
      end)
      if not ok or not cfg_tbl then
        vim.notify("No LSP configs registered yet", vim.log.levels.WARN)
        return
      end

      local util_ok, util = pcall(require, "lspconfig.util")
      if not util_ok then
        vim.notify("lspconfig.util missing", vim.log.levels.ERROR)
        return
      end

      for name, cfg in pairs(cfg_tbl) do
        -- skip already‑running servers
        local running = vim.iter(vim.lsp.get_clients()):any(function(c)
          return c.name == name
        end)
        if running then
          goto continue
        end

        local root = (cfg.root_dir and cfg.root_dir(vim.fn.getcwd()))
          or util.root_pattern(".git")(vim.fn.getcwd())

        vim.notify(("Starting %s (manual WSL start)"):format(name))
        vim.lsp.start({
          name = name,
          cmd = (cfg.cmd and cfg.cmd[1]) and cfg.cmd or { name },
          root_dir = root,
          filetypes = cfg.filetypes,
          capabilities = cfg.capabilities,
          settings = cfg.settings,
          flags = cfg.flags,
          on_attach = cfg.on_attach,
        })

        ::continue::
      end
    end
elseif environment == Config.ENVS.DOCKER then
    vim.g.homedir= '~'
    vim.g.Nvimconfig = "/root/.config/nvim"
    vim.g.Source = "/tmp/"
    Config.Default_startup = function ()
        vim.cmd("Nvimconfig")
    end
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
