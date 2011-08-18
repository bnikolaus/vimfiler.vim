"=============================================================================
" FILE: vimfiler/execute.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" Last Modified: 18 Aug 2011.
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#vimfiler_execute#define()"{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'vimfiler/execute',
      \ 'description' : 'candidates from vimfiler execute list',
      \ 'hooks' : {},
      \ 'is_listed' : 0,
      \ }

function! s:source.hooks.on_init(args, context)"{{{
  if &filetype !=# 'vimfiler'
    return
  endif

  let a:context.source__file = vimfiler#get_file(line('.'))
endfunction"}}}

function! s:source.gather_candidates(args, context)"{{{
  if !has_key(a:context, 'source__file')
    return []
  endif

  " Search user execute file.
  let l:ext = a:context.source__file.vimfiler__extension
  if !has_key(g:vimfiler_execute_file_list, l:ext)
    return []
  endif

  let l:candidates = []
  let l:commands = g:vimfiler_execute_file_list[l:ext]
  for l:command in type(l:commands) == type([]) ?
        \ l:commands : [l:commands]
    let l:dict = { 'word' : l:command }

    if l:command ==# 'vim'
      " Edit with vim.
      let l:dict.kind = 'file'
      let l:dict.action__path = a:context.source__file.action__path
    else
      let l:dict.kind = 'guicmd'
      let l:dict.action__path = l:command
      let l:dict.action__args = [a:context.source__file.action__path]
    endif

    call add(l:candidates, l:dict)
  endfor

  return l:candidates
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
