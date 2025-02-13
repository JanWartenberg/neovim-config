-- print "fluidbrikett/present trying to load the plugin"
local current_dir = vim.fn.getcwd()
-- print("Current directory:", current_dir)

return {
    {
--        dir = "..\\..\\..\\plugged\\present.nvim",
--        dir = "..\\plugged\\present.nvim",
        dir = "plugged\\present.nvim",
        config = function ()
            require("present")
        end
    }
}
