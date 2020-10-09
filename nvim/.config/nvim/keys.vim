" Change leader key from \ to ,
let mapleader = ","

" Reload vim configuration
nnoremap <Leader>sv :source $MYVIMRC<CR>

" Disable F1 bringing up the help doc every time
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" A saner way to save files.<F2> is easy to press
nnoremap <F2> :w<CR>
inoremap <C-s> <Esc>:w<CR>i

inoremap <S-Tab> <C-d>

" Select all
nnoremap <Leader><C-e> ggVG

" fix indentation
nnoremap <Leader>fi gg=G

" Clear search
noremap <silent> <Leader><ESC> :let @/ = ""<CR>

" MOVING LINES
" Normal mode
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==

" Visual mode
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" Shortcut to open init.vim
nnoremap <leader>ev :vsp $MYVIMRC<CR>

" Save state of open Windows and Buffers
nnoremap <leader>s :mksession<CR>

" turn off search highlights
nnoremap <leader><space> :nohlsearch<CR>

" Reload Vim config
nnoremap <Leader>r :so ~/.config/nvim/init.vim<CR>

" Create file under cursor
:map <leader>gf :e <cfile><cr>

" Move lines
nnoremap <S-Up>     :m-2<CR>
nnoremap <S-Down>   :m+<CR>
inoremap <S-Up>     <Esc>:m-2<CR>i
inoremap <S-Down>   <Esc>:m+<CR>i

" Switching tabs quickly
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>

nnoremap <C-left>   :tabprevious<CR>
nnoremap <C-right>  :tabnext<CR>
nnoremap <C-t>      :tabnew<CR>
nnoremap <leader>w  :tabclose<CR>

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

nnoremap n nzz
nnoremap N Nzz
