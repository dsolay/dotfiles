  if exists("did_load_filetypes")
    finish
  endif
  augroup filetypedetect
    au! BufRead,BufNewFile *.env*       setfiletype env
    au! BufRead,BufNewFile *Dockerfile* setfiletype dockerfile
  augroup END
