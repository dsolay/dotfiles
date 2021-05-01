" Get absolute path of the directory of the current file
let s:init_vim_dir = expand('<sfile>:p:h')
let s:nvim_version = api_info().version
if s:nvim_version.minor == 5
  lua require('config')
else
  execute("source " . s:init_vim_dir . "/stable/init.vim")
endif
