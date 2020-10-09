" Run both javascript and vue linters for vue files.
let b:ale_linter_aliases = ['typescript', 'javascript', 'vue', 'css']

" Select the eslint and vls linters.
let b:ale_linters = ['eslint', 'vls', 'stylelint', 'tsserver']

" Fix files with prettier, and then ESLint.
let b:ale_fixers = ['prettier', 'eslint']
