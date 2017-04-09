" --- General settings --- "
syntax on
set tabstop=4 softtabstop=4 expandtab shiftwidth=4 smarttab
set incsearch   " Search as characters are entered
set hlsearch    " Highlight matches
set backspace=indent,eol,start
set ruler

" --- Not sure if I like --- "
"set number
set showcmd
filetype plugin indent on

" --- My own --- "
set cursorline 
set showmatch   " Highlight matching [{()}]
set ai          " Auto indent
set si          " Smart indent
set wrap        " Wrap lines


" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>


""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2


"set spell spelllang=en_gb"
