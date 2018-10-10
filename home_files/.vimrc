set tabstop=4
set number relativenumber
call matchadd('ColorColumn', '\%81v', 100)

set hlsearch

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

" Enter new line without entering INSERT mode
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>

:nnoremap s :exec "normal i".nr2char(getchar())."\e"<CR>
:nnoremap S :exec "normal a".nr2char(getchar())."\e"<CR>

"Visible whitespace
exec "set listchars=tab:>-,trail:\uB7,nbsp:~"
nmap <CR> o<Esc>
nnoremap <F3> :set list!<CR>


