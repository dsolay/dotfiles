

" ~                                     ~ "
" ~ NodeJS-Focused Neovim Configuration ~ "
" ~ By: Jonathan Boudreau               ~ "
" ~                                     ~ "

"
" ~~ Plugin Load ~~
"

call plug#begin("~/.config/nvim/plugged")

source ~/.config/nvim/plugin.vim

call plug#end()

"
" ~~ General Configurations ~~
"

" don't convert tabs to spaces
set noexpandtab

" Set tabs to take two character spaces
set tabstop=2

" Set how many characters indentation should be. This will ensure that you're
" using tabs, not spaces.
set shiftwidth=2

" Add the column number
set ruler

" Display the row numbers (line number)
set relativenumber

" Make the line number show up in the gutter instead of just '0'.
set number

" Add a bar on the side which delimits 80 characters.
set colorcolumn=120

" 72 characters makes it easier to read git log output.
autocmd Filetype gitcommit setl colorcolumn=72

" Will search the file as you type your query
set incsearch

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" This will close the current buffer without closing the window
command Bd bp|bd #

" Enable clipboard. Can use x11 forwarding or socket mounting to
" make host clipboard accessible by the container.
set clipboard+=unnamedplus

" Using the blazing fast ag search tool for lgrep calls instead.
set grepprg=ag\ --nogroup\ --nocolor

" For some reason the mouse isn't enabled by default anymore...
set mouse=a

" Annnd, load the plugin-specific configurations.
source ~/.config/nvim/post-plugin.vim

" Folds start as opened instead of closed
set foldlevelstart=99

" Enable folds that are for the most part placed in the comments.
set foldmethod=marker

" Let the linter / formatter take care of additional line breaks and the end
" of the file.
set nofixendofline

" Set system clipboard as default
set clipboard=unnamedplus

" Opening a new file when the current buffer has unsaved changes causes files to be hidden instead of closed
set hidden

" Linebreak on 500 characters
set linebreak

" Show special characters
set list

" Wrap lines
set wrap

" Activate persistent undo
if has('persistent_undo')
  set undodir=$HOME/.vim/undo
  set undofile
endif

set wildignore=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,_build,*.o,*~,*.pyc | " Ignore version control and os files
" set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»  | " Show special characters
set listchars=tab:\|\ ,nbsp:␣,trail:•,precedes:«,extends:»  | " Show special characters

" Set leader key
let mapleader = ","

" Save changes
inoremap <C-s> <Esc>:w<CR>i

" Select all
nnoremap <Leader><C-e> ggVG

" fix indentation
nnoremap <Leader>fi gg=G

" Clear search
noremap <silent> <Leader><ESC> :let @/ = ""<CR>

" Go to the nth tabpage
nnoremap <A-F1> 1gt
nnoremap <A-F2> 2gt
nnoremap <A-F3> 3gt
nnoremap <A-F4> 4gt
nnoremap <A-F5> 5gt
nnoremap <A-F6> 6gt
nnoremap <A-F7> 7gt
nnoremap <A-F8> 8gt
nnoremap <A-F9> 9gt
nnoremap <A-F10> 10gt

" Enable Buffer navigation like firefox
nnoremap  <Leader><S-tab>   :bp<CR>
nnoremap  <S-tab>           :bn<CR>
noremap   <A-q>             <Esc>:bd<CR>
inoremap  <Leader><S-tab>   <Esc>:bp<CR>i
inoremap  <S-tab>           <Esc>:bn<CR>i
inoremap  <A-q>             <Esc>:bd<CR>

" Show a list of all open buffers
nnoremap <Leader>bb :buffers<CR>:b<space>

" toggles between the current and most recently used buffers
nnoremap <Leader><tab> :b#<CR>

" Zoom window split
nnoremap Zz <silent> :NERDTreeClose<CR> <bar> <c-w>_ <bar> <c-w><bar>
nnoremap Zo <c-w>= <bar> :T<CR>

"
nnoremap <Leader><Down><Down> :! tmux select-pane -t 2<CR>
nnoremap <Leader>ga :! tmux split-window -h \; send-keys "ga" Enter<CR>

" Multiple replace with s*
" hit . to repeatedly replace a change to the word under the cursor
nnoremap <silent> s* :let @/='\<'.expand('<cword>').'\>'<CR>cgn
xnoremap <silent> s* "sy:let @/=@s<CR>cgn

vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

vnoremap <leader>d c<c-r>=system('base64 --decode', @")<cr><esc>
vnoremap <leader>e c<c-r>=system('base64', @")<cr><esc>

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
