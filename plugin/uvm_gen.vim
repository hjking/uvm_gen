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

let s:MSWIN = has("win16") || has("win32")   || has("win64")    || has("win95")
let s:UNIX = has("unix")  || has("macunix") || has("win32unix")

if exists("g:uvm_author")
    let s:uvm_author     = g:uvm_author
else
    let s:uvm_author     = $USER
endif
if exists("g:uvm_email")
    let s:uvm_email      = g:uvm_email
else
    let s:uvm_email      = s:uvm_author . "@Fiberhome.com.cn"
endif
if exists("g:uvm_company")
    let s:uvm_company    = g:uvm_company
else
    let s:uvm_company    = " Copyright (c) 2013, Fiberhome Telecommunication Technology Co., Ltd."
endif
if exists("g:uvm_department")
    let s:uvm_department = g:uvm_department
else
    let s:uvm_department = " Microelectronics Dept. Verification Group."
endif
let s:uvm_linecomment    = "//"
let s:uvm_seprateline    = "----------------------------------------------------------------------"
let s:uvm_copyright      = " All rights reserved."
let s:uvm_filename       = " File     : " . expand("%:t")
let s:header_author      = " Author   : " . s:uvm_author
let s:header_email       = " EMail    : " . s:uvm_email
let s:uvm_created        = " Created  : " . strftime ("%Y-%m-%d %H:%M:%S")
let s:uvm_modified       = " Modified : " . strftime ("%Y-%m-%d %H:%M:%S")
let s:uvm_description    = " Description : {:HERE:}"
let s:uvm_history        = " History:"
let s:uvm_history_author = "     Author   : " . s:uvm_author
let s:uvm_history_date   = "     Date     : " . strftime ("%Y-%m-%d %H:%M:%S")
let s:uvm_history_rev    = "     Revision : 1.0"

" normalize the path
" replace the windows path sep \ with /
function <SID>NormalizePath(path)
    return substitute(a:path, "\\", "/", "g")
endfunction

" Returns a string containing the path of the parent directory of the given
" path. Works like dirname(3). It also simplifies the given path.
function <SID>DirName(path)
    let l:tmp = <SID>NormalizePath(a:path)
    return substitute(l:tmp, "[^/][^/]*/*$", "", "")
endfunction

" Default templates directory
let s:default_template_dir = <SID>DirName(<SID>DirName(expand("<sfile>"))) . "templates"

" Makes a single [variable] expansion, using [value] as replacement.
"
function <SID>TExpand(variable, value)
    silent execute "%s/{:" . a:variable . ":}/" .  a:value . "/g"
endfunction

" Puts the cursor either at the first line of the file or in the place of
" the template where the %HERE% string is found, removing %HERE% from the
" template.
"
function <SID>TPutCursor()
    0  " Go to first line before searching
    if search("{:HERE:}", "W")
        let l:column = col(".")
        let l:lineno = line(".")
        silent s/{:HERE:}//
        call cursor(l:lineno, l:column)
    endif
endfunction

function <SID>TLoadCmd(template)
    if filereadable(a:template)
        " let l:tFile = a:template
        if a:template != ""
            execute "r " . a:template
            " call <SID>TExpandVars()
            " call <SID>TPutCursor()
            setlocal nomodified
        endif
    else
        echo "ERROR! Can not find" . a:template
    endif

endfunction


"
"  Look for global variables (if any), to override the defaults.
"
function! UVM_CheckGlobal ( name )
  if exists('g:'.a:name)
    exe 'let s:'.a:name.'  = g:'.a:name
  endif
endfunction    " ----------  end of function C_CheckGlobal ----------


function s:UVMAddHeader()
    call append (0,  s:uvm_linecomment . " " . s:uvm_seprateline)
    call append (1,  s:uvm_linecomment . " " . s:uvm_company)
    call append (2,  s:uvm_linecomment . " " . s:uvm_department)
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

    " call <SID>TPutCursor()
    echo "Successfully added the header!"
endfunction
command! -nargs=0 UVMAddHeader :call s:UVMAddHeader()

function! UVMEnv(name)
    let a:template_filename = "uvm_env.sv"
    let a:template = s:default_template_dir . "/" . a:template_filename

    call s:UVMAddHeader()
    call <SID>TLoadCmd(a:template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TPutCursor()
endfunction
command -nargs=1 -complete=file UVMEnv call UVMEnv("<args>")

function! UVMTest(name)
    let a:template_filename = "uvm_test.sv"
    let a:template = s:default_template_dir . "/" . a:template_filename

    call s:UVMAddHeader()
    call <SID>TLoadCmd(a:template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TPutCursor()
endfunction
command -nargs=1 -complete=file UVMTest call UVMTest("<args>")

function! UVMAgent(name)
    let a:template_filename = "uvm_agent.sv"
    let a:template = s:default_template_dir . "/" . a:template_filename

    call s:UVMAddHeader()
    call <SID>TLoadCmd(a:template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TPutCursor()
endfunction
command -nargs=1 -complete=file UVMAgent call UVMAgent("<args>")

function! UVMDriver(name)
    let a:template_filename = "uvm_driver.sv"
    let a:template = s:default_template_dir . "/" . a:template_filename

    call s:UVMAddHeader()
    call <SID>TLoadCmd(a:template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TPutCursor()
endfunction
command -nargs=1 -complete=file UVMDriver call UVMDriver("<args>")

function! UVMMon(name)
    let a:template_filename = "uvm_monitor.sv"
    let a:template = s:default_template_dir . "/" . a:template_filename

    call s:UVMAddHeader()
    call <SID>TLoadCmd(a:template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TPutCursor()
endfunction
command -nargs=1 -complete=file UVMMon call UVMMon("<args>")

function! UVMSeq(name)
    let a:template_filename = "uvm_sequence.sv"
    let a:template = s:default_template_dir . "/" . a:template_filename

    call s:UVMAddHeader()
    call <SID>TLoadCmd(a:template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TPutCursor()
endfunction
command -nargs=1 -complete=file UVMSeq call UVMSeq("<args>")

function! UVMTr(name)
    let a:template_filename = "uvm_transaction.sv"
    let a:template = s:default_template_dir . "/" . a:template_filename

    call s:UVMAddHeader()
    call <SID>TLoadCmd(a:template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TPutCursor()
endfunction
command -nargs=1 -complete=file UVMTr call UVMTr("<args>")

function! UVMTop(name)
    let a:template_filename = "uvm_test_top.sv"
    let a:template = s:default_template_dir . "/" . a:template_filename

    call s:UVMAddHeader()
    call <SID>TLoadCmd(a:template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TPutCursor()
endfunction
command -nargs=1 -complete=file UVMTop call UVMTop("<args>")

function UVMGen(type, name)
    if (a:type== "help")
        echo "Currently available templates:"
        echo " c                - Plain C Template"
        echo " make             - Makefile Template"
        echo " make-simple      - Simple Variant of the Makefile Template"
    else
        "
        if (a:type== "agent")
            call UVMAgent(a:name)
        elseif (a:type== "driver")
            call UVMDriver(a:name)
        elseif (a:type== "env")
            call UVMEnv(a:name)
        elseif (a:type== "monitor")
            call UVMMon(a:name)
        elseif (a:type== "sequence")
            call UVMSeq(a:name)
        elseif (a:type== "test")
            call UVMTest(a:name)
        elseif (a:type== "top")
            call UVMTop(a:name)
        elseif (a:type== "transaction")
            call UVMTr(a:name)
        endif
    endif
endf
command -nargs=+ UVMGen call UVMGen(<f-args>)
