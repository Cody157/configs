"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Personal Vim Config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set number
set ruler
set autoread
set hidden

colorscheme torte
set background=dark

syntax enable
filetype plugin indent on

let mapleader = ","
let g:mapleader = ","


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Search
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set hlsearch
set incsearch

" Clear search highlighting.
nnoremap <silent> <Space> :noh<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Indentation / Whitespace
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set expandtab
set smarttab
set shiftwidth=2
set tabstop=2
set autoindent
set smartindent
set wrap
set linebreak

" Delete trailing whitespace on save for selected filetypes.
function! DeleteTrailingWS()
  normal mz
  %s/\s\+$//ge
  normal `z
endfunction

autocmd BufWrite *.py :call DeleteTrailingWS()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Navigation
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Treat wrapped lines as visual lines.
nnoremap j gj
nnoremap k gk

" Semicolon opens command mode.
nnoremap ; :

" Backtick jumps to first non-blank character.
nnoremap ` ^

" Location list navigation.
nnoremap <C-j> :lnext<CR>
nnoremap <C-k> :lprev<CR>

" Return to last edit position when opening files.
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   execute "normal! g`\"" |
  \ endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Insert Mode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

inoremap jj <Esc>

" Prevent accidental page navigation in insert mode.
inoremap <PageUp> <Esc>
inoremap <PageDown> <Esc>

" iTerm Option-key behavior.
inoremap <M-BS> <C-w>
inoremap <M-Left> <C-o>b
inoremap <M-Right> <C-o>w


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual Mode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Keep visual selection while indenting/outdenting.
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Comment selected lines with //.
vnoremap / I//<Esc>

" Delete first character on each selected line.
vnoremap ? lx


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Moving Lines
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <M-j> mz:m+<CR>`z
nnoremap <M-k> mz:m-2<CR>`z
vnoremap <M-j> :m'>+<CR>`<my`>mzgv`yo`z
vnoremap <M-k> :m'<-2<CR>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nnoremap <D-j> <M-j>
  nnoremap <D-k> <M-k>
  vnoremap <D-j> <M-j>
  vnoremap <D-k> <M-k>
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Buffers / Tabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>w :w<CR>

nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>to :tabonly<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>tm :tabmove
nnoremap <leader>te :tabedit <C-r>=expand("%:p:h")<CR>/

nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Spell Checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>ss :setlocal spell!<CR>
nnoremap <leader>sn ]s
nnoremap <leader>sp [s
nnoremap <leader>sa zg
nnoremap <leader>s? z=


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set noerrorbells
set novisualbell
set visualbell t_vb=

set mouse=nv

" Disable function keys.
noremap <F1> <Nop>
noremap <F2> <Nop>
noremap <F3> <Nop>
noremap <F4> <Nop>
noremap <F5> <Nop>
noremap <F6> <Nop>
noremap <F7> <Nop>
noremap <F8> <Nop>
noremap <F9> <Nop>
noremap <F10> <Nop>
noremap <F11> <Nop>
noremap <F12> <Nop>

inoremap <F1> <Nop>
inoremap <F2> <Nop>
inoremap <F3> <Nop>
inoremap <F4> <Nop>
inoremap <F5> <Nop>
inoremap <F6> <Nop>
inoremap <F7> <Nop>
inoremap <F8> <Nop>
inoremap <F9> <Nop>
inoremap <F10> <Nop>
inoremap <F11> <Nop>
inoremap <F12> <Nop>

" Toggle paste mode.
nnoremap <leader>pp :setlocal paste!<CR>

" Vimdiff: ignore whitespace.
if &diff
  set diffopt+=iwhite
endif

" YAML: disable indentexpr because comment indentation can be annoying.
autocmd FileType yaml setlocal indentexpr=
