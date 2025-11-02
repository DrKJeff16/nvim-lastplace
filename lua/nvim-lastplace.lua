---@class Lastplace
local Lastplace = {}

function Lastplace.get_defaults()
    return {
        lastplace_ignore_buftype = { 'quickfix', 'nofile', 'help' },
        lastplace_ignore_filetype = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' },
        lastplace_open_folds = 1,
    }
end

---@param str string|nil
---@return string[]|nil
local function split_on_comma(str)
    if not str then
        return
    end

    local ret_tab = {} ---@type string[]
    for word in str:gmatch('([^,]+)') do
        table.insert(ret_tab, word)
    end
    return ret_tab
end

---@param option string
---@param default any
local function set_option(option, default)
    -- Coalesce boolean options to integer 0 or 1
    if type(Lastplace.options[option]) == 'boolean' then
        Lastplace.options[option] = Lastplace.options[option] and 1 or 0
    end

    -- Set option to either the option value or the default
    Lastplace.options[option] = Lastplace.options[option]
        or split_on_comma(vim.g[option])
        or default
end

---@param options? table
function Lastplace.setup(options)
    Lastplace.options = options or {}
    set_option('lastplace_ignore_buftype', { 'quickfix', 'nofile', 'help' })
    set_option('lastplace_ignore_filetype', { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' })
    set_option('lastplace_open_folds', 1)

    local group = vim.api.nvim_create_augroup('NvimLastplace', { clear = true })
    vim.api.nvim_create_autocmd('BufRead', {
        group = group,
        callback = function(ev)
            vim.api.nvim_create_autocmd('BufWinEnter', {
                group = group,
                buffer = ev.buf,
                callback = function()
                    Lastplace.lastplace_ft(ev.buf)
                end,
            })
        end,
    })
end

local function set_cursor_position()
    local last_line = vim.fn.line([['"]])
    local buff_last_line = vim.fn.line('$')
    local window_last_line = vim.fn.line('w$')
    local window_first_line = vim.fn.line('w0')
    -- If the last line is set and the less than the last line in the buffer
    if last_line > 0 and last_line <= buff_last_line then
        -- Check if the last line of the buffer is the same as the window
        if window_last_line == buff_last_line then
            -- Set line to last line edited
            vim.api.nvim_command([[keepjumps normal! g`"]])
            -- Try to center
        elseif buff_last_line - last_line > ((window_last_line - window_first_line) / 2) - 1 then
            vim.api.nvim_command([[keepjumps normal! g`"zz]])
        else
            vim.api.nvim_command([[keepjumps normal! G'"<c-e>]])
        end
    end
    if vim.fn.foldclosed('.') ~= -1 and Lastplace.options.lastplace_open_folds == 1 then
        vim.api.nvim_command([[normal! zvzz]])
    end
end

function Lastplace.lastplace_buf()
    local bufnr = vim.api.nvim_get_current_buf()
    local ignore_bt = Lastplace.options.lastplace_ignore_buftype
    if vim.list_contains(ignore_bt, vim.bo[bufnr].buftype) then
        return
    end

    local ignore_ft = Lastplace.options.lastplace_ignore_filetype
    if vim.list_contains(ignore_ft, vim.bo[bufnr].filetype) then
        -- reset cursor to first line
        vim.api.nvim_command([[normal! gg]])
        return
    end

    -- If a line has already been specified on the command line, we are done
    --   nvim file +num
    if vim.fn.line('.') > 1 then
        return
    end
    set_cursor_position()
end

---@param buffer integer
function Lastplace.lastplace_ft(buffer)
    local ignore_bt = Lastplace.options.lastplace_ignore_buftype
    if vim.list_contains(ignore_bt, vim.bo[buffer].buftype) then
        return
    end

    local ignore_ft = Lastplace.options.lastplace_ignore_filetype
    if vim.list_contains(ignore_ft, vim.bo[buffer].filetype) then
        -- reset cursor to first line
        vim.api.nvim_command([[normal! gg]])
        return
    end

    -- If a line has already been set by the BufReadPost event or on the command
    -- line, we are done.
    if vim.fn.line('.') > 1 then
        return
    end

    -- This shouldn't be reached but, better have it ;-)
    set_cursor_position()
end

return Lastplace
