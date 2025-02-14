-- print "fluidbrikett/present trying to load the plugin"
-- print("Current directory:", current_dir)

vim.api.nvim_create_user_command('PresentMarkdown',
    function()
        require("my_plugins.present.lua.present").start_presentation (
            { bufnr = vim.fn.bufnr('%') }
        )
    end,
    {}
)

