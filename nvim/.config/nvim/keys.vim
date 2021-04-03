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

" turn off search highlights
nnoremap <leader><space> :nohlsearch<CR>

" Create file under cursor
:map <leader>gf :e <cfile><cr>

" Move lines
nnoremap <S-Up>     :m-2<CR>
nnoremap <S-Down>   :m+<CR>
inoremap <S-Up>     <Esc>:m-2<CR>i
inoremap <S-Down>   <Esc>:m+<CR>i

"split navigations
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>

" Enable folding with the spacebar
nnoremap <space> za

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

"nnoremap <C-left>   :tabprevious<CR>
"nnoremap <C-right>  :tabnext<CR>
"nnoremap <C-t>      :tabnew<CR>
"nnoremap <leader>w  :tabclose<CR>

" Enable Buffer navigation like firefox
nnoremap  <C-left>          :bp<CR>
nnoremap  <C-right>         :bn<CR>
noremap   <A-q>             :bd<CR>
inoremap  <C-left>          <Esc>:bp<CR>i
inoremap  <C-right>         <Esc>:bn<CR>i
inoremap  <A-q>             <Esc>:bd<CR>

" Show a list of all open buffers
nnoremap <Leader>bb :buffers<CR>:b<space>

" toggles between the current and most recently used buffers
nnoremap <S-tab> :b#<CR>

nnoremap n nzz
nnoremap N Nzz

" Multiple replace with s*
" hit . to repeatedly replace a change to the word under the cursor
nnoremap <silent> s* :let @/='\<'.expand('<cword>').'\>'<CR>cgn
xnoremap <silent> s* "sy:let @/=@s<CR>cgn

vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

vnoremap <leader>d c<c-r>=system('base64 --decode', @")<CR><ESC>
vnoremap <leader>e c<c-r>=system('base64', @")<CR><ESC>

" Resize buffer
noremap <silent> <C-S-Left> :vertical resize -5<CR>
noremap <silent> <C-S-Right> :vertical resize +5<CR>
noremap <silent> <C-S-Up> :resize +5<CR>
noremap <silent> <C-S-Down> :resize -5<CR>

" Session
nnoremap <Leader>s :mksession ~/.nvim/sessions/
nnoremap <Leader>os :source ~/.nvim/sessions/

" Replace word
nnoremap <Leader>rw :%s/<C-R>=expand('<cword>')<CR>/
