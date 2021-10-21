" Use Vim defaults (much better!)
set nocompatible        

" Allow backspacing over everything in insert mode
set bs=2                

" Always set auto-indenting on
set ai                  

" keep 50 lines of command history
set history=50          

" Show the cursor position all the time
set ruler               

" Don't use Ex mode, use Q for formatting
map Q gq

" When doing tab completion, give the following files lower priority.
set suffixes+=.info,.aux,.log,.dvi,.bbl,.out,.o,.lo

" Turn off modeline parsing altogether
set nomodeline          

autocmd BufRead APKBUILD set filetype=sh

" .vimrc
" See: http://vimdoc.sourceforge.net/htmldoc/options.html for details

" For multi-byte character support (CJK support, for example):
"set fileencodings=ucs-bom,utf-8,cp936,big5,euc-jp,euc-kr,gb18030,latin1

" Number of spaces that a <Tab> in the file counts for.
set tabstop=4       

" Number of spaces to use for each step of (auto)indent.
set shiftwidth=4    

" Use the appropriate number of spaces to insert a <Tab>.
" Spaces are used in indents with the '>' and '<' commands
" and when 'autoindent' is on. To insert a real tab when
" 'expandtab' is on, use CTRL-V <Tab>.
set expandtab       

" When on, a <Tab> in front of a line inserts blanks
" according to 'shiftwidth'. 'tabstop' is used in other
" places. A <BS> will delete a 'shiftwidth' worth of space
" at the start of the line.
set smarttab        

" Show (partial) command in status line.
set showcmd         

" Show line numbers.
set number          

" When a bracket is inserted, briefly jump to the matching
" one. The jump is only done if the match can be seen on the
" screen. The time to show the match can be set with
" 'matchtime'.
set showmatch       

" When there is a previous search pattern, highlight all
" its matches.
set hlsearch        
                    
" While typing a search command, show immediately where the
" so far typed pattern matches.
set incsearch       

" Ignore case in search patterns.
set ignorecase      

" Override the 'ignorecase' option if the search pattern
" contains upper case characters.
set smartcase       

" Influences the working of <BS>, <Del>, CTRL-W
" and CTRL-U in Insert mode. This is a list of items,
" separated by commas. Each item allows a way to backspace
" over something.
set backspace=2     

" Copy indent from current line when starting a new line
" (typing <CR> in Insert mode or when using the "o" or "O"
" command).
set autoindent      

" Maximum width of text that is being inserted. A longer
" line will be broken after white space to get this width.
set textwidth=79    

" This is a sequence of letters which describes how
" automatic formatting is to be done.
"
" letter    meaning when present in 'formatoptions'
" ------    ---------------------------------------
" c         Auto-wrap comments using textwidth, inserting
"           the current comment leader automatically.
" q         Allow formatting of comments with "gq".
" r         Automatically insert the current comment leader
"           after hitting <Enter> in Insert mode.
" t         Auto-wrap text using textwidth (does not apply
"           to comments)
set formatoptions=c,q,r,t 

" When set to "dark", Vim will try to use colors that look
" good on a dark background. When set to "light", Vim will
" try to use colors that look good on a light background.
" Any other value is illegal.
set background=dark 

" Enable the use of the mouse.
" set mouse=a         

" scrolls the text so that (when possible) there are always 
" at least lines visible above and below the cursor.
set scrolloff=30    

filetype plugin indent on
syntax on

" set backspace=indent,eol,start

" Switch relativenumber row.
set relativenumber!

function TRelative()
        set relativenumber!
endfunc
map <c-t> :call TRelative()<cr>

" Pastetoggle paste/nopaste.
set pastetoggle=<F2>

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

" Exec python filetype in shell.
autocmd FileType python map <buffer> <F9> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F9> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

" Set the + register as the default.
set clipboard=unnamedplus

execute pathogen#infect()

" Hide completeopt buffer split.
autocmd FileType python setlocal completeopt-=preview

" Colorscheme.
colorscheme gruvbox


set fileencodings=utf-8,cp1251,cp866,koi8-r

" <F7> File fileformat (dos - <CR> <NL>, unix - <NL>, mac - <CR>)
map <F7>	:execute RotateFileFormat()<CR>
vmap <F7>	<C-C><F7>
imap <F7>	<C-O><F7>
let b:fformatindex=0
function! RotateFileFormat()
  let y = -1
  while y == -1
    let encstring = "#unix#dos#mac#"
    let x = match(encstring,"#",b:fformatindex)
    let y = match(encstring,"#",x+1)
    let b:fformatindex = x+1
    if y == -1
      let b:fformatindex = 0
    else
      let str = strpart(encstring,x+1,y-x-1)
      return ":set fileformat=".str
    endif
  endwhile
endfunction

" <F8> File encoding for open
" ucs-2le - MS Windows unicode encoding
map <F8>	:execute RotateEnc()<CR>
vmap <F8>	<C-C><F8>
imap <F8>	<C-O><F8>
let b:encindex=0
function! RotateEnc()
  let y = -1
  while y == -1
    let encstring = "#koi8-r#cp1251#8bit-cp866#utf-8#ucs-2le#"
    let x = match(encstring,"#",b:encindex)
    let y = match(encstring,"#",x+1)
    let b:encindex = x+1
    if y == -1
      let b:encindex = 0
    else
      let str = strpart(encstring,x+1,y-x-1)
      return ":e ++enc=".str
    endif
  endwhile
endfunction

" <Shift+F8> Force file encoding for open (encoding = fileencoding)
map <S-F8>	:execute ForceRotateEnc()<CR>
vmap <S-F8>	<C-C><S-F8>
imap <S-F8>	<C-O><S-F8>
let b:encindex=0
function! ForceRotateEnc()
  let y = -1
  while y == -1
    let encstring = "#koi8-r#cp1251#8bit-cp866#utf-8#ucs-2le#"
    let x = match(encstring,"#",b:encindex)
    let y = match(encstring,"#",x+1)
    let b:encindex = x+1
    if y == -1
      let b:encindex = 0
    else
      let str = strpart(encstring,x+1,y-x-1)
      :execute "set encoding=".str
      return ":e ++enc=".str
    endif
  endwhile
endfunction

" <Ctrl+F8> File encoding for save (convert)
map <C-F8>	:execute RotateFEnc()<CR>
vmap <C-F8>	<C-C><C-F8>
imap <C-F8>	<C-O><C-F8>
let b:fencindex=0
function! RotateFEnc()
  let y = -1
  while y == -1
    let encstring = "#koi8-r#cp1251#8bit-cp866#utf-8#ucs-2le#"
    let x = match(encstring,"#",b:fencindex)
    let y = match(encstring,"#",x+1)
    let b:fencindex = x+1
    if y == -1
      let b:fencindex = 0
    else
      let str = strpart(encstring,x+1,y-x-1)
      return ":set fenc=".str
    endif
  endwhile
endfunction

"<F10> - вызов меню выбора кодировки
" переключение в меню с помощью Tab
" Меню выбора кодировки
set wildmenu
set wcm=<Tab>
menu Encoding.koi8-u :e ++enc=8bit-koi8-u<CR>
menu Encoding.windows-1251 :e ++enc=8bit-cp1251<CR>
menu Encoding.ibm-866 :e ++enc=8bit-ibm866<CR>
menu Encoding.utf-8 :e ++enc=2byte-utf-8 <CR>
map <F10> :emenu Encoding.<TAB> 

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_theme='simple'
