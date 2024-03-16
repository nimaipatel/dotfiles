let mapleader=" "

syntax on

set relativenumber
set number

set ignorecase
set smartcase

set completeopt=menu,preview,longest,noinsert

cnoremap <c-n> <down>
cnoremap <c-p> <up>

set path+=**

set timeoutlen=1000 ttimeout ttimeoutlen=0

set mouse=a

let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_liststyle=3
let g:netrw_hide=0

runtime ftplugin/man.vim
set keywordprg=:Man

set cinoptions=l1

set smarttab
set autoindent
set copyindent
set smartindent
set tabstop=8
set autoread
set backspace=indent,eol,start
set complete-=i
set display=lastline
set encoding=utf-8
set formatoptions=tcqj
set history=10000
set hlsearch
set incsearch
set langnoremap
set laststatus=2
set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»
set nrformats=hex
set sessionoptions-=options
set tabpagemax=50
set tags=./tags;,tags
set ttyfast
set viminfo+=!
set lazyredraw
set scrolloff=1
set sidescroll=1
set sidescrolloff=2
set clipboard=unnamed

set splitright
set splitbelow

set wildmenu
set wildmode=longest:full
set wildoptions=fuzzy,pum
set wildignorecase
set wildignore+=*.o,*.obj,*.bak,*.exe
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=**/coverage/*
set wildignore+=**/node_modules/*
set wildignore+=**/.ccls-cache/*
set wildignore+=**/build/*
set wildignore+=**/android/*
set wildignore+=**/ios/*
set wildignore+=**/.git/*

vnoremap . :normal .<CR>

vnoremap < <gv
vnoremap > >gv

vnoremap J :m '>+1<cr>gv=gv
vnoremap K :m '<-2<cr>gv=gv

nnoremap <c-l> :nohl<cr><c-l>

nnoremap <leader>m :make<cr>:cope<cr>

function! UnsetAltScreen()
  let g:altscreen_save_t_ti = &t_ti
  let g:altscreen_save_t_te = &t_te
  if get(g:, 'altscreen_reset', 1)
    let &t_ti = ""
    let &t_te = ""
  else
    let &t_ti = substitute(&t_ti, '\e\[?1049[hl]', '', '')
    let &t_te = substitute(&t_te, '\e\[?1049[hl]', '', '')
  endif
endfun

function! SetAltScreen()
  let &t_ti = g:altscreen_save_t_ti
  let &t_te = g:altscreen_save_t_te
endfun

function! AltScreenControlZ()
  try
    call SetAltScreen()
    if exists('#AltScreen#User#suspend')
      doauto <nomodeline> AltScreen User suspend
    endif
    suspend!
  finally
    if exists('#AltScreen#User#resume')
      doauto <nomodeline> AltScreen User resume
    endif
    call UnsetAltScreen()
  endtry
endfun

augroup MyNoAltScreen
  autocmd!
  autocmd VimEnter *  call UnsetAltScreen()
  autocmd VimLeave *  call SetAltScreen()
augroup END

silent! noremap <unique> <silent>  <c-z>  :<c-u>call AltScreenControlZ()<cr>

nnoremap <c-n> :bnext<Cr>
nnoremap <c-p> :bprevious<Cr>
nnoremap <leader>d :bp\|bd #<CR>

" add new line without escaping normal mode and move to it
nnoremap <leader><cr> :call append(line('.'), '')<cr>j

function! s:Marks(char)
  marks
  let s:mark = nr2char(getchar())
  redraw
  execute "normal! " . a:char . s:mark
endfunction

nnoremap ' :call  <SID>Marks("'")<CR>
nnoremap ` :call  <SID>Marks("`")<CR>
nnoremap g' :call <SID>Marks("g'")<CR>
nnoremap g` :call <SID>Marks("g`")<CR>
nnoremap d' :call <SID>Marks("d'")<CR>
nnoremap d` :call <SID>Marks("d`")<CR>
nnoremap c' :call <SID>Marks("c'")<CR>
nnoremap c` :call <SID>Marks("c`")<CR>
nnoremap y' :call <SID>Marks("y'")<CR>
nnoremap y` :call <SID>Marks("y`")<CR>

inoremap <C-c> <esc>

" don't undo the whole thing!!
inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u

" add relative jumps to jump point list
nnoremap <EXPR> k (v:count > 5 > "m'" . v:count : "") . 'k'
nnoremap <EXPR> j (v:count > 5 > "m'" . v:count : "") . 'j'

"""""""""""""""sleuth.vim""""""""""""""""
function! s:guess(lines) abort
  let options = {}
  let heuristics = {'spaces': 0, 'hard': 0, 'soft': 0}
  let ccomment = 0
  let podcomment = 0
  let triplequote = 0
  let backtick = 0
  let xmlcomment = 0
  let softtab = repeat(' ', 8)

  for line in a:lines
    if !len(line) || line =~# '^\s*$'
      continue
    endif

    if line =~# '^\s*/\*'
      let ccomment = 1
    endif
    if ccomment
      if line =~# '\*/'
        let ccomment = 0
      endif
      continue
    endif

    if line =~# '^=\w'
      let podcomment = 1
    endif
    if podcomment
      if line =~# '^=\%(end\|cut\)\>'
        let podcomment = 0
      endif
      continue
    endif

    if triplequote
      if line =~# '^[^"]*"""[^"]*$'
        let triplequote = 0
      endif
      continue
    elseif line =~# '^[^"]*"""[^"]*$'
      let triplequote = 1
    endif

    if backtick
      if line =~# '^[^`]*`[^`]*$'
        let backtick = 0
      endif
      continue
    elseif &filetype ==# 'go' && line =~# '^[^`]*`[^`]*$'
      let backtick = 1
    endif

    if line =~# '^\s*<\!--'
      let xmlcomment = 1
    endif
    if xmlcomment
      if line =~# '-->'
        let xmlcomment = 0
      endif
      continue
    endif

    if line =~# '^\t'
      let heuristics.hard += 1
    elseif line =~# '^' . softtab
      let heuristics.soft += 1
    endif
    if line =~# '^  '
      let heuristics.spaces += 1
    endif
    let indent = len(matchstr(substitute(line, '\t', softtab, 'g'), '^ *'))
    if indent > 1 && (indent < 4 || indent % 2 == 0) &&
          \ get(options, 'shiftwidth', 99) > indent
      let options.shiftwidth = indent
    endif
  endfor

  if heuristics.hard && !heuristics.spaces
    return {'expandtab': 0, 'shiftwidth': &tabstop}
  elseif heuristics.soft != heuristics.hard
    let options.expandtab = heuristics.soft > heuristics.hard
    if heuristics.hard
      let options.tabstop = 8
    endif
  endif

  return options
endfunction

function! s:patterns_for(type) abort
  if a:type ==# ''
    return []
  endif
  if !exists('s:patterns')
    redir => capture
    silent autocmd BufRead
    redir END
    let patterns = {
          \ 'c': ['*.c'],
          \ 'html': ['*.html'],
          \ 'sh': ['*.sh'],
          \ 'vim': ['vimrc', '.vimrc', '_vimrc'],
          \ }
    let setfpattern = '\s\+\%(setf\%[iletype]\s\+\|set\%[local]\s\+\%(ft\|filetype\)=\|call SetFileTypeSH(["'']\%(ba\|k\)\=\%(sh\)\@=\)'
    for line in split(capture, "\n")
      let match = matchlist(line, '^\s*\(\S\+\)\='.setfpattern.'\(\w\+\)')
      if !empty(match)
        call extend(patterns, {match[2]: []}, 'keep')
        call extend(patterns[match[2]], [match[1] ==# '' ? last : match[1]])
      endif
      let last = matchstr(line, '\S.*')
    endfor
    let s:patterns = patterns
  endif
  return copy(get(s:patterns, a:type, []))
endfunction

function! s:apply_if_ready(options) abort
  if !has_key(a:options, 'expandtab') || !has_key(a:options, 'shiftwidth')
    return 0
  else
    for [option, value] in items(a:options)
      call setbufvar('', '&'.option, value)
    endfor
    return 1
  endif
endfunction

function! s:detect() abort
  if &buftype ==# 'help'
    return
  endif

  let options = s:guess(getline(1, 1024))
  if s:apply_if_ready(options)
    return
  endif
  let c = get(b:, 'sleuth_neighbor_limit', get(g:, 'sleuth_neighbor_limit', 20))
  let patterns = c > 0 ? s:patterns_for(&filetype) : []
  call filter(patterns, 'v:val !~# "/"')
  let dir = expand('%:p:h')
  while isdirectory(dir) && dir !=# fnamemodify(dir, ':h') && c > 0
    for pattern in patterns
      for neighbor in split(glob(dir.'/'.pattern), "\n")[0:7]
        if neighbor !=# expand('%:p') && filereadable(neighbor)
          call extend(options, s:guess(readfile(neighbor, '', 256)), 'keep')
          let c -= 1
        endif
        if s:apply_if_ready(options)
          let b:sleuth_culprit = neighbor
          return
        endif
        if c <= 0
          break
        endif
      endfor
      if c <= 0
        break
      endif
    endfor
    let dir = fnamemodify(dir, ':h')
  endwhile
  if has_key(options, 'shiftwidth')
    return s:apply_if_ready(extend({'expandtab': 1}, options))
  endif
endfunction

setglobal smarttab

if !exists('g:did_indent_on')
  filetype indent on
endif

function! SleuthIndicator() abort
  let sw = &shiftwidth ? &shiftwidth : &tabstop
  if &expandtab
    return 'sw='.sw
  elseif &tabstop == sw
    return 'ts='.&tabstop
  else
    return 'sw='.sw.',ts='.&tabstop
  endif
endfunction

augroup sleuth
  autocmd!
  autocmd FileType *
        \ if get(b:, 'sleuth_automatic', get(g:, 'sleuth_automatic', 1))
        \ | call s:detect() | endif
  autocmd User Flags call Hoist('buffer', 5, 'SleuthIndicator')
augroup END

command! -bar -bang Sleuth call s:detect()

function! s:CmdToBuffer(cmd)
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    " use "new" instead of "tabnew" below if you prefer split windows instead of tabs
    new
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    nnoremap <buffer>q :q<cr>
    silent put=message
  endif
endfunction
command! -nargs=+ -complete=command CmdToBuffer call <SID>CmdToBuffer(<q-args>)
