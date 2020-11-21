let b:ale_linters = ['eslint']
let b:ale_fixers = ['prettier', 'eslint']

" Excute javascript files
nnoremap <Leader>ejs :!node %<CR>
