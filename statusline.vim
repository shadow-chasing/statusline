" {{{1 Functions
" {{{2 dictionary
" Dictionary: take mode() input -> longer notation of current mode
" mode() is defined by Vim
let g:currentmode={ 'n' : 'Normal ', 'no' : 'N·Operator Pending ', 'v' : 'Visual ', 'V' : 'V·Line ', '^V' : 'V·Block ', 's' : 'Select ', 'S': 'S·Line ', '^S' : 'S·Block ', 'i' : 'Insert ', 'R' : 'Replace ', 'Rv' : 'V·Replace ', 'c' : 'Command ', 'cv' : 'Vim Ex ', 'ce' : 'Ex ', 'r' : 'Prompt ', 'rm' : 'More ', 'r?' : 'Confirm ', '!' : 'Shell ', 't' : 'Terminal '}
"}}}
"{{{2 modecurrent
" Function: return current mode
" abort -> function will abort soon as error detected
function! ModeCurrent() abort
    let l:modecurrent = mode()
    " use get() -> fails safely, since ^V doesn't seem to register
    " 3rd arg is used when return of mode() == 0, which is case with ^V
    " thus, ^V fails -> returns 0 -> replaced with 'V Block'
    let l:modelist = toupper(get(g:currentmode, l:modecurrent, 'V·Block '))
    let l:current_status_mode = l:modelist
    return l:current_status_mode
endfunction
"}}}
"{{{2 filesize 
" this creates a file size attribute 
function! FileSize() abort
    let l:bytes = getfsize(expand('%p'))
    if (l:bytes >= 1024)
        let l:kbytes = l:bytes / 1025
    endif
    if (exists('kbytes') && l:kbytes >= 1000)
        let l:mbytes = l:kbytes / 1000
    endif
 
    if l:bytes <= 0
        return '0'
    endif
  
    if (exists('mbytes'))
        return l:mbytes . 'MB '
    elseif (exists('kbytes'))
        return l:kbytes . 'KB '
    else
        return l:bytes . 'B '
    endif
endfunction
"}}}
"{{{2 bytespercent
function! BytePercent()
    let crt_byte = line2byte(line('.')) + col('.') - 1
    let last_byte = line2byte(line('$')) + col(['$', '$']) - 1
    return crt_byte * 100 / last_byte . '%'
endfunction
"}}}
" }}}
" {{{1 Statusline
" ----------------------------------------------------------------------------
" HighLight Group
" ----------------------------------------------------------------------------
"hi User1 ctermbg=235 ctermfg=24   guibg=green guifg=red
"hi User2 ctermbg=24 ctermfg=white  guibg=red   guifg=blue
"hi User3 ctermbg=235 ctermfg=white  guibg=red   guifg=blue
" ----------------------------------------------------------------------------
" Status line
" ----------------------------------------------------------------------------
set laststatus=2
set statusline+=%1*
set statusline+=\ %{ModeCurrent()}
set statusline+=%2*
set statusline+=\ %<%F 
set statusline+=\ %m
set statusline+=\ %r
  
set statusline+=%=
set statusline+=%{FileSize()}
set statusline+=%y
set statusline+=\ %1*
set statusline+=\ ln
set statusline+=\ %3*%l\\%L
set statusline+=%1*\ col
set statusline+=\ %3*%c
set statusline+=%1*\ Buf
set statusline+=\ %3*%n
set statusline+=%1*\ [
set statusline+=%3*%p%%
set statusline+=%1*]
set statusline+=%=

" }}}
