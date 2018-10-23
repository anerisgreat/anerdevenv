"__VUNDLE_COPYPASTE_BEGIN_______________________________________________________
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"All plugins go here
Plugin 'VundleVim/Vundle.vim'
Plugin 'itchyny/lightline.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'scrooloose/nerdtree'
Plugin 'rafi/awesome-vim-colorschemes'

call vundle#end()            " required
filetype plugin indent on    " required

set number relativenumber

set laststatus=2
set noshowmode

"__VUNDLE_COPYPASTE_END_________________________________________________________

"Ctrl+C Highlights all text in line beyond column #80
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
"Highlight search results.
set hlsearch

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

" Enter new line without entering INSERT mode. 
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>

" Lower case 's' for inserting one character, upper case S for insert after.
:nnoremap s :exec "normal i".nr2char(getchar())."\e"<CR>
:nnoremap S :exec "normal a".nr2char(getchar())."\e"<CR>

"Visible whitespace
exec "set listchars=tab:>-,trail:\uB7,nbsp:~"
nnoremap <F3> :set list!<CR>

"Mapping NERDTree 'Ctrl+N' for showing menu. Copypasted.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
map <C-n> :NERDTreeToggle<CR>

let NERDTreeShowHidden=1

"Escaping character combo for quick switching.
set timeoutlen=1000 ttimeoutlen=0

"Default copypaste register set to clipboard.
set clipboard+=unnamedplus

"Setting tab width to 4 spaces, and expanding tab to spaces.
set tabstop=4
set shiftwidth=4
set expandtab

colorscheme deus
