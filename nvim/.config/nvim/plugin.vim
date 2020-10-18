" This file contains configurations which are specific to the plugins
" loaded. Its in a seperate file since these need to be places after the
" plug#end call.

" Syntax
Plug 'sheerun/vim-polyglot'           " Syntax Highlighting And Indentation For 100+ Languages

" Status bar
Plug 'vim-airline/vim-airline'        " Unfortunately, neovim doesn't support bindeval, so I can't use powerline.

" Themes
Plug 'morhetz/gruvbox'                " Download a better colorscheme
Plug 'vim-airline/vim-airline-themes' " Download powerline theme for the statusbar.

" Tree
Plug 'preservim/nerdtree'             " Better file system browser
Plug 'Xuyuanp/nerdtree-git-plugin'    " Nerdtree git support!

" Typing
Plug 'chun-yang/auto-pairs'           " Inserts quotes and parenthesis in pairs as you type.
Plug 'tpope/vim-surround'             "  The plugin provides mappings to easily delete, change and add such surroundings in pairs.

" Tmux
Plug 'tmux-plugins/vim-tmux-focus-events' " FocusGained and FocusLost autocommand events in terminal vim when using inside Tmux.

" Autocomplete
Plug 'vim-scripts/dbext.vim'                    " Required for sql completion.
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Make your Vim/Neovim as smart as VSCode.
Plug 'mattn/emmet-vim'                          " Emmet extension

" Test
Plug 'janko-m/vim-test'               " Run tests straight from vim.

" IDE
Plug 'vim-scripts/BufOnly.vim'        " Adds the ability to close all except the current buffer
Plug 'w0rp/ale'                       " Async linter!
Plug 'AndrewRadev/linediff.vim'       " Allows to diff a visual selection.
Plug 'preservim/nerdcommenter'        " Toggle comments
Plug 'editorconfig/editorconfig-vim'  " Editorconfig
Plug 'kkoomen/vim-doge'               " Documentation generator
Plug 'honza/vim-snippets'             " Snippets files for various programming languages.
Plug 'ludovicchabant/vim-gutentags'   " Gutentags is a plugin that takes care of the much needed management of tags files in Vim
Plug 'ryanoasis/vim-devicons'         " files icons
Plug 'yggdroot/indentline'            " Display the identation levels with thin vertical lines.
Plug 'mg979/vim-visual-multi', {'branch': 'master'} " Multiple cursors/selections
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fuzzy search

" Git
Plug 'tpope/vim-fugitive'             " Allows you to run git commands from vim
Plug 'christoomey/vim-conflicted'     " Easy git merge conflict resolution in vim
Plug 'airblade/vim-gitgutter'         " shows a git diff in the sign column