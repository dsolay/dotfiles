"
" ~~ Gruvbox theme ~~
"
set background=dark

let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_enable_bold = 1    " Enable bold in function name
let g:gruvbox_material_transparent_background = 1
let g:gruvbox_material_current_word = 'bold'
let g:gruvbox_material_background = 'soft'

" Load colors! On the initial install this will error out, so make it silent
" so it installs without issues.
silent! colorscheme gruvbox-material

"
" ~~ Airline ~~
"

" Enable the powerline fonts.
let g:airline_powerline_fonts = 1

" Show the buffers at the top
let g:airline#extensions#tabline#enabled = 1

" Show the buffer numbers so I can `:b 1`, etc
let g:airline#extensions#tabline#buffer_nr_show = 1

" Aside from the buffer number, I literally just need the file name, so
" strip out extraneous info.
let g:airline#extensions#tabline#fnamemod = ':t'

" disables the buffer name that displays on the right of the tabline
let g:airline#extensions#tabline#show_splits = 0

" Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1

" Set the theme for vim-airline
let g:airline_theme = 'gruvbox_material'

"
" ~~ NERDTree config ~~
"
"
let g:NERDTreeMouseMode = 3
let g:NERDTreeGitStatusShowIgnored = 1
let g:NERDTreeGitStatusConcealBrackets = 1
let g:NERDTreeGitStatusUseNerdFonts = 1

" Add a mapping for the NERDTree command, so you can just type :T to open
command! T NERDTree

" abbreviate T to t
cabbrev t T

" Use spaces instead just for yaml
autocmd Filetype yaml setl expandtab

" Toggle nerdtree
nnoremap <C-t> :NERDTreeToggle %<CR>

"
" ~~ nerdcommenter ~~
"
let g:ft = ''
function! NERDCommenter_before()
  if &ft == 'vue'
    let g:ft = 'vue'
    let stack = synstack(line('.'), col('.'))
    if len(stack) > 0
      let syn = synIDattr((stack)[0], 'name')
      if len(syn) > 0
        exe 'setf ' . substitute(tolower(syn), '^vue_', '', '')
      endif
    endif
  endif
endfunction
function! NERDCommenter_after()
  if g:ft == 'vue'
    setf vue
    let g:ft = ''
  endif
endfunction

"
" ~~ ALE config ~~
"

" Highlighting on top of the error gutter is a bit overkill...
let g:ale_set_highlights = 0

" ALE signs
let g:ale_sign_error = '✘'
let g:ale_sign_warning = ''
let g:ale_sign_info = ''

" disable linting while typing
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_save = 1
let g:ale_lint_delay = 0
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_open_list = 1
let g:ale_set_quickfix = 0
let g:ale_list_window_size = 5
let g:ale_fix_on_save = 1
let g:ale_disable_lsp = 1

" Only run linters named in ale_linters settings.
let g:ale_linters_explicit = 1

nnoremap <Leader>je :ALENext -wrap -error<CR>
nnoremap <Leader>jw :ALENext -wrap -warning<CR>
nnoremap <Leader>ji :ALENext -wrap -info<CR>
nnoremap <Leader>la :ALELint<CR>


"
" ~~ CoC config ~~
"

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <Leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <Leader>fo  <Plug>(coc-format-selected)
nmap <Leader>fo  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')


" Open coc action
nnoremap <C-p> :CocAction<CR>

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" Search
noremap <Leader>gs :CocSearch

" Reindex php file
nnoremap <Leader>ri :CocCommand intelephense.index.workspace<CR>

"
"	~~ ALE ~~
"
let g:ale_fixers = { '*': ['remove_trailing_lines', 'trim_whitespace'] }

"
" ~~ Vim doge ~~
"
noremap <Leader>dg :DogeGenerate

"
" ~~ fzf-preview ~~
"
nmap <Leader>f [fzf-p]
xmap <Leader>f [fzf-p]

nnoremap <silent> [fzf-p]d      :<C-u>CocCommand fzf-preview.DirectoryFiles<CR>
nnoremap <silent> [fzf-p]p      :<C-u>CocCommand fzf-preview.FromResources project_mru git<CR>
nnoremap <silent> [fzf-p]gs     :<C-u>CocCommand fzf-preview.GitStatus<CR>
nnoremap <silent> [fzf-p]ga     :<C-u>CocCommand fzf-preview.GitActions<CR>
nnoremap <silent> [fzf-p]b      :<C-u>CocCommand fzf-preview.Buffers<CR>
nnoremap <silent> [fzf-p]B      :<C-u>CocCommand fzf-preview.AllBuffers<CR>
nnoremap <silent> [fzf-p]o      :<C-u>CocCommand fzf-preview.FromResources buffer project_mru<CR>
nnoremap <silent> [fzf-p]<C-o>  :<C-u>CocCommand fzf-preview.Jumps<CR>
nnoremap <silent> [fzf-p]g;     :<C-u>CocCommand fzf-preview.Changes<CR>
nnoremap <silent> [fzf-p]/      :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
nnoremap <silent> [fzf-p]*      :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
nnoremap          [fzf-p]gr     :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
xnoremap          [fzf-p]gr     "sy:CocCommand   fzf-preview.ProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
nnoremap <silent> [fzf-p]t      :<C-u>CocCommand fzf-preview.BufferTags<CR>
nnoremap <silent> [fzf-p]q      :<C-u>CocCommand fzf-preview.QuickFix<CR>
nnoremap <silent> [fzf-p]l      :<C-u>CocCommand fzf-preview.LocationList<CR>
nnoremap <silent> [fzf-p]ml     :<C-u>CocCommand fzf-preview.MemoList<CR>
nnoremap <silent> [fzf-p]mg     :<C-u>CocCommand fzf-preview.MemoListGrep<Space>
nnoremap <silent> [fzf-p]bk     :<C-u>CocCommand fzf-preview.Bookmarks<CR>

"
" ~~ Lazygit ~~
"

nnoremap <silent> <Leader>lg :LazyGit<CR>

"
" ~~ vim-markdown ~~
"
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

" ~~ vdebug ~~
"
"
let g:vdebug_options = {}
let g:vdebug_options.port = 9003
"let g:vdebug_options.debug_file_level = 2
"let g:vdebug_options.debug_file = ~/.vdebug.log

let g:vdebug_keymap = {
    \    "run" : "<Leader>xs",
    \    "run_to_cursor" : "<S-F9>",
    \    "step_over" : "<S-F2>",
    \    "step_into" : "<S-F3>",
    \    "step_out" : "<S-F4>",
    \    "close" : "<S-F6>",
    \    "detach" : "<S-F7>",
    \    "set_breakpoint" : "<S-b>",
    \    "get_context" : "<S-c>",
    \    "eval_under_cursor" : "<Leader>xc",
    \    "eval_visual" : "<Leader>xv",
    \}

"
" ~~ vim-template ~~
"
nnoremap <Leader>lt :Template<CR>

"
" ~~ vim vue ~~
"
let g:vue_pre_processors = ['pug']

"
" ~~ Vim Template ~~
"

let g:templates_directory = ['/home/ernest/.config/nvim/templates']

"
" ~~ Memolist ~~
"
"
nnoremap <Leader>mn  :MemoNew<CR>
nnoremap <Leader>ml  :MemoList<CR>
nnoremap <Leader>mg  :MemoGrep<CR>

let g:memolist_prompt_tags = 1

"
" ~~ Vim Bookmarks ~~
"

let g:bookmark_sign = ''
let g:bookmark_annotation_sign = ''
let g:bookmark_save_per_working_dir = 1
let g:bookmark_auto_save = 1
