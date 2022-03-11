" set path to ~/.config/nvim instead of ~/.vim
set runtimepath^=~/.config/nvim/
let &packpath=&runtimepath
set rtp+=~/.config/nvim/bundle/Vundle.vim

" vundle plugin stuff
call vundle#rc("~/.config/nvim/bundle")
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'vim-syntastic/syntastic'
Plugin 'preservim/nerdtree'
Plugin 'morhetz/gruvbox'
Plugin 'neoclide/coc.nvim'
call vundle#end()

" set the vim-airline theme and optionally use powerline fonts if you have them
"let g:airline_powerline_fonts=1
"let g:airline_theme='bubblegum'

" gruvbox
let g:gruvbox_contrast_dark='hard'
autocmd vimenter * ++nested colorscheme gruvbox

" set background=light "setting light mode
set background=dark "setting dark mode

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" nerdtree toggle keybind
nnoremap <C-a> :NERDTreeToggle<CR>
" bind to clear last search
nnoremap <C-c> :let @/=""<CR>

" make tabs 4 whitespaces
set shiftwidth=4
set softtabstop=4
set expandtab

" ??
set nocompatible

" make the cursor blink
set guicursor=a:block-blinkon1

" enable line numbers
set number

" enable syntasic stuff
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set completefunc

syntax on

let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=1
let g:syntastic_check_on_open=1
let g:syntastic_check_on_w=1
let g:syntastic_check_on_wq=0
