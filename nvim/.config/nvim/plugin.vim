" This file contains configurations which are specific to the plugins
" loaded. Its in a seperate file since these need to be places after the
" plug#end call.

" Download a better colorscheme
Plug 'morhetz/gruvbox'

" Better file system browser
Plug 'preservim/nerdtree'

" Run tests straight from vim
Plug 'janko-m/vim-test'

" Nerdtree git support!
Plug 'Xuyuanp/nerdtree-git-plugin'

" Allows you to run git commands from vim
Plug 'tpope/vim-fugitive'

" Fuzzy file name searcher
Plug 'ctrlpvim/ctrlp.vim'

"Adds the ability to close all except the current buffer
Plug 'vim-scripts/BufOnly.vim'

" Unfortunately, neovim doesn't support bindeval, so I can't use powerline.
Plug 'vim-airline/vim-airline'

" Download powerline theme for the statusbar.
Plug 'vim-airline/vim-airline-themes'

" Async linter!
Plug 'w0rp/ale'

" Required for sql completion
Plug 'vim-scripts/dbext.vim'

" Better repl integration (sends selections to repl).
Plug 'jpalardy/vim-slime'

" Allows to diff a visual selection.
Plug 'AndrewRadev/linediff.vim'

" Git commit browser
Plug 'junegunn/gv.vim'

" Automatically clear search highlight
Plug 'junegunn/vim-slash'

" vscode autocmpletion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Toggle comments
Plug 'preservim/nerdcommenter'

" shows a git diff in the sign column
Plug 'airblade/vim-gitgutter'

" Editorconfig
Plug 'editorconfig/editorconfig-vim'

" Documentation generator
Plug 'kkoomen/vim-doge'
