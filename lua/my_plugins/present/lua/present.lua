--- present plugin
--- as presented by TJ Devries
---     https://www.youtube.com/watch?v=VGid4aN25iI

local M = {}

M.setup = function()
    -- nothing
    -- part for user configuration
end

local create_window_configurations = function()
    local width = vim.o.columns
    local height = vim.o.lines

    local header_height = 1 + 2                                    -- 1 line + border
    local footer_height = 1                                        -- no border for now
    local body_height = height - header_height - footer_height - 2 -- for own border

    return {
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
            --height = height - 5,
            height = body_height,
            style = "minimal", -- No borders or extra UI elements
            border = { "#", "#", "#", "#", "#", "#", "#", "#" },
            --border = { " ", " ", " ", " ", " ", " ", " ", " " },
            col = 8,
            row = header_height,
        },
        footer = {
            relative = "editor",
            width = width,
            height = footer_height,
            style = "minimal",
            col = 0,
            row = height - 1,
            zindex = 2,
        },
    }
end

local function create_floating_window(config, enter)
    if enter == nil then
        enter = false
    end
    -- Create a buffer
    local buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
    -- Create the floating window
    local win = vim.api.nvim_open_win(buf, enter or false, config)

    -- For me the Floatborder has a black bg
    -- having multiple floats with the greyish blue will make it look wonky
    -- so we override the highlight, with a local ns and only for this window
    local ns = vim.api.nvim_create_namespace("present")
    vim.api.nvim_set_hl(ns, "FloatBorder", { bg = "#1f2430" })
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

    end
    table.insert(slides.slides, current_slide)

    return slides
end

local state = {
    floats = {},
    parsed = {},
    current_slide = 1
}

local foreach_float = function(cb)
    for name, float in pairs(state.floats) do
        cb(name, float)
    end
end

local present_keymap = function(mode, key, callback)
    vim.keymap.set(mode, key, callback, {
        buffer = state.floats.body.buf
    })
end

M.start_presentation = function(opts)
    opts = opts or {}
    opts.bufnr = opts.bufnr or 0

    local lines = vim.api.nvim_buf_get_lines(opts.bufnr, 0, -1, false)
    state.parsed = parse_slides(lines)
    state.title = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(opts.bufnr), ":t")

    local windows = create_window_configurations()
    state.floats.background = create_floating_window(windows.background)
    state.floats.header = create_floating_window(windows.header)
    state.floats.body = create_floating_window(windows.body, true)
    state.floats.footer = create_floating_window(windows.footer)

    foreach_float(function(_, float)
        vim.bo[float.buf].filetype = "markdown"
    end)

    local set_slide_content = function(idx)
        local slide = state.parsed.slides[idx]
        local width = vim.o.columns

        local padding = string.rep(" ", (width - #slide.title) / 2)
        local title = padding .. slide.title
        vim.api.nvim_buf_set_lines(state.floats.header.buf, 0, -1, false, { title })
        local footer = string.format("   %d / %d | %s",
            state.current_slide, 
            #state.parsed.slides,
            state.title)
        vim.api.nvim_buf_set_lines(state.floats.footer.buf, 0, -1, false, { footer })
        vim.api.nvim_buf_set_lines(state.floats.body.buf, 0, -1, false, slide.body)
    end

    present_keymap("n", "n", function()
        state.current_slide = math.min(state.current_slide + 1, #state.parsed.slides)
        set_slide_content(state.current_slide)
    end)
    present_keymap("n", "p", function()
        state.current_slide = math.max(state.current_slide - 1, 1)
        set_slide_content(state.current_slide)
    end)
    present_keymap("n", "<Esc>", function()
        vim.cmd("close")
    end)
    present_keymap("n", "q", function()
        vim.api.nvim_win_close(state.floats.body.win, true)
    end)

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
        buffer = state.floats.body.buf,
        callback = function()
            -- Set the options we had originally
            for option, config in pairs(restore) do
                vim.opt[option] = config.original
            end

            -- pcall this, because it is annoying if it fails
            --  i.e. call in protected mode and to not propagate any errors
            --  Funny: at least on the Win CMD: Neovim/CMD crash
            --      when I leave the present mode after resizing
            --      Zooming in, then quit -> crash with pcall
            --      Zooming in, then quit -> without pcall works
            --      Zooming out, then quit -> without pcall still crashes
            -- but something with resizing the window always was wonky on windows..
            -- (although win11 has become way more stable than win 10...)
            --pcall(vim.api.nvim_win_close, header_float.win, true)
            --pcall(vim.api.nvim_win_close, background_float.win, true)
            --vim.api.nvim_win_close(state.floats.header.win, true)
            --vim.api.nvim_win_close(state.floats.background.win, true)
            foreach_float(function(_, float)
                vim.api.nvim_win_close(float.win, true)
            end)
        end
    })


    vim.api.nvim_create_autocmd("VimResized", {
        group = vim.api.nvim_create_augroup("present-resized", {}),
        callback = function()
            if not vim.api.nvim_win_is_valid(state.floats.body.win) or state.floats.body.win == nil then
                return
            end

            local updated = create_window_configurations()
            foreach_float(function(name, _)
                vim.api.nvim_win_set_config(state.floats[name].win, updated[name])
            end)

            -- re-calculates current content
            set_slide_content(state.current_slide)
        end
    })

    -- set it to first slide as default
    --vim.api.nvim_buf_set_lines(float.buf, 0, -1, false, parsed.slides[1])
    set_slide_content(state.current_slide)
end

--- quick&dirty workaround: open the md file in a neovim buffer
---:echo nvim_get_current_buf()
--- and type in the number here as a parameter
--- M.start_presentation { bufnr = 9 }

vim.api.nvim_create_user_command('PresentMarkdown',
    function()
        M.start_presentation(
            { bufnr = vim.fn.bufnr('%') }
        )
    end,
    {}
)

-- expose it to test it, but not as a usable public interface, hence the underscore
M._parse_slides = parse_slides

return M
