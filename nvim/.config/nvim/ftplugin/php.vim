" Linter
let b:ale_linters = ['php', 'phpstan']

" Fixers
let b:ale_fixers = ['php-cs-fixer']

"
" ~~ Vim PHP refactoring toolbox ~~
"

let g:vim_php_refactoring_default_property_visibility = 'private'
let g:vim_php_refactoring_default_method_visibility = 'private'
let g:vim_php_refactoring_auto_validate_visibility = 1
"let g:vim_php_refactoring_phpdoc = "pdv#DocumentCurrentLine"
