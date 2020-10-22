" Disallow detection of filetypes
filetype off

filetype plugin indent on    " required
runtime macros/matchit.vim

syntax enable

if (has("termguicolors"))
  " This is only necessary if you use \"set termguicolors".
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" fixes glitch? in colors when using vim with tmux
set background=dark
set t_Co=256

" #TEMPLATES {{{
" Prefill new files created by vim with contents from the following templates
augroup templatesRead
  autocmd!
  autocmd BufRead *.html,*.scss,*.css,*.rs,*.vue,LICENCE,LICENSE,.gitignore,.stylelintrc.json,eslintrc.json,.prettierrc.json call s:ApplyTemplate()

  function! s:ApplyTemplate()
    if getfsize(expand('%')) == 0
      execute "0r ~/.config/nvim/templates/skeleton." . expand('%:e')
    endif
  endfun
augroup END

augroup templatesNew
  autocmd BufNewFile *.html             0r ~/.config/nvim/templates/skeleton.html
  autocmd BufNewFile *.scss             0r ~/.config/nvim/templates/skeleton.scss
  autocmd BufNewFile *.css              0r ~/.config/nvim/templates/skeleton.scss
  autocmd BufNewFile *.rs               0r ~/.config/nvim/templates/skeleton.rs
  autocmd BufNewFile *.vue              0r ~/.config/nvim/templates/skeleton.vue
  autocmd BufNewFile LICENCE            0r ~/.config/nvim/templates/skeleton.LICENCE
  autocmd BufNewFile LICENSE            0r ~/.config/nvim/templates/skeleton.LICENCE
  autocmd BufNewFile .gitignore         0r ~/.config/nvim/templates/skeleton.gitignore
  autocmd BufNewFile .stylelintrc.json  0r ~/.config/nvim/templates/skeleton.stylelintrc
  autocmd BufNewFile .eslintrc.json     0r ~/.config/nvim/templates/skeleton.eslintrc
  autocmd BufNewFile .prettierrc.json   0r ~/.config/nvim/templates/skeleton.prettierrc
augroup END
"}}}

" Highlight line only in crrent window
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" Stop concealing quotes in JSON
let g:vim_json_syntax_conceal = 0

" Enable JSX syntax highlighting in .js files
let g:jsx_ext_required = 0

" More natural split opening.
set splitbelow
set splitright

" Show leader key
set showcmd

" #TABS AND SPACES {{{
set expandtab " On pressing tab, insert 2 spaces
set tabstop=2 " show existing tab with 2 spaces width
set softtabstop=2
set shiftwidth=2 " when indenting with '>', use 2 spaces width
"}}}

" set noswapfile " No swap file
set directory^=$HOME/.vim/tmp//
set nobackup
set nowritebackup

set textwidth=120
set linebreak
set wrap
set formatoptions+=t
set colorcolumn=+1
set showmatch
set lazyredraw

" #FINDING FILES
" Use the `:find` command to fuzzy search files in the working directory
" The `:b` command can also be used to do the same for open buffers

" Search all subfolders
set path+=**

" Display matching files on tab complete
set wildmenu

" Ignore node_modules and images from search results
set wildignore+=**/node_modules/**,**/dist/**,**_site/**,*.swp,*.png,*.jpg,*.gif,*.webp,*.jpeg,*.map

" Use the system register for all cut yank and paste operations
set clipboard+=unnamedplus

" Toggle Hybrid Numbers in insert and normal mode
set number
set relativenumber

" Show Invisibles
set list
set listchars=tab:→\ ,eol:¬,nbsp:␣,trail:•,precedes:«,extends:»

" Automatically hide buffer with unsaved changes without showing warning
set hidden

" Treat all numbers as decimal regardless of whether they are padded with zeros
set nrformats=

" Highlight matches when using :substitute
set hlsearch

" Predicts case sensitivity intentions
set smartcase

" Enable mouse
set mouse=a

" Let the linter / formatter take care of additional line breaks and the end
" of the file.
set nofixendofline

" Activate persistent undo
if has('persistent_undo')
  set undodir=$HOME/.vim/undo
  set undofile
endif

" Folds start as opened instead of closed
set foldlevelstart=99

" Enable folds that are for the most part placed in the comments.
set foldmethod=marker

" Jump to match when searching
set incsearch

set updatetime=300

" Give more space for displaying messages.
set cmdheight=2

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Enable word completion
set complete+=kspell

" Strip trailing whitespace from all files
"autocmd BufWritePre * %s/\s\+$//e
"autocmd BufWritePre * %s/\s\+$//e
"autocmd BufWritePre * %s/\s\+$//e

" Automatically remove the preview window after autocompletion
autocmd CompleteDone * pclose

"au BufRead,BufNewFile,BufReadPost *.json set syntax=json

" Spell checking for markdown files
autocmd BufRead,BufNewFile *.md setlocal spell

" #RIPGREP {{{
if executable("rg")
    set grepprg=rg\ --vimgrep\ --smart-case\ --follow\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif
" }}}

augroup preserve_last_position
  " Return to last edit position when opening files (You want this!)
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END

augroup helpfiles
  " Enable q to quit file
  autocmd FileType help nnoremap q :q<CR>
augroup END

function! CmdLine(str)
  exe 'menu Foo.Bar :' . a:str
  emenu Foo.Bar
  unmenu Foo
endfunction

function! VisualSelection(direction, extra_filter) range
  let l:saved_reg = @"
  execute 'normal! vgvy'

  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", '', '')

  if a:direction ==# 'gv'
    call CmdLine("Ag \"" . l:pattern . "\" " )
  elseif a:direction ==# 'replace'
    call CmdLine('%s' . '/'. l:pattern . '/')
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction
