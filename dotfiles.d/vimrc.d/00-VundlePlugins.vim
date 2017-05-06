" ---------- Vundle ---------- "

" This file we run all the Vundle Plugins

" Start the Vundle Plugin manager
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'


Plugin 'tpope/vim-vinegar'

Plugin 'scrooloose/nerdtree'

Plugin 'ctrlpvim/ctrlp.vim'

Plugin 'airblade/vim-gitgutter'

" Once all of the Plugins have been added following is required
call vundle#end()            " required
filetype plugin indent on    " required
