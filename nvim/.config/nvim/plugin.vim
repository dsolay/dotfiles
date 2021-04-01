" This file contains configurations which are specific to the plugins
" loaded. Its in a seperate file since these need to be places after the

" Syntax
Plug 'sheerun/vim-polyglot'                               " Syntax Highlighting And Indentation For 100+ Languages

" Status bar
Plug 'vim-airline/vim-airline'                            " Unfortunately, neovim doesn't support bindeval, so I can't use powerline.

" Themes
Plug 'sainnhe/gruvbox-material'                           " Gruvbox material color scheme

" Tree
Plug 'preservim/nerdtree'                                 " Better file system browser

" Typing
Plug 'chun-yang/auto-pairs'                               " Inserts quotes and parenthesis in pairs as you type.
Plug 'anyakichi/vim-surround'                             " Surround.vim is all about surroundings: parentheses, brackets, quotes, XML tags, and more.
Plug 'tpope/vim-repeat'                                   " Enable repeating supported plugin maps with '.'

" Autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}           " Make your Vim/Neovim as smart as VSCode.

" Test
Plug 'janko-m/vim-test'                                   " Run tests straight from vim.

" IDE
Plug 'w0rp/ale'                                           " Async linter!
Plug 'preservim/nerdcommenter'                            " Toggle comments
Plug 'honza/vim-snippets'                                 " Snippets files for various programming languages.
Plug 'ludovicchabant/vim-gutentags'                       " Gutentags is a plugin that takes care of the much needed management of tags files in Vim
Plug 'yggdroot/indentline'                                " Display the identation levels with thin vertical lines.
Plug 'mg979/vim-visual-multi', {'branch': 'master'}       " Multiple cursors/selections
Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }  " Documentation generator
Plug 'aperezdc/vim-template'                              " Allow you to have a set of templates for certain file types

" Debug
Plug 'vim-vdebug/vdebug',  { 'branch': 'master' }         " Debug

" Git
Plug 'kdheepak/lazygit.nvim', { 'branch': 'nvim-v0.4.3' } " Plugin for calling lazygit from within neovim.

" Productivity
Plug 'glidenote/memolist.vim'                             " This is a vimscript for create and manage memo.
Plug 'MattesGroeger/vim-bookmarks'                        " Allows toggling bookmarks per line