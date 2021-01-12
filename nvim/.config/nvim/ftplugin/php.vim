" Linter
let b:ale_linters = ['phpstan']

" Fixers
let b:ale_fixers = ['prettier', 'php_cs_fixer']

let g:ale_php_phpstan_executable = system('if ! type git &> /dev/null; then echo phpstan; else PSE=`git rev-parse --show-toplevel 2> /dev/null`/vendor/bin/phpstan; if [ -x "$PSE" ]; then echo -n $PSE; else echo phpstan; fi; fi')
