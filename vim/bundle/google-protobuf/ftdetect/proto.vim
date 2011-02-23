augroup filetype
  au! BufRead,BufNewFile *.proto setfiletype proto
  au FileType proto setl noexpandtab shiftwidth=4 softtabstop=4 tabstop=4
augroup end
