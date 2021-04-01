" Linters
let b:ale_linters = ['eslint', 'tsserver', 'typecheck']

" Fix files with prettier, and then ESLint.
let b:ale_fixers = ['prettier', 'eslint']

"
let g:ale_typescript_prettier_use_local_config = 1
