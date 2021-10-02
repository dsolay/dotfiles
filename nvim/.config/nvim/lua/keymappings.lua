local utils = require('utils')
local map = utils.map

local opts = {silent = true}

-- Show help under the cursor
map('n', '<leader>h', ':help <c-r><c-w><cr>', opts)

-- Save buffer
map('n', '<F2>', '<cmd>update<cr>', opts)
map('i', '<c-s>', '<cmd>update<cr>', opts)

-- Select all
map('n', '<leader><c-e>', 'ggVG', opts)

-- Multiple replace with s*
-- hit . to repeatedly replace a change to the word under the cursor
map('n', 's*', [[<cmd>let @/=expand('<cword>')<cr>cgn]], opts)

-- Search and replace
map('n', '<leader>rw', ':%s/<C-R>=expand(\'<cword>\')<cr>/')
map(
    'n', '<C-f>',
    [[<cmd>execute "grep " . "\"". expand("<cword>") . "\" " . finddir('.git/..', expand('%:p:h').';') <Bar> TroubleToggle quickfix<cr>]]
)

-- Search word under the cursosr
-- Make * stay at the cursor position
map('n', '*', [[m`:keepjumps normal! *``<cr>]], opts)

-- Search for visually selected text
map('v', '*', [[y/\V<C-R>=escape(@",'/\')<CR><CR>]])

-- Clear search register
map('', '<leader><esc>', [[<cmd>let @/=""<cr>]], opts)

-- Quit, close buffers, etc.
map('n', '<leader>q', '<cmd>qa<cr>', opts)
map('n', '<leader>x', '<cmd>q!<cr>', opts)
map('n', '<leader>X', '<cmd>x!<cr>', opts)

-- Esc in the terminal
map('t', '<esc>', [[<C-\><C-n>]])

-- Window movement
map('n', '<c-h>', '<c-w>h', opts)
map('n', '<c-j>', '<c-w>j', opts)
map('n', '<c-k>', '<c-w>k', opts)
map('n', '<c-l>', '<c-w>l', opts)

-- Move lines
map('n', '<S-Up>', '<cmd>m-2<cr>', opts)
map('n', '<S-Down>', '<cmd>m+<cr>', opts)
map('i', '<S-Up>', '<cmd>m-2<cr>', opts)
map('i', '<S-Down>', '<cmd>m+<cr>', opts)

-- Enable Buffer navigation like firefox
map('n', '<c-left>', '<cmd>bp<cr>', opts)
map('n', '<c-right>', '<cmd>bn<cr>', opts)
map('n', '<A-q>', '<cmd>bd<cr>', opts)
map('i', '<c-left>', '<cmd>bp<cr>', opts)
map('i', '<c-right>', '<cmd>bn<cr>', opts)
map('i', '<A-q>', '<cmd>bd<cr>', opts)

-- Resize buffer
map('', '<C-S-Left>', '<cmd>vertical resize -5<cr>', opts)
map('', '<C-S-Right>', '<cmd>vertical resize +5<cr>', opts)
map('', '<C-S-Up>', '<cmd>resize +5<cr>', opts)
map('', '<C-S-Down>', '<cmd>resize -5<cr>', opts)

-- Spell
map('n', '<F7>', ':setlocal spell! spelllang=es<cr>', opts)
map('i', '<F7>', '<C-o>:setlocal spell! spelllang=es<cr>', opts)

-- Current path
map('n', '<leader>pwd', '<cmd>echo expand(\'%\')<cr>')
map('i', '<F11>', [[<esc>:echo expand('%')<cr>i]])

-- Back to last cursosr position
map('n', '<BS>', [[g`']], opts)

-- Remove the last line
map('n', '$d', [[:$d<cr>]])
