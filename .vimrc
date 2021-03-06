"Automatic indentation
set smartindent

"Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red 
"This command has to come before any colorscheme is set
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

"Turn on syntax highlighting
syntax on
"Syntax highlighting colorscheme
colorscheme desert

"Turn on line numbers
set number

"Always uses spaces instead of tab characters
set expandtab
"Size of a hard tabstop
set tabstop=4
"Size of an indent
set shiftwidth=4

"Display each keystroke in the status line
set showcmd

"Always show the status line
set laststatus=2

"Highlight all search pattern matches
set hlsearch
"Incremental search
set incsearch

"Searches ignore case unless they contain at least one capital letter
set ignorecase
set smartcase

"Highlight the 100th text column:
set colorcolumn=100

"Delete single characters without updating the default register
noremap x "_x
"Paste in visual mode without updating the default register
vnoremap p "_dP

"Disable vi-compatible backspace behavior
set backspace=indent,eol,start
"Disable vi compatibility (may be redundant with above)
set nocompatible

"Default character encoding
set encoding=utf-8
set fileencoding=utf-8

"Enable 256-color mode
set t_Co=256

"Disable bold font
set t_md=

"Map accidental capitals to their intended commands
command WQ wq
command Wq wq
command W w
command Q q
command Tabnew tabnew

"Tell vim to remember certain things when we exit
" '10  marks will be remembered for up to 10 previously edited files
" "100 will save up to 100 lines for each register
" :20  up to 20 lines of command-line history will be remembered
" %    saves and restores the buffer list
" n... where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.vim/viminfo

"Function to save the cursor position of the previously opened file
function! ResCur()
  if line("'\"") > 0 && line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction
augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

"Remap default easymotion leader from \\ to \
let g:EasyMotion_leader_key = '<Leader>'

"Cause screen to scroll when within five lines of the edge
set scrolloff=5

"Enable persistent undo
set undofile                "Save undo history when a file is closed
set undodir=$HOME/.vim/undo "Where to save undo histories (must create this dir manually)
set undolevels=1000         "How many undos to save
set undoreload=10000        "Number of lines to save for undo

"In insert mode, map Shift-Tab to ^D, a.k.a. delete to next tabstop
inoremap <s-tab> <c-d>

"Give the behavior of ^D and ^U to ^F and ^B (which are easier to hit)
nnoremap <c-f> <c-d>
nnoremap <c-b> <c-u>

"Tell Airline to use its custom glyphs
let g:airline_powerline_fonts = 1

"Instantly leave insert mode when pressing Esc
set ttimeoutlen=10
augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
augroup END

"Disable comment autoinsertion
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

set ssop-=options " Do not store .vimrc options in a session
set ssop-=folds " Do not store folds in a session

"Toggle line numbering
nmap <Leader>l :setlocal number!<CR>

"Toggle paste mode
nmap <Leader>p :set paste!<CR>

"Turn off highlighting for last search
nmap <Leader>q :nohlsearch<CR>

"Toggle hex edit mode
nmap <Leader>h :call ToggleHex()<CR>

let g:hex_mode_on = 0

function! ToggleHex()
    if g:hex_mode_on
        execute "%!xxd -r"
        let g:hex_mode_on = 0
    else
        execute "%!xxd"
        let g:hex_mode_on = 1
    endif
endfunction

"Make j and k move row-wise rather than linewise.
"This only makes a difference when in a line that is longer than the width of the terminal.
nmap j gj
nmap k gk

"Map ^j and ^k to next and previous buffer, and ^l and ^h to next and previous tab.
map <C-J> :bnext<CR>
map <C-K> :bprev<CR>
map <C-L> :tabn<CR>
map <C-H> :tabp<CR>

"Make the built-in file browser more useful
let g:netrw_liststyle = 3 " View files as a tree
let g:netrw_banner = 0 " Don't show the banner
