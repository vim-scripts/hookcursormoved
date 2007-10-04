" hookcursormoved.vim
" @Author:      Thomas Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-10-04.
" @Last Change: 2007-10-04.
" @Revision:    0.2.68
" GetLatestVimScripts: 2037 1 hookcursormoved.vim

if &cp || exists("loaded_hookcursormoved")
    finish
endif
let loaded_hookcursormoved = 2

let s:save_cpo = &cpo
set cpo&vim


if !exists('g:hookcursormoved_namespaces') "{{{2
    " let g:hookcursormoved_namespaces = ['w', 't', 'b', 'g']
    let g:hookcursormoved_namespaces = ['b', 'g']
endif


function! HookCursorMoved_syntaxchange(mode) "{{{3
    let syntax = synIDattr(synID(b:hookcursormoved_currpos[1], b:hookcursormoved_currpos[2], 1), 'name')
    if exists('b:hookcursormoved_syntax')
        let rv = b:hookcursormoved_syntax != syntax
    else
        let rv = 0
    endif
    let b:hookcursormoved_syntax = syntax
    return rv
endf


function! HookCursorMoved_linechange(mode) "{{{3
    return exists('b:hookcursormoved_oldpos') && b:hookcursormoved_currpos[1] != b:hookcursormoved_oldpos[1]
endf


augroup HookCursorMoved
    autocmd!
augroup END


let &cpo = s:save_cpo
unlet s:save_cpo
finish

This experimental plugin provides some help with the definition of 
functions that should be called when the cursor position changed.

When the cursor position changes, it first checks if a certain condition 
is met and then calls functions registered in 
[bg]:hookcursormoved_{CONDITION} (an array).

Pre-defined conditions:
    linechange
        The line-number has changed
    syntaxchange
        The syntax group under the cursor has changed (i.e. the cursor 
        has moved in/out of a syntax group

In order to define a new conditions, you have to define a function 
"HookCursorMoved_{CONDITION}(mode)", which returns true if the condition 
is met.

Functions are best registered using |hookcursormoved#Register()|.
Example: >

    function! WhatsGoingOn(mode) "{{{3
        if mode == 'i'
            DoThis
        elseif mode == 'n'
            DoThat
        endif
    endf

    call hookcursormoved#Register('b', 'syntaxchange', function('WhatsGoingOn'))


CHANGES
0.1
- Initial release

0.2
- Renamed s:Enable() to hookcursormoved#Enable()
- Renamed s:enabled to b:hookcursormoved_enabled

