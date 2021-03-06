if $VIM_PLUGINS != 'NO'
  if filereadable(expand('~/.vimbundle'))
    source ~/.vimbundle
  endif
  runtime! ftplugin/man.vim
endif

syntax on
filetype plugin indent on

" set ignorecase
set smartcase
set number
set autoread
au CursorHold * checktime

set visualbell

set wildmenu
set wildmode=list:longest,full

colorscheme vylight

set rtp+=/usr/local/opt/fzf

command! -bang -nargs=? -complete=dir GFiles
    \ call fzf#vim#gitfiles(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', '~/.vim/bundle/fzf.vim/bin/preview.sh {}']}, <bang>0)
nnoremap <C-p> :GFiles<cr>
let g:github_enterprise_urls = ['https://git.innova-partners.com']
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
let g:fzf_preview_window = 'top:60%'
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

set splitright
set splitbelow

set hidden

set guifont=Monaco:h16
set guioptions-=T guioptions-=e guioptions-=L guioptions-=r
set shell=bash
set wrap!

set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

autocmd VimResized * wincmd =

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
