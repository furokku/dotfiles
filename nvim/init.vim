set runtimepath^=~/.config/nvim/
let &packpath = &runtimepath


" vundle
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#rc("~/.config/nvim/bundle")

Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'vim-syntastic/syntastic'
Plugin 'neoclide/coc.nvim'
Plugin 'preservim/nerdtree'

call vundle#end()

" let g:airline_powerline_fonts = 1
let g:airline_theme='bubblegum'

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_w = 1
let g:syntastic_check_on_wq = 0

nnoremap <C-f> :NERDTreeToggle<CR>
nnoremap <C-g> :lopen<CR>

set shiftwidth=4
set softtabstop=4
set expandtab
set nocompatible
set number
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set completefunc
syntax on
