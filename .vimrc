if $VIM_PLUGINS != 'NO'
  if filereadable(expand('~/.vimbundle'))
    source ~/.vimbundle
  endif
  runtime! ftplugin/man.vim
endif

syntax on
filetype plugin indent on

set ignorecase
set smartcase
set number

set visualbell

set wildmenu
set wildmode=list:longest,full

colorscheme vylight

set rtp+=/usr/local/opt/fzf

nnoremap <C-p> :GFiles <cr>
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }

set splitright
set splitbelow

set hidden

set guifont=Monaco:h16
set guioptions-=T guioptions-=e guioptions-=L guioptions-=r
set shell=bash

augroup vimrc
  autocmd!
  autocmd GuiEnter * set columns=120 lines=70 number
augroup END

" shows the output from prettier - useful for syntax errors
" nnoremap <leader>pt :!prettier %<CR>

" Plugin Configuration: {{{

  " ALE: {{{
    " let g:ale_sign_error = 'X'
    " let g:ale_sign_warning = '!'
    " highlight link ALEWarningSign ErrorMsg
    " highlight link ALEErrorSign WarningMsg
    " nnoremap <silent> <leader>ne :ALENextWrap<CR>
    " nnoremap <silent> <leader>pe :ALEPreviousWrap<CR>

    let g:ale_fixers = {
          \   'javascript': ['prettier'],
          \   'javascript.jsx': ['prettier'],
          \   'json': ['prettier'],
          \   'scss': ['prettier'],
          \   'bash': ['shfmt'],
          \   'zsh': ['shfmt'],
          \   'elixir': ['mix_format'],
          \}

    " let g:ale_fix_on_save = 1
  " }}}

" }}}

" Tab navigation
nnoremap tt :tabnew<CR>
nnoremap tT :tab split<CR>
nnoremap tq :tabclose<CR>
nnoremap tn :tabnext<CR>
nnoremap tN :tabmove +1<CR>
nnoremap tp :tabprev<CR>
nnoremap tP :tabmove -1<CR>
nnoremap t1 1gt
nnoremap t2 2gt
nnoremap t3 3gt
nnoremap t4 4gt
nnoremap t5 5gt
nnoremap t6 6gt
nnoremap t7 7gt
nnoremap t8 8gt
nnoremap t9 9gt

nnoremap <Tab> <C-w>w
nnoremap <S-Tab> <C-w>W

if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif
