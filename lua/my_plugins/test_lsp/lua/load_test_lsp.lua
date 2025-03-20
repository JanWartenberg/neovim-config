
local client = vim.lsp.start_client {
    name = "educationalsp",
    cmd = { "C:/Users/janwa/Dropbox/wichtiges/Code/go_educlsp/main.exe" },
    -- we could introduce some specific keymaps in a callback here
    -- (but in remap.lua I have some general LSP keymaps anyhow)
    --on_attach = require("tj.lsp").on_attach  
}

if not client then
    vim.notify "hey, you didnt do the client thing good"
    return
end

-- attach it to markdown for now
-- whenever we open a markdown file, connect to our LSP
vim.api.nvim_create_autocmd("FileType", {
    pattern= "markdown",
    callback = function ()
        -- pass in current buffer and the client defined above
        vim.lsp.buf_attach_client(0, client)
    end
})
