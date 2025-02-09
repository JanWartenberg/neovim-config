--- present plugin
--- as presented by TJ Devries
---     https://www.youtube.com/watch?v=VGid4aN25iI

local M = {}

M.setup = function()
    -- nothing
    -- part for user configuration
end


local function create_floating_window(config)
    -- Create a buffer
    local buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
    -- Create the floating window
    local win = vim.api.nvim_open_win(buf, true, config)

    -- For me the Floatborder has a black bg 
    -- having multiple floats with the greyish blue will make it look wonky
    -- so we override the highlight, with a local ns and only for this window
    local ns = vim.api.nvim_create_namespace("present")
    vim.api.nvim_set_hl(ns, "FloatBorder", {bg="#1f2430"})
    vim.api.nvim_win_set_hl_ns(win, ns)

    return { buf = buf, win = win }
end

---@class present.Slides
---@fields slides present.Slide: The slides of the file

---@class present.Slide
---@filed title string: the title of the slide
---@filed body string[]: the body of the slide

--- Takes some lines and parses them
---@param lines string[]: The lines in the buffer
---@return present.Slides
local parse_slides = function(lines)
    local slides = { slides = {} }
    local current_slide = {
        title = "",
        body = {}
    }

    local separator = "^#"

    for _, line in ipairs(lines) do
        -- print(line, "find:", line:find(separator), "|")
        if line:find(separator) then
            if #current_slide.title > 0 then
                table.insert(slides.slides, current_slide)
            end

            current_slide = {
                title = line,
                body = {}
            }
        else
            table.insert(current_slide.body, line)
        end

        table.insert(current_slide, line)
    end
    table.insert(slides.slides, current_slide)

    return slides
end

M.start_presentation = function(opts)
    opts = opts or {}
    opts.bufnr = opts.bufnr or 0

    local lines = vim.api.nvim_buf_get_lines(opts.bufnr, 0, -1, false)
    local parsed = parse_slides(lines)

    local width = vim.o.columns
    local height = vim.o.lines
    ---@type vim.api.keyset.win_config
    local windows = {
        -- one window config for whole wrapping window
        background = {
            relative = "editor",
            width = width,
            height = height,
            --style = "minimal",
            col = 0,
            row = 0,
            zindex = 1,
        },
        -- windows configuration for the header only
        header = {
            relative = "editor",
            width = width,
            height = 1,
            style = "minimal",
            border = "rounded",
            col = 0,
            row = 0,
            zindex = 2,
        },
        -- windows configuration for the body only
        body = {
            relative = "editor",
            width = width - 8,
            height = height - 5,
            style = "minimal", -- No borders or extra UI elements
            border = { "#", "#", "#", "#", "#", "#", "#", "#" },
            --border = { " ", " ", " ", " ", " ", " ", " ", " " },
            col = 8,
            row = 4,
        }
        -- footer = {},
    }

    local background_float = create_floating_window(windows.background)
    local header_float = create_floating_window(windows.header)
    local body_float = create_floating_window(windows.body)

    vim.bo[header_float.buf].filetype = "markdown"
    vim.bo[body_float.buf].filetype = "markdown"

    local set_slide_content = function(idx)
        local slide = parsed.slides[idx]

        local padding = string.rep(" ", (width - #slide.title) / 2)
        local title = padding .. slide.title
        vim.api.nvim_buf_set_lines(header_float.buf, 0, -1, false, { title })
        vim.api.nvim_buf_set_lines(body_float.buf, 0, -1, false, slide.body)
    end

    local current_slide = 1
    vim.keymap.set("n", "n", function()
        current_slide = math.min(current_slide + 1, #parsed.slides)
        set_slide_content(current_slide)
    end, { buffer = body_float.buf })
    vim.keymap.set("n", "p", function()
        current_slide = math.max(current_slide - 1, 1)
        set_slide_content(current_slide)
    end, { buffer = body_float.buf })
    vim.keymap.set("n", "<Esc>", function()
        vim.cmd("close")
    end, { buffer = body_float.buf })
    vim.keymap.set("n", "q", function()
        vim.api.nvim_win_close(body_float.win, true)
    end, { buffer = body_float.buf })

    local restore = {
        cmdheight = {
            original = vim.o.cmdheight,
            present = 0
        },
        foldenable = { -- markdown folded per default, we dont want that in present mode
            original = vim.o.foldenable,
            present = false
        }
    }

    -- Set the options we want during presentation
    for option, config in pairs(restore) do
        vim.opt[option] = config.present
    end

    -- create callback, for the case that the buffer gets closed again
    vim.api.nvim_create_autocmd("BufLeave", {
        buffer = body_float.buf,
        callback = function()
            -- Set the options we had originally
            for option, config in pairs(restore) do
                vim.opt[option] = config.original
            end

            -- pcall this, because it is annoying if it fails
            --  i.e. call in protected mode and to not propagate any errors
            pcall(vim.api.nvim_win_close, header_float.win, true)
            pcall(vim.api.nvim_win_close, background_float.win, true)
        end
    })

    -- set it to first slide as default
    --vim.api.nvim_buf_set_lines(float.buf, 0, -1, false, parsed.slides[1])
    set_slide_content(current_slide)
end

--- quick&dirty workaround: open the md file in a neovim buffer
---:echo nvim_get_current_buf()
--- and type in the number here as a parameter
M.start_presentation { bufnr = 11 }
---vim.print(parse_slides {
---    "# Hello",
---    "this is something else",
---    "2nd line under hello",
---    "# World",
---    "this is another thing",
---})

return M
