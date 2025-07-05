-- Just include the PresentMarkdown plugin
-- by TJ DeVries

vim.api.nvim_create_user_command('PresentMarkdown',
    function()
        require("my_plugins.present.lua.present").start_presentation (
            { bufnr = vim.fn.bufnr('%') }
        )
    end,
    {}
)

