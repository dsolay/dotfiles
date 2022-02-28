" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
setlocal shellslash

" this is mostly a matter of taste. but LaTeX looks good with just a bit
" of indentation.
setlocal sw=2

" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
setlocal iskeyword+=:
