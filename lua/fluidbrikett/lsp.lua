-- disable the built‐in “Lua Diagnostics” source entirely
local ns_id = vim.api.nvim_get_namespaces()["Lua Diagnostics"]
if ns_id then
  vim.diagnostic.disable(nil, ns_id)
end

-- popup menu behaviour
vim.cmd [[
  set completeopt+=menuone,noselect,popup
]]

local lspconfig    = require("lspconfig")
local cmp_cap      = require("cmp_nvim_lsp").default_capabilities()
local servers      = {
  "clangd","cmake","cssls","eslint","gopls","hoon_ls",
  "html","htmx","lua_ls","pylsp","rust_analyzer","ts_ls",
}

-- Common on_attach for _all_ servers: enable vim.lsp.completion
local function common_on_attach(client, bufnr)
  vim.lsp.completion.enable(true, client.id, bufnr, {
    autotrigger = true,
    convert = function(item)
      -- strip any "(…)" suffix from the label
      return { abbr = item.label:gsub("%b()", "") }
    end,
  })

  -- possible to set up keymaps, formatting on save, etc. here
end

--  Loop and configure each server
for _, name in ipairs(servers) do
  local cfg = {
    capabilities = cmp_cap,
    flags        = { debounce_text_changes = 150 },
    on_attach    = common_on_attach,
  }

  -- per‐server tweaks:
  if name == "pylsp" then
    cfg.filetypes   = { "python" }
    cfg.root_dir    = lspconfig.util.root_pattern(
                        "pyproject.toml",
                        "setup.py",
                        "requirements.txt",
                        ".git"
                      )
    cfg.settings    = {
      pylsp = {
        plugins = {
          pycodestyle = { enabled = true },
          pylint      = { enabled = true },
        },
      },
    }
  elseif name == "lua_ls" then
      cfg.settings = {
          Lua = {
              diagnostics = {
                  -- recognize vim as global variable
                  globals = { 'vim' },
              },
              runtime = {
                -- tell the server which Lua version you're using (most Neovim configs use LuaJIT)
                version = "LuaJIT",
                -- make sure your runtime path is discoverable
                path = vim.split(package.path, ";"),
              },
              workspace = {
                -- make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
              },
              telemetry = { enable = false },
            }
      }
  elseif name == "ts_ls" then
    cfg.cmd       = { "typescript-language-server", "--stdio" }
    cfg.filetypes = {
      "javascript","typescript","javascriptreact",
      "typescriptreact","vue","json",
    }
    cfg.root_dir  = lspconfig.util.root_pattern(
                     "package.json",
                     "tsconfig.json",
                     ".git"
                   )
    cfg.init_options = { provideFormatter = true }
  end

  -- tell lspconfig to actually set it up:
  lspconfig[name].setup(cfg)
end
