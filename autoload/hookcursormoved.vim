" hookcursormoved.vim
" @Author:      Thomas Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-10-04.
" @Last Change: 2007-10-04.
" @Revision:    0.0.43

if &cp || exists("loaded_hookcursormoved_autoload")
    finish
endif
let loaded_hookcursormoved_autoload = 1


function! s:RunHooks(mode, condition) "{{{3
    let b:hookcursormoved_currpos = getpos('.')
    try
        let did_something = 0
        if exists('*HookCursorMoved_'. a:condition) && HookCursorMoved_{a:condition}(a:mode)
            for namespace in g:hookcursormoved_namespaces
                let var = namespace .':hookcursormoved_'. a:condition
                if exists(var)
                    let did_something = 1
                    for HookFn in {var}
                        " TLogVAR HookFn
                        keepjumps keepmarks call call(HookFn, [a:mode])
                        unlet HookFn
                    endfor
                    break
                endif
            endfor
        endif
    finally
        if did_something
            call setpos('.', b:hookcursormoved_currpos)
        endif
        let b:hookcursormoved_oldpos = b:hookcursormoved_currpos
    endtry
endf


function! hookcursormoved#Enable(condition) "{{{3
    if !exists('b:hookcursormoved_enabled')
        let b:hookcursormoved_enabled = []
    endif
    if index(b:hookcursormoved_enabled, a:condition) == -1
        exec 'autocmd HookCursorMoved CursorMoved  <buffer> call s:RunHooks("n", '. string(a:condition) .')'
        exec 'autocmd HookCursorMoved CursorMovedI <buffer> call s:RunHooks("i", '. string(a:condition) .')'
        call add(b:hookcursormoved_enabled, a:condition)
    endif
endf


" :def: function! hookcursormoved#Register(namespace, condition, fn)
function! hookcursormoved#Register(namespace, condition, fn, ...) "{{{3
    call hookcursormoved#Enable(a:condition)
    let var  = a:namespace .':hookcursormoved_'. a:condition
    if !exists(var)
        let {var} = [a:fn]
    else
        call add({var}, a:fn)
    endif
endf


