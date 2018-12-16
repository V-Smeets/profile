" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2015 Mar 24
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

"if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
"else
"  set backup		" keep a backup file (restore to previous version)
"  set undofile		" keep an undo file (undo changes after closing)
"endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set autowrite		" Write the contents of the file, if it has been modified.
set scrolloff=5		" Minimal number of screen lines to keep above and below the cursor.

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  colorscheme delek
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

  augroup LaTeX
	  au!

	  " use the appropriate version of pdf(La)TeX
	  autocmd FileType plaintex     let b:tex_flavor = "pdftex -file-line-error"
	  autocmd FileType          tex let b:tex_flavor = "pdflatex -file-line-error"
	  autocmd FileType plaintex,tex compiler tex
	  autocmd FileType plaintex,tex set errorformat=%f:%l:\ %m
	  autocmd FileType plaintex,tex set textwidth=132

	  autocmd QuickFixCmdPost [^l]* nested cwindow
	  autocmd QuickFixCmdPost    l* nested lwindow
  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif

if has("cscope")
	set cscopeprg=cscope
	set cscopetagorder=0
	set cscopetag
	set nocscopeverbose
	" add any database in current directory
	if filereadable("cscope.out")
	    cscope add cscope.out
	" else add database pointed to by environment
	elseif $CSCOPE_DB != ""
	    cscope add $CSCOPE_DB
	endif
	set cscopeverbose

	set nocscopetag

	" Ctrl-Space
	" Find this C symbol
	nmap <C-@>s :cscope find s <C-R>=expand("<cword>")<CR><CR>
	" Find this definition
	nmap <C-@>g :cscope find g <C-R>=expand("<cword>")<CR><CR>
	" Find functions called by this function
	nmap <C-@>d :cscope find d <C-R>=expand("<cword>")<CR><CR>
	" Find functions calling this function
	nmap <C-@>c :cscope find c <C-R>=expand("<cword>")<CR><CR>
	" Find this text string
	nmap <C-@>t :cscope find t <C-R>=expand("<cword>")<CR><CR>
	" Find this egrep pattern
	nmap <C-@>e :cscope find e <C-R>=expand("<cword>")<CR><CR>
	" Find this file
	nmap <C-@>f :cscope find f <C-R>=expand("<cfile>")<CR><CR>
	" Find files #including this file
	nmap <C-@>i :cscope find i ^<C-R>=expand("<cfile>")<CR>$<CR>
	" Find places where this symbol is assigned a value
	nmap <C-@>a :cscope find a <C-R>=expand("<cword>")<CR><CR>

	" Ctrl-Space Ctrl-Space
	" Find this C symbol
	nmap <C-@><C-@>s :scscope find s <C-R>=expand("<cword>")<CR><CR>
	" Find this definition
	nmap <C-@><C-@>g :scscope find g <C-R>=expand("<cword>")<CR><CR>
	" Find functions called by this function
	nmap <C-@><C-@>d :scscope find d <C-R>=expand("<cword>")<CR><CR>
	" Find functions calling this function
	nmap <C-@><C-@>c :scscope find c <C-R>=expand("<cword>")<CR><CR>
	" Find this text string
	nmap <C-@><C-@>t :scscope find t <C-R>=expand("<cword>")<CR><CR>
	" Find this egrep pattern
	nmap <C-@><C-@>e :scscope find e <C-R>=expand("<cword>")<CR><CR>
	" Find this file
	nmap <C-@><C-@>f :scscope find f <C-R>=expand("<cfile>")<CR><CR>
	" Find files #including this file
	nmap <C-@><C-@>i :scscope find i ^<C-R>=expand("<cfile>")<CR>$<CR>
	" Find places where this symbol is assigned a value
	nmap <C-@><C-@>a :scscope find a <C-R>=expand("<cword>")<CR><CR>

endif

" Make
nmap	<C-PageDown>	:cnext<CR>
nmap	<C-PageUp>	:cprevious<CR>
