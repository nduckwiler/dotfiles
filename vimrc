" Nick Duckwiler <http://nickduckwiler.com>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GENERAL SETUP

set nocompatible                " disable vi compatability mode
set ruler                       " show cursor position at window bottom
set showcmd                     " display incomplete commands
set incsearch                   " do incremental searching
set ignorecase                  " turn off case-sensitive search
set smartcase                   " turn on case-sensitive search if uppercase
set ttyfast                     " optimize for fast terminal connections
set wildmenu                    " enhance command-line completion
set hlsearch                    " highlight last used search pattern
set number                      " show line numbers
set hidden                      " buffers can be hidden without saving first
"set cursorline                  " highlight the line containing the cursor
set confirm                     " confirm abandoning buf with unsaved changes
set foldenable                  " enable folding
set foldmethod=indent           " use indents to determine folds
set foldlevel=999               " start with all folds open
set autoread                    " reload file if changed outside of vim
set showmatch                   " show matching brackets under cursor
set mouse=a                     " enable mouse in all modes
set t_Co=256                    " use 256 colors
set scrolloff=1                 " scroll to one line before bottom border
set laststatus=2                " always show status line
set history=100                 " keep 100 lines of command line history
set encoding=utf-8              " use utf-8 as standard encoding
set shell=/bin/bash             " shell as bash so fish doesn't break vim
set backspace=indent,eol,start  " allow bkspace over everything in insert mode
set viminfo+=n~/.vim/.viminfo   " store .viminfo in ~/.vim
set display+=lastline           " display last line, even if cut off by bottom
set noeb vb t_vb=               " no beep, no flash for bell
set omnifunc=syntaxcomplete#Complete "enable omni completion

set list
set listchars=tab:>-,trail:~

filetype plugin indent on       " detect filetype and lang-dependent indent
syntax on                       " enable syntax highlighting
colorscheme deus              " color scheme

" Return to last edit position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGINS

call plug#begin()
"Plug 'vim-airline/vim-airline-themes'
"Plug 'vim-airline/vim-airline'
"Plug 'scrooloose/syntastic'
"Plug 'airblade/vim-gitgutter'
Plug 'justinmk/vim-sneak'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'sheerun/vim-polyglot'
"Plug 'tpope/vim-rsi'
Plug 'tpope/vim-repeat'
"Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-surround'
"Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-fugitive'
"Plug 'endel/vim-github-colorscheme'
Plug 'ajmwagar/vim-deus'
call plug#end()

let g:airline_theme = 'lucius'
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#buffer_min_count = 2
let g:sneak#s_next = 1
let g:gitgutter_signs = 0
let g:ctrlp_working_path_mode = 'ra'
let g:markdown_fenced_languages = ['html', 'vim', 'ruby', 'python', 'bash=sh', 'javascript']
let g:clojure_align_multiline_strings = 1
let g:syntastic_javascript_checkers = ['eslint']


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MAPPINGS

" Use tab to enter normal mode
"imap <tab> <esc>

" Use ; instead of : to enter commandline mode
nore ; :
nore , ;

" Move through wrapped lines like normal lines
nnoremap j gj
nnoremap k gk

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LEADER COMMANDS

" Use `,` as leader key
let mapleader = ','

" Create setext headings with `h1` and `h2`
map <leader>h1 VypVr=
map <leader>h2 VypVr-

" Easy navigation between splits.
" Instead of ctrl-w then j, use ctrl-j.
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Run mocha test for current file
map <leader>t :! mocha %<CR>

" Copy entire file to clipboard
map <leader>c :%w !pbcopy

" Copy selected text to clipboard
map <leader>x :w !pbcopy

" Switch to paste mode
map <leader>p :set paste<CR>
" Run mocha test for current file
map <leader>np :set nopaste<CR>

" Format indentation in entire file with =
map <leader>i mmgg=G`m

" Start global, interactive find and replace
map <leader>r :%s/

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FUNCTIONS

" Run `:FixWhitespace` to remove end of line white space
function! s:FixWhitespace(line1,line2)
    let l:save_cursor = getpos(".")
    silent! execute ':' . a:line1 . ',' . a:line2 . 's/\s\+$//'
    call setpos('.', l:save_cursor)
endfunction
command! -range=% FixWhitespace call <SID>FixWhitespace(<line1>,<line2>)

" Run `:RemoveFancyCharacters` to remove smart quotes, etc.
function! RemoveFancyCharacters()
  let typo = {}
  let typo["“"] = '"'
  let typo["”"] = '"'
  let typo["‘"] = "'"
  let typo["’"] = "'"
  let typo["–"] = '--'
  let typo["—"] = '---'
  let typo["…"] = '...'
  :exe ":%s/".join(keys(typo), '\|').'/\=typo[submatch(0)]/ge'
endfunction
command! RemoveFancyCharacters :call RemoveFancyCharacters()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ABBREVIATIONS

" Type `dts` to expand to date
" iab <expr> dts strftime("%Y-%m-%d")

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TEXT, TABS, INDENTATION, SPELL CHECK

set tabstop=2
set shiftwidth=2
set expandtab

set autoindent
set spellfile=~/.vim/spell/en.utf-8.add

autocmd FileType markdown,text setlocal cc=0 spell nocul lbr

" List continuation and indentation for markdown
autocmd FileType markdown setlocal
      \ com=s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,b:- formatoptions=tcroqln
      \ breakindent
      \ showbreak=\ \

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BACKUP

" note: `~/.vim` and `~/.vim/backup` must already exist
" note: `^=` prepends to target
" note: `//` incorporates full path into swap file name

"set backup
"set backupdir^=~/.vim/backup
set dir^=~/.vim/backup//

