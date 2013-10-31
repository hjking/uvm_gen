" Vim Plugin for UVM Code Automactic Generation
" Language:     SystemVerilog
" Maintainer:   Hong Jin <hon9jin@gmail.com>
" Version:      0.10
" Last Update:  2013-10-31 08:37
" For version 7.x or above

if (exists("g:uvm_plugin_loaded") && g:uvm_plugin_loaded)
   finish
endif
let g:uvm_plugin_loaded = 1

if !exists("g:uvm_author")
    let g:uvm_author     = $USER
endif
if !exists("g:uvm_email")
    let g:uvm_email      = g:uvm_author . "@Fiberhome.com.cn"
endif
let s:uvm_linecomment    = "//"
let s:uvm_seprateline    = "----------------------------------------------------------------------"
if !exists("g:uvm_company")
    let g:uvm_company    = " Copyright (c) 2013, Fiberhome Telecommunication Technology Co., Ltd."
endif
if !exists("g:uvm_department")
    let g:uvm_department = " Microelectronics Dept. Verification Group."
endif
let s:uvm_copyright      = " All rights reserved."
let s:uvm_filename       = " File     : " . expand("%:t")
let s:header_author      = " Author   : " . g:uvm_author
let s:header_email       = " EMail    : " . g:uvm_email
let s:uvm_created        = " Created  : " . strftime ("%Y-%m-%d %H:%M:%S")
let s:uvm_modified       = " Modified : " . strftime ("%Y-%m-%d %H:%M:%S")
let s:uvm_description    = " Description :"
let s:uvm_history        = " History:"
let s:uvm_history_author = "     Author   : " . g:uvm_author
let s:uvm_history_date   = "     Date     : " . strftime ("%Y-%m-%d %H:%M:%S")
let s:uvm_history_rev    = "     Revision : 1.0"

function s:UVMAddHeader()
  call append (0,  s:uvm_linecomment . " " . s:uvm_seprateline)
  call append (1,  s:uvm_linecomment . " " . g:uvm_company)
  call append (2,  s:uvm_linecomment . " " . g:uvm_department)
  call append (3,  s:uvm_linecomment . " " . s:uvm_copyright)
  call append (4,  s:uvm_linecomment)
  call append (5,  s:uvm_linecomment . " " . s:uvm_filename)
  call append (6,  s:uvm_linecomment . " " . s:header_author)
  call append (7,  s:uvm_linecomment . " " . s:header_email)
  call append (8,  s:uvm_linecomment . " " . s:uvm_created)
  call append (9,  s:uvm_linecomment . " " . s:uvm_modified)
  call append (10, s:uvm_linecomment . " " . s:uvm_description)
  call append (11, s:uvm_linecomment . " " . s:uvm_seprateline)
  call append (12, s:uvm_linecomment . " " . s:uvm_history)
  call append (13, s:uvm_linecomment . " " . s:uvm_history_author)
  call append (14, s:uvm_linecomment . " " . s:uvm_history_date)
  call append (15, s:uvm_linecomment . " " . s:uvm_history_rev)
  call append (16, s:uvm_linecomment . " " . s:uvm_seprateline)
  call append (17, "")

  echo "Successfully added the header!"
endfunction
command! -nargs=0 UVMAddHeader :call s:UVMAddHeader()

function UVMEnv()
    call setline('.', "class test_env extends uvm_env;")
    normal o
    call setline('.', "")
    normal o
    call setline('.', s:uvm_linecomment.s:uvm_seprateline)
    normal o
    call setline('.', s:uvm_linecomment."")
    normal o
    call setline('.', s:uvm_linecomment.s:uvm_seprateline)
    normal o
    call setline('.', "    function new(string name, uvm_component parent);")
    normal o
    call setline('.', "        super.new(name, parent);")
    normal o
    call setline('.', "")
    normal o
    call setline('.', "     endfunction")
    normal o
    call setline('.', "")
    normal o
    call setline('.', "endclass")
    normal o
endfunction
