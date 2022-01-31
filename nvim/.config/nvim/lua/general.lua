local g = vim.g
local utils = require('utils')
local autocmd = utils.autocmd

-- Leader/local leader
g.mapleader = [[,]]
-- g.maplocalleader = [[,]]

-- Skip some remote provider loading
g.loaded_python_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0

g.python_host_prog = '/usr/bin/python2'
g.python3_host_prog = '/usr/bin/python3'

-- Disable some built-in plugins we don't want
local disabled_built_ins = {
    'gzip',
    'man',
    'matchit',
    'matchparen',
    'shada_plugin',
    'tarPlugin',
    'tar',
    'zipPlugin',
    'zip',
    'netrwPlugin',
}
for i = 1, 10 do g['loaded_' .. disabled_built_ins[i]] = 1 end

autocmd(
    'misc_aucmds', {
        [[BufWinEnter * checktime]],
        [[TextYankPost * silent! lua vim.highlight.on_yank()]],
    }, true
)

-- Highlight line only in current window
autocmd(
    'CursorLine', {
        [[VimEnter,WinEnter,BufWinEnter * setlocal cursorline]],
        [[WinLeave * setlocal nocursorline]],
    }, true
)

-- Return to last edit position when opening files (You want this!)
autocmd('preserve_last_position', [[BufReadPost * lua Goto_last_pos()]])

function Goto_last_pos()
    local last_pos = vim.fn.line('\'"')
    if last_pos > 0 and last_pos <= vim.fn.line('$') then
        vim.api.nvim_win_set_cursor(0, {last_pos, 0})
    end
end

-- Enable q to quit file
autocmd('helpfiles', [[FileType help nnoremap q :q<CR>]])

-- Load environment in .env file
autocmd(
    'dotenv', [[VimEnter * if exists(':Dotenv') | exe 'Dotenv! ./' | endif]],
    true
)

-- Compile packer when plugins.lua file change
autocmd(
    'packer_user_config',
    [[BufWritePost plugins.lua source <afile> | PackerCompile]], true
)

