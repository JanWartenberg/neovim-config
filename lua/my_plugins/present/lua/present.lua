--- present plugin
--- as presented by TJ Devries 
---     https://www.youtube.com/watch?v=VGid4aN25iI

local M = {}

M.setup = function ()
    -- nothing
    -- part for user configuration
end

-- -- this is the checked in version
-- -- don't know why the fuck this is not working
-- local function create_floating_window(config, enter)
--     if enter == nil then
--         enter = false
--     end
-- 
--     local buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
--     local win = vim.api.nvim_open_win(buf, enter or false, config)
-- 
--     return { buf = buf, win = win }
-- end

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.9)
  local height = opts.height or math.floor(vim.o.lines * 0.9)
  -- Calculate the position to center the window
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)
  -- Create a buffer
  local buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
  -- Define window configuration
  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal", -- No borders or extra UI elements
    --border = "rounded",
    --border = {" ", " ", " ", " ", " ", " ", " ", " "}
    border = {"#", "#", "#", "#", "#", "#", "#", "#"}
  }
  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)
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
    local slides = { slides = {}}
    local current_slide = {}

    local separator = "^#"

    for _, line in ipairs(lines) do
        -- print(line, "find:", line:find(separator), "|")
        if line:find(separator) then
            if #current_slide > 0 then
                table.insert(slides.slides, current_slide)
            end

            current_slide = {}
        end

        table.insert(current_slide, line)
    end
    table.insert(slides.slides, current_slide)

    return slides

end

M.start_presentation = function (opts)
    opts = opts or {}
    opts.bufnr = opts.bufnr or 0

    local lines = vim.api.nvim_buf_get_lines(opts.bufnr, 0, -1, false)
    local parsed = parse_slides(lines)
    local float = create_floating_window()

    local current_slide = 1
    vim.keymap.set("n", "n", function()
        current_slide = math.min(current_slide+1, #parsed.slides)
        vim.api.nvim_buf_set_lines(float.buf, 0, -1, false, parsed.slides[current_slide])
    end, { buffer = float.buf})
    vim.keymap.set("n", "p", function()
        current_slide = math.max(current_slide-1, 1)
        vim.api.nvim_buf_set_lines(float.buf, 0, -1, false, parsed.slides[current_slide])
    end, { buffer = float.buf})
    vim.keymap.set("n", "<Esc>", function()
        vim.cmd("close")
    end, { buffer = float.buf})
    vim.keymap.set("n", "q", function()
        vim.api.nvim_win_close(float.win, true)
    end, { buffer = float.buf})

    local restore = {
        cmdheight = {
            original = vim.o.cmdheight,
            present = 0
        }
    }

    -- Set the options we want during presentation
    for option, config in pairs(restore) do
        vim.opt[option] = config.present
    end

    -- create callback, for the case that the buffer gets closed again
    vim.api.nvim_create_autocmd("BufLeave", {
        buffer = float.buf,
        callback = function()
            --print "yada yada yada"
            -- Set the options we had originally
            for option, config in pairs(restore) do
                vim.opt[option] = config.original
            end
        end
    })

    -- set it to first slide as default
    vim.api.nvim_buf_set_lines(float.buf, 0, -1, false, parsed.slides[1])
end

--- quick&dirty workaround: open the md file in a neovim buffer
---:echo nvim_get_current_buf()  
--- and type in the number here as a parameter
M.start_presentation { bufnr = 45 }
---vim.print(parse_slides {
---    "# Hello",
---    "this is something else",
---    "2nd line under hello",
---    "# World",
---    "this is another thing",
---})

return M
