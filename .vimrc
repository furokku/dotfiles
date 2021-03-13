set number

" vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

call vundle#end()

let g:airline_powerline_fonts = 1
let g:airline_theme='violet'
syntax on

set shiftwidth=4
set softtabstop=4
set expandtab
set nocompatible
