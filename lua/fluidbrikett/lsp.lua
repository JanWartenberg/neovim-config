local cmp_cap = require("cmp_nvim_lsp").default_capabilities()
cmp_cap.offsetEncoding = { "utf-16" }

local list = { 'jdtls', 'lua_ls', 'pylsp', 'ts_ls'
    -- 'jdtls',   -- fix later
    -- 'ruff',    -- only use as formatter, keep it installed via Mason
    -- TODO 'clangd', 'cmake', 'gopls',
}

vim.lsp.config['jdtls'] = {
    cmd = {'jdtls', '-data', vim.fn.stdpath('data') .. '/jdtls-workspace/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')},
    filetypes = { 'java' },
    root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' },
    settings = {
      java = {
        signatureHelp = { enabled = true },
        format = { enabled = true },
      },
    }
}

vim.lsp.config['lua_ls'] = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
    settings = {
        Lua = {
            format = { defaultConfig = { max_line_length = "100" } },
            runtime = { version = 'LuaJIT' },
            workspace = { library = vim.api.nvim_get_runtime_file('', true) },
            diagnostics = { globals = { 'vim' } },
            telemetry = { enable = false },
        },
    },
}

vim.lsp.config['pylsp'] = {
    cmd = { 'pylsp' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', '.git', 'requirements.txt', 'setup.py' },
    settings = {
        pylsp = {
            plugins = {
                flake8 = { maxLineLength = 88 },
                pycodestyle = { maxLineLength = 88 },
            },
        },
    },
}

vim.lsp.config['ts_ls'] = {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = { 'javascript', 'typescript',
      'javascriptreact', 'typescriptreact',
      'vue', 'json',
    },
    root_markers = { 'package.json', 'tsconfig.json', '.git' }
}


local common_cfg = {
    capabilities = cmp_cap,
    flags = { debounce_text_changes = 150 },
    -- on_attach = common_on_attach,
}

-- Enable everything that has been configured
for _, name in ipairs(list) do
    local cfg = vim.lsp.config[name] or {}
    -- merge common + existing: later tables override earlier keys
    vim.lsp.config[name] = vim.tbl_deep_extend('force', cfg, common_cfg)

    vim.lsp.enable(name)
end
