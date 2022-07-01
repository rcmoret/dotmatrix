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
let g:github_enterprise_urls = ['']
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
    let g:ale_linters = {
          \   'ruby': ['rubocop'],
          \}

    let g:ale_linters = { 'crystal': [] }
    " let g:ale_fix_on_save = 1
  " }}}

" }}}

" Tab navigation
nnoremap <silent> tt :tabnew<CR>
nnoremap <silent> tT :tab split<CR>
nnoremap <silent> tq :tabclose<CR>
nnoremap <silent> tn :tabnext<CR>
nnoremap <silent> tN :tabmove +1<CR>
nnoremap <silent> tp :tabprev<CR>
nnoremap <silent> tP :tabmove -1<CR>
nnoremap <silent> t1 1gt
nnoremap <silent> t2 2gt
nnoremap <silent> t3 3gt
nnoremap <silent> t4 4gt
nnoremap <silent> t5 5gt
nnoremap <silent> t6 6gt
nnoremap <silent> t7 7gt
nnoremap <silent> t8 8gt
nnoremap <silent> t9 9gt

nnoremap <Tab> <C-w>w
nnoremap <S-Tab> <C-w>W

if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

let g:tmux_navigator_no_mappings = 1
let g:tmux_navigator_disable_when_zoomed = 1

nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
" nnoremap <silent> {Previous-Mapping} :TmuxNavigatePrevious<cr>
