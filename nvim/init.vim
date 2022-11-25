" Line numbers
set number relativenumber

" Colorscheme
set termguicolors
colorscheme gruvbox

" Syntax highlighting
syntax on

" enables mouse
set mouse=a

:autocmd BufWinEnter * !setxkbmap -option caps:swapescape
:autocmd BufWinLeave * !setxkbmap -option
