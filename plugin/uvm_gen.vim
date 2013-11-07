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

let s:save_cpo = &cpo
set cpo&vim

" set Auther in the header
if exists("g:uvm_author")
    let s:uvm_author     = g:uvm_author
else
    let s:uvm_author     = $USER
endif

" set email address in the header
if exists("g:uvm_email")
    let s:uvm_email      = g:uvm_email
else
    let s:uvm_email      = s:uvm_author . "@gmail.com"
endif

" set company in the header
if exists("g:uvm_company")
    let s:uvm_company    = g:uvm_company
else
    let s:uvm_company    = ""
endif

" set deparment in the header
if exists("g:uvm_department")
    let s:uvm_department = g:uvm_department
else
    let s:uvm_department = ""
endif
" comment line
let s:uvm_linecomment    = "//"
let s:uvm_seprateline    = "----------------------------------------------------------------------"
let s:uvm_copyright      = "All rights reserved."
let s:uvm_filename       = "File     : " . expand("%:t")
let s:header_author      = "Author   : " . s:uvm_author
let s:header_email       = "EMail    : " . s:uvm_email
let s:uvm_created        = "Created  : " . strftime ("%Y-%m-%d %H:%M:%S")
let s:uvm_modified       = "Modified : " . strftime ("%Y-%m-%d %H:%M:%S")
let s:uvm_description    = "Description : {:HERE:}"
let s:uvm_history        = "History:"
let s:uvm_history_author = "    Author   : " . s:uvm_author
let s:uvm_history_date   = "    Date     : " . strftime ("%Y-%m-%d %H:%M:%S")
let s:uvm_history_rev    = "    Revision : 1.0"

" List of all types
let s:type_list = ["agent","config","driver","env","monitor","sequence","test","top","transaction"]

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

" Load the template, and read it
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

" make a header
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

function! UVMEnv(name)
    let a:template_filename = "uvm_env.sv"
    let a:template = s:default_template_dir . "/" . a:template_filename
    let a:uppername = toupper(a:name)

    call s:UVMAddHeader()
    call <SID>TLoadCmd(a:template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", a:uppername)
    call <SID>TPutCursor()
endfunction

function! UVMTest(name)
    let a:template_filename = "uvm_test.sv"
    let a:template = s:default_template_dir . "/" . a:template_filename
    let a:uppername = toupper(a:name)

    call s:UVMAddHeader()
    call <SID>TLoadCmd(a:template)
    if (a:name == "base")
        let a:name_temp = "test_" . a:name
        let a:parent_name = "uvm_test"
    else
        let a:name_temp = a:name . "_test"
        let a:parent_name = "test_base"
    endif
    call <SID>TExpand("NAME", a:name_temp)
    call <SID>TExpand("PARENT", a:parent_name)
    call <SID>TExpand("UPPERNAME", a:uppername)
    call <SID>TPutCursor()
endfunction

function! UVMAgent(name)
    let a:template_filename = "uvm_agent.sv"
    let a:template = s:default_template_dir . "/" . a:template_filename
    let a:uppername = toupper(a:name)

    call s:UVMAddHeader()
    call <SID>TLoadCmd(a:template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", a:uppername)
    call <SID>TPutCursor()
endfunction

function! UVMDriver(name)
    let a:template_filename = "uvm_driver.sv"
    let a:template = s:default_template_dir . "/" . a:template_filename
    let a:uppername = toupper(a:name)

    call s:UVMAddHeader()
    call <SID>TLoadCmd(a:template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", a:uppername)
    call <SID>TPutCursor()
endfunction

function! UVMMon(name)
    let a:template_filename = "uvm_monitor.sv"
    let a:template = s:default_template_dir . "/" . a:template_filename
    let a:uppername = toupper(a:name)

    call s:UVMAddHeader()
    call <SID>TLoadCmd(a:template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", a:uppername)
    call <SID>TPutCursor()
endfunction

function! UVMSeq(name)
    let a:template_filename = "uvm_sequence.sv"
    let a:template = s:default_template_dir . "/" . a:template_filename
    let a:uppername = toupper(a:name)

    call s:UVMAddHeader()
    call <SID>TLoadCmd(a:template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", a:uppername)
    call <SID>TPutCursor()
endfunction

function! UVMTr(name)
    let a:template_filename = "uvm_transaction.sv"
    let a:template = s:default_template_dir . "/" . a:template_filename
    let a:uppername = toupper(a:name)

    call s:UVMAddHeader()
    call <SID>TLoadCmd(a:template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", a:uppername)
    call <SID>TPutCursor()
endfunction

function! UVMTop(name)
    let a:template_filename = "uvm_test_top.sv"
    let a:template = s:default_template_dir . "/" . a:template_filename
    let a:uppername = toupper(a:name)

    call s:UVMAddHeader()
    call <SID>TLoadCmd(a:template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", a:uppername)
    call <SID>TPutCursor()
endfunction

function! UVMConfig(name)
    let a:template_filename = "uvm_config.sv"
    let a:template = s:default_template_dir . "/" . a:template_filename
    let a:uppername = toupper(a:name)

    call s:UVMAddHeader()
    call <SID>TLoadCmd(a:template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", a:uppername)
    call <SID>TPutCursor()
endfunction

" According to the args, call different methods
"
function UVMGen(type, name)
" function UVMGen(...)
"     let a:args_num = a:0
"     let a:type = a:1
"     let a:name = a:2
    if (a:type== "agent")
        call UVMAgent(a:name)
    elseif (a:type== "config")
        call UVMConfig(a:name)
    elseif (a:type== "driver")
        call UVMDriver(a:name)
    elseif (a:type== "env")
        call UVMEnv(a:name)
    elseif (a:type== "monitor") || (a:type == "mon")
        call UVMMon(a:name)
    elseif (a:type== "sequence") || (a:type == "seq")
        call UVMSeq(a:name)
    elseif (a:type== "test")
        call UVMTest(a:name)
    elseif (a:type== "top")
        call UVMTop(a:name)
    elseif (a:type== "transaction") || (a:type == "tr")
        call UVMTr(a:name)
    else
        echo "The first ARG, Please following the instructions:"
        echo " agent            - Generate UVM Agent"
        echo " config           - Generate UVM Config"
        echo " driver           - Generate UVM Driver"
        echo " env              - Generate UVM Env"
        echo " monitor / mon    - Generate UVM Monitor"
        echo " sequence / seq   - Generate UVM Sequence"
        echo " test             - Generate UVM Test"
        echo " top              - Generate UVM Top"
        echo " transaction / tr - Generate UVM Sequence Item"
    endif
endf

" Return types name as arguments
function ReturnTypesList(A,L,P)
    return s:type_list
endf

" === plugin commands === {{{
command -nargs=0 UVMAddHeader call s:UVMAddHeader()
command -nargs=1 UVMEnv call UVMEnv("<args>")
command -nargs=1 UVMTest call UVMTest("<args>")
command -nargs=1 UVMAgent call UVMAgent("<args>")
command -nargs=1 UVMDriver call UVMDriver("<args>")
command -nargs=1 UVMMon call UVMMon("<args>")
command -nargs=1 UVMSeq call UVMSeq("<args>")
command -nargs=1 UVMTr call UVMTr("<args>")
command -nargs=1 UVMTop call UVMTop("<args>")
command -nargs=1 UVMConfig call UVMConfig("<args>")
command -nargs=+ -complete=customlist,ReturnTypesList UVMGen call UVMGen(<f-args>)
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
