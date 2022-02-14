local cmd = vim.cmd
local o_s = vim.o
local map_key = vim.api.nvim_set_keymap
local fn = vim.fn;

local function opt(o, v, scopes)
    scopes = scopes or {o_s}
    for _, s in ipairs(scopes) do s[o] = v end
end

local function autocmd(group, cmds, clear)
    clear = clear == nil and false or clear
    if type(cmds) == 'string' then cmds = {cmds} end
    cmd('augroup ' .. group)
    if clear then cmd [[au!]] end
    for _, c in ipairs(cmds) do cmd('autocmd ' .. c) end
    cmd [[augroup END]]
end

local function map(modes, lhs, rhs, opts)
    opts = opts or {}
    opts.noremap = opts.noremap == nil and true or opts.noremap
    if type(modes) == 'string' then modes = {modes} end
    for _, mode in ipairs(modes) do map_key(mode, lhs, rhs, opts) end
end

local function add_hi(hi_name, fg, bg, bold)
    local hi = string.format(
                   'hi %s guifg=%s guibg=%s gui=%s', hi_name, fg, bg,
                   bold and 'bold' or 'none'
               )

    cmd(hi)
end

local function file_exists(path)
    return fn.system('test -f ' .. path .. ' && echo 1') == '1\n'
end

local function includes(tab, val)
    for _, value in ipairs(tab) do if value == val then return true end end

    return false
end

return {
    opt = opt,
    autocmd = autocmd,
    map = map,
    add_hi = add_hi,
    file_exists = file_exists,
    includes = includes,
}
