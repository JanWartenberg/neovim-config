require('ayu').setup({
    mirage = true,
    overrides = {
        Normal = { bg = "None" },
        ColorColumn = { bg = "None" },
        SignColumn = { bg = "None" },
        Folded = { bg = "None" },
        FoldColumn = { bg = "None" },
        CursorLine = { bg = "None" },
        CursorColumn = { bg = "None" },
        WhichKeyFloat = { bg = "None" },
        VertSplit = { bg = "None" },
    },
})

function ColorMyPencils(color)
	color = color or "ayu"
	vim.cmd.colorscheme(color)
    require('ayu').colorscheme()
end


ColorMyPencils()
