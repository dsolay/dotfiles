let b:ale_linters = ['flake8', 'pylint']
let b:ale_fixers = ['black']

" Excute python files
nnoremap <Leader>epy :!python %<CR>
