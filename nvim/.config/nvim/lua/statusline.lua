local utils = require('utils')
local add_hi = utils.add_hi

local function vcs()
    local icon = ' '
    local branch = vim.fn.system(
                       'git branch --show-current 2>/dev/null | tr -d \'\n\''
                   )

    return branch == '' and '' or string.format('%s %s', icon, branch .. ' ')
end

local function lsp_status()
    local err = 0
    local warn = 0
    local info = 0
    local hint = 0
    if not vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
        err = vim.lsp.diagnostic.get_count(0, [[Error]]);
        warn = vim.lsp.diagnostic.get_count(0, [[Warning]]);
        info = vim.lsp.diagnostic.get_count(0, [[Information]]);
        hint = vim.lsp.diagnostic.get_count(0, [[Hint]]);
    end

    return err == 0 and '' or err, warn == 0 and '' or warn,
           info == 0 and '' or info, hint == 0 and '' or hint
end

local mode_table = {
    n = 'Normal',
    no = 'N·Operator Pending',
    v = 'Visual',
    V = 'V·Line',
    ['^V'] = 'V·Block',
    s = 'Select',
    S = 'S·Line',
    ['^S'] = 'S·Block',
    i = 'Insert',
    R = 'Replace',
    Rv = 'V·Replace',
    c = 'Command',
    cv = 'Vim Ex',
    ce = 'Ex',
    r = 'Prompt',
    rm = 'More',
    ['r?'] = 'Confirm',
    ['!'] = 'Shell',
    t = 'Terminal',
}

local function get_mode(mode) return string.upper(mode_table[mode] or 'V-Block') end

local colors = {
    fg1 = '#282828', -- black
    color2 = '#504945', -- gray
    fg2 = '#ddc7a1', -- white
    color3 = '#32302f', -- black lightest
    color4 = '#a89984', -- gray 2
    color5 = '#7daea3', -- blue
    color6 = '#a9b665', -- green
    color7 = '#d8a657', -- yellow
    color8 = '#d3869b', -- purple
    color9 = '#ea6962', -- red
    fg3 = '#e9e9e9',
    color10 = '#3a3a3a',
    color11 = '#f485dd',
    color12 = '#83adad',
}

add_hi('StatuslineNormalAccent', colors.fg1, colors.color4, true);
add_hi('StatuslineSecondaryAccent', colors.fg2, colors.color2, false);
add_hi('StatuslineTertiaryAccent', colors.fg2, colors.color3, false);
add_hi('StatuslineCommandAccent', colors.fg1, colors.color5, true);
add_hi('StatuslineInactiveAccent', colors.fg1, colors.color2, false);
add_hi('StatuslineInsertAccent', colors.fg1, colors.color6, true);
add_hi('StatuslineReplaceAccent', colors.fg1, colors.color7, true);
add_hi('StatuslineTerminalAccent', colors.fg1, colors.color8, true);
add_hi('StatuslineVisualAccent', colors.fg1, colors.color9, true);

add_hi('StatuslineLSPErrors', colors.color9, colors.color10, true);
add_hi('StatuslineLSPWarns', colors.color7, colors.color10, true);
add_hi('StatuslineLSPInfo', colors.color5, colors.color10, true);
add_hi('StatuslineLSPHint', colors.fg2, colors.color10, true);

add_hi('StatuslineMiscAccent', colors.fg1, colors.color11, true);
add_hi('StatuslineFilenameModified', colors.color5, colors.color10, true);
add_hi('StatuslineFilenameNoMod', colors.fg2, colors.color10, false);
add_hi('StatuslineLineCol', colors.fg1, colors.color4, false);
add_hi('StatuslineFileEncoding', colors.fg2, colors.color10, false);
add_hi('StatuslineFiletype', colors.fg2, colors.color10, false);

local function update_colors(mode)
    local mode_color = 'StatuslineMiscAccent'
    if mode == 'n' then
        mode_color = 'StatuslineNormalAccent'
    elseif mode == 'c' then
        mode_color = 'StatuslineCommandAccent'
    elseif mode == 'i' then
        mode_color = 'StatuslineInsertAccent'
    elseif mode == 'R' then
        mode_color = 'StatuslineReplaceAccent'
    elseif mode == 't' then
        mode_color = 'StatuslineTerminalAccent'
    elseif mode:lower() == 'v' then
        mode_color = 'StatuslineVisualAccent'
    else
        mode_color = 'StatuslineMiscAccent'
    end

    local filename_color
    if vim.bo.modified then
        filename_color = 'StatuslineFilenameModified'
    else
        filename_color = 'StatuslineFilenameNoMod'
    end

    return mode_color, filename_color
end

local function path()
    local base_name = vim.fn.expand('%:t')
    local path_head = vim.fn.expand('%:h')

    if path_head == '/' then
        return '/' .. base_name
    end

    return vim.fn.pathshorten(path_head) .. '/' .. base_name
end

local function set_modified_symbol(modified) return modified and ' [+]' or ''; end

local function get_paste() return vim.o.paste and 'PASTE ' or '' end

local function get_readonly_space()
    return ((vim.o.paste and vim.bo.readonly) and ' ' or '') and '%r' ..
               (vim.bo.readonly and ' ' or '')
end

-- Returns the 'fileencoding'.
local function file_encoding_format()
    local fileencoding = vim.bo.fileencoding
    local fileformat = vim.bo.fileformat;
    if #fileencoding > 0 and #fileformat > 0 then
        return table.concat {fileencoding, '[', fileformat, ']', ' | '}
    end
    return ''
end

local statusline_format = table.concat {
    '%%#%s# %s ', -- mode
    '%%#StatuslineSecondaryAccent#%s', -- vcs
    '%%#%s#%s %s%%#%s#', -- path
    '%s %s', -- paste, readonly
    '%%=',
    '%%#StatuslineLSPErrors#✘ %s ', -- lsp diagnostics errors
    '%%#StatuslineLSPWarns# %s ', -- lsp diagnostics warnings
    '%%#StatuslineLSPInfo# %s ', -- lsp diagnostics info
    '%%#StatuslineLSPHint# %s', -- lsp diagnostics hints
    '%%=',
    '%%#StatuslineFileEncoding#%s', -- encoding
    '%%#StatuslineFiletype#%s ', -- filetype
    '%%#StatuslineLineCol#%s', -- line_col
}

local function status()
    local mode = vim.fn.mode()
    local mode_color, filename_color = update_colors(mode)
    local filename = path()
    local line_col = '  %l/%c  '
    local err, warn, info, hint = lsp_status()

    return string.format(
               statusline_format, mode_color, get_mode(mode), vcs(),
               filename_color, set_modified_symbol(vim.bo.modified), filename,
               filename_color, get_paste(), get_readonly_space(), err, warn,
               info, hint, file_encoding_format(), vim.bo.filetype, line_col
           )
end

local function update()
    for _ in vim.fn.winnr('$') do vim.wo.statusline = status() end
end

return {status = status, update = update}
