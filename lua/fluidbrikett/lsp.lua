local cmp_cap = require("cmp_nvim_lsp").default_capabilities()
cmp_cap.offsetEncoding = { "utf-16" }

local util = require("lspconfig.util")

local servers = {
  "clangd", "cmake", "cssls", "eslint", "gopls", "hoon_ls",
  "html", "htmx", "jdtls", "lua_ls", "pylsp", "ruff",
  "rust_analyzer", "ts_ls",
}

local function common_on_attach(client, bufnr)
  vim.lsp.completion.enable(true, client.id, bufnr, {
    autotrigger = true,
    convert = function(item)
      return { abbr = item.label:gsub("%b()", "") }
    end,
  })
end

for _, name in ipairs(servers) do
  local cfg = {
    capabilities = cmp_cap,
    flags = { debounce_text_changes = 150 },
    on_attach = common_on_attach,
  }

  -- per‑server settings
  if name == "pylsp" then
    cfg.filetypes = { "python" }
    cfg.root_dir = util.root_pattern(
      "pyproject.toml", "setup.py", "requirements.txt", ".git"
    )
    cfg.settings = {
      pylsp = {
        plugins = {
          pycodestyle = { maxLineLength = 88 },
          flake8 = { maxLineLength = 88 },
        },
      },
    }
  elseif name == "lua_ls" then
    cfg.settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        telemetry = { enable = false },
      },
    }
  elseif name == "ts_ls" then
    cfg.cmd = { "typescript-language-server", "--stdio" }
    cfg.filetypes = {
      "javascript", "typescript",
      "javascriptreact", "typescriptreact",
      "vue", "json",
    }
    cfg.root_dir = util.root_pattern("package.json", "tsconfig.json", ".git")
  elseif name == "jdtls" then
    local project = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    cfg.cmd = {
      "jdtls",
      "-data",
      vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project,
    }
    cfg.root_dir = util.root_pattern(
      ".git", "mvnw", "gradlew", "pom.xml", "build.gradle"
    )
  end

  local ok, err = pcall(vim.lsp.config, name, cfg)
  if not ok then
    vim.notify(("Cannot configure %s: %s"):format(name, err), vim.log.levels.ERROR)
  end
end
