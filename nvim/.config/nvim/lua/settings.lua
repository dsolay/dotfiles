local o, wo, bo = vim.o, vim.wo, vim.bo
local utils = require('utils')
local opt = utils.opt

-- Settings
local buffer = {o, bo}
local window = {o, wo}
opt('syntax', 'off')
opt('textwidth', 80, buffer)
opt('scrolloff', 1)
opt('sidescroll', 5)
opt(
    'wildignore',
    '**/node_modules/**,**/dist/**,**_site/**,*.swp,*.png,*.jpg,*.gif,*.webp,*.jpeg,*.map,*.o,*~,*.pyc'
)
opt('wildmode', 'longest,full')
opt('inccommand', 'nosplit')
opt('showmatch', true)
opt('ignorecase', true)
opt('smartcase', true)
opt('tabstop', 2, buffer)
opt('softtabstop', 2, buffer)
opt('expandtab', true, buffer)
opt('shiftwidth', 2, buffer)
opt('number', true, window)
opt('relativenumber', true, window)
opt('shada', [['20,<50,s10,h,/100]])
opt('hidden', true)
opt('shortmess', o.shortmess .. 'c')
opt('completeopt', 'menuone,noselect')
opt('joinspaces', false)
opt('guicursor', [[n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50]])
opt('updatetime', 300)
opt('conceallevel', 0, window)
opt('concealcursor', 'nc', window)
opt('previewheight', 5)
opt('undofile', true, buffer)
opt('synmaxcol', 500, buffer)
opt('display', 'msgsep')
opt('modeline', false, buffer)
opt('mouse', 'nivh')
opt('signcolumn', 'yes:1', window)
opt('writebackup', false)
opt('fixendofline', false)
opt('list', true, window)
opt(
    'listchars', [[tab:→\ ,eol:¬,nbsp:␣,trail:•,precedes:«,extends:»]],
    window
)
opt('foldlevelstart', 99)
opt('foldmethod', 'expr')
opt('clipboard', 'unnamed,unnamedplus')
opt('splitbelow', true)
opt('splitright', true)
opt('wrap', false)
opt('shiftround', true)
opt('laststatus', 2)
opt('autoindent', true, buffer)
opt('colorcolumn', '+1', window)
opt('termguicolors', true)
opt('background', 'dark')
opt('lazyredraw', true)
opt('linebreak', true, window)
opt('wrap', true, window)
opt('breakindent', true, window)

-- Use rigrep if installed
if vim.fn.executable('rg') == 1 then
    opt('grepprg', [[rg --vimgrep --smart-case --follow --no-heading]])
    opt('grepformat', [[%f:%l:%c:%m,%f:%l:%m]])
end
