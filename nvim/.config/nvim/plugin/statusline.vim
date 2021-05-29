scriptencoding utf-8
set noshowmode
set laststatus=2

" Setup the colors
" function! s:setup_colors() abort
"   hi StatuslineTS guibg=#3a3a3a gui=none guifg=#878787
" endfunction

" augroup statusline_colors
"   au!
"   au ColorScheme * call s:setup_colors()
" augroup END

" call s:setup_colors()

au VimEnter * ++once lua statusline = require('statusline')
au VimEnter * ++once lua vim.o.statusline = '%!v:lua.statusline.status()'
