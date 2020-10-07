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

" Adds the ability to close all except the current buffer
Plug 'vim-scripts/BufOnly.vim'

" Unfortunately, neovim doesn't support bindeval, so I can't use powerline.
Plug 'vim-airline/vim-airline'

" Download powerline theme for the statusbar.
Plug 'vim-airline/vim-airline-themes'

" Async linter!
Plug 'w0rp/ale'

" Required for sql completion
Plug 'vim-scripts/dbext.vim'

" Allows to diff a visual selection.
Plug 'AndrewRadev/linediff.vim'

" Toggle comments
Plug 'preservim/nerdcommenter'

" shows a git diff in the sign column
Plug 'airblade/vim-gitgutter'

" Editorconfig
Plug 'editorconfig/editorconfig-vim'

" Documentation generator
Plug 'kkoomen/vim-doge'

" Inserts quotes and parenthesis in pairs as you type
Plug 'chun-yang/auto-pairs'

" Easy git merge conflict resolution in vizm
Plug 'christoomey/vim-conflicted'

" files icons
Plug 'ryanoasis/vim-devicons'

" Use release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
