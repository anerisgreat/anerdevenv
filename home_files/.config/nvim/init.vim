set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'itchyny/lightline.vim'
Plugin 'airblade/vim-gitgutter'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

set tabstop=4
set number relativenumber

set laststatus=2
set noshowmode

:nnoremap <C-c> :call<SID>LongLineHLToggle()<cr>
hi OverLength ctermbg=none cterm=none
match OverLength /\%>80v/
fun! s:LongLineHLToggle()
	if !exists('w:longlinehl')
		let w:longlinehl = matchadd('ErrorMsg', '.\%>80v', 0)
	else
		call matchdelete(w:longlinehl)
		unl w:longlinehl
	endif
endfunction

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
