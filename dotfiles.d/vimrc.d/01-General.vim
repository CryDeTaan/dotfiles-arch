syntax enable


set backspace=indent,eol,start	"Make backspace behave like other editors
set number			"Shows line line numbers in the buffer.

" -----------------Visuals---------------- "
so ~/.dotfiles/dotfiles.d/vimrc.d/colors/jay.vim
hi Normal guibg=NONE ctermbg=NONE



" -----------------Search----------------- "

set hlsearch	"Enable search highlighting.
set incsearch	"Start highlighting first occurrence of match as typing happens


" ----------------Mappings---------------- "

" Set the <Leader Variable. The default is '\', so if unset <leader> = '\'.
let mapleader = ','

" Edit the vimrc file as part of the .dotfiles setup
nmap <Leader>ev :tabedit ~/.dotfiles/rc/vimrc<cr>

" Close the current tab
nmap <Leader>ct :tabc<cr>

"Remove search highlightling, default is to remain highlighted untill new search is performed. 
nmap <Leader><space> :nohlsearch<cr>

" Source .vimrc
nmap <Leader>sv :so ~/.dotfiles/rc/vimrc<cr>

" Open NERDTreeToggle
nmap <Leader>t :NERDTreeToggle<cr>
 
" Open most reciently used files by Vim
nmap <C-e> :CtrlPMRUFiles<cr>

" -------------Split Mappings------------- "

set splitbelow
set splitright

"nmap <C-



" -------------Plugins------------- "

"/
"/ CtrlP
"/

let g:ctrlp_match_window = 'bottom,order:ttb,min:1,max:5,results:10'






" --------------Auto Commands------------- "

"Automatically source the vimrc file on save

"This clears the group otherwise the group will be loaded again in the same group.
augroup autosourcing
	autocmd!  
	autocmd BufWritePost ~/.dotfiles/rc/vimrc source %
augroup END


