-- TODO think what might be nice 
--   take default and extend it?
--   e.g. by "copy Buffer Path"?

-- aunmenu PopUp: clears the right click context menu
--  "all un-menu"
--aunmenu PopUp
--
--  anorememnu : all no remap
--
--  PopUp.-1-  adds a blank space
--nnoremenu PopUp.Back            <C-t>
-- does not work for me:
--amenu PopUp.URL                 gx
--http://example.com

--amenu PopUp.-1-                 <nop>
--anoremenu PopUp.Inspect         <cmd>Inspect<CR>
vim.cmd [[
    amenu PopUp.-2-                 <nop>
    anoremenu PopUp.Definition      <cmd>lua vim.lsp.buf.definition()<CR>
    anoremenu PopUp.References      <cmd>Telescope lsp_references<CR>
    amenu PopUp.-3-                 <nop>
    anoremenu PopUp.Go\ Back        <C-O>
]]

local group = vim.api.nvim_create_augroup("nvim_popupmenu", { clear = true })
vim.api.nvim_create_autocmd("MenuPopup", {
    pattern = "*",
    group = group,
    desc = "Custom PopUp Setup",
    callback = function()
        vim.cmd [[
            amenu disable PopUp.Definition
            amenu disable PopUp.References
            amenu disable PopUp.-3-
            amenu disable PopUp.Go\ Back
        ]]
        if vim.lsp.get_clients({ bufnr = 0 })[1] then
            vim.cmd [[
                amenu enable PopUp.Definition
                amenu enable PopUp.References
                amenu enable PopUp.-3-
                amenu enable PopUp.Go\ Back
            ]]
        end
        --local word = vim.fn.expand("<cword>")
        --if vim.startswith(word, "http") then
        --    vim.cmd [[amenu enable PopUp.URL]]
        --end
    end,
})
