setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4

lua require('cmp').setup.buffer({
\   sources = {
\     { name = 'nvim_lua' },
\     { name = 'buffer' },
\   },
\ })
