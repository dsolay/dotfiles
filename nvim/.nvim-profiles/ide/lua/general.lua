-- Leader/local leader
vim.g.mapleader = [[,]]
-- g.maplocalleader = [[,]]

-- Skip some remote provider loading
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- g.python_host_prog = '/usr/bin/python2'
vim.g.python3_host_prog = '/usr/bin/python'

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
for i = 1, 10 do vim.g['loaded_' .. disabled_built_ins[i]] = 1 end

vim.api.nvim_create_augroup('misc_aucmds', {})

vim.api.nvim_create_autocmd(
    'BufWinEnter', {group = 'misc_aucmds', pattern = '*', command = 'checktime'}
)

vim.api.nvim_create_autocmd(
    'TextYankPost', {
        group = 'misc_aucmds',
        pattern = '*',
        command = [[silent! lua vim.highlight.on_yank()]],
    }
)

-- Highlight line only in current window
vim.api.nvim_create_augroup('CursorLine', {})

vim.api.nvim_create_autocmd(
    {'VimEnter', 'WinEnter', 'BufWinEnter'},
    {group = 'CursorLine', pattern = '*', command = [[setlocal cursorline]]}
)

vim.api.nvim_create_autocmd(
    'WinLeave',
    {group = 'CursorLine', pattern = '*', command = [[setlocal nocursorline]]}
)

-- Return to last edit position when opening files (You want this!)
local goto_last_pos = function()
    local last_pos = vim.fn.line('\'"')
    if last_pos > 0 and last_pos <= vim.fn.line('$') then
        vim.api.nvim_win_set_cursor(0, {last_pos, 0})
    end
end

vim.api.nvim_create_augroup('preserve_last_position', {})
vim.api.nvim_create_autocmd(
    'BufReadPost',
    {group = 'preserve_last_position', pattern = '*', callback = goto_last_pos}
)

-- Load environment in .env file
vim.api.nvim_create_augroup('dotenv', {})
vim.api.nvim_create_autocmd(
    'VimEnter', {
        group = 'dotenv',
        pattern = '*',
        command = [[if exists(':Dotenv') | exe 'Dotenv! ./' | endif]],
    }
)

-- Compile packer when plugins.lua file change
vim.api.nvim_create_augroup('packer_user_config', {})
vim.api.nvim_create_autocmd(
    'BufWritePost', {
        group = 'packer_user_config',
        pattern = 'plugins.lua',
        command = [[source <afile> | PackerCompile profile=true]],
    }
)
