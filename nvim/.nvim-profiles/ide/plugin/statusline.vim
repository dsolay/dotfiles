scriptencoding utf-8
set noshowmode
set laststatus=2

au VimEnter * ++once lua statusline = require('statusline')
au VimEnter * ++once lua vim.o.statusline = '%!v:lua.statusline.status()'
