;-------------------------------------------------------
;             (C) NLTech Coporation 2022
;                 All Right Reserved
;
;       Project Name:CreateFile
;       Target type:EXE
;
;       Current Version:0.0.1_dev_alpha
;
; Compiling Tips:Please compile With MASM(5.0 or higher)
;
; MASM Version:5.10
; Linker Version:3.64
;-------------------------------------------------------

;                   *Revision Log*
;
;2022-05-23:More Function added

assume cs:code,ds:data,ss:stack

data segment

;The following String is Error Message and code
    erc01 db "Fatal Error"
    erc02 db "Illegal Command"
    erc03 db "No Enough Space"

;The following value is the length of each Error Message
    erc01_len equ 0011d
    erc02_len equ 0015d
    erc03_len equ 0015d

;The following String is Warning Message and code
    wac01 db "Undefiend Command"
    wac02 db "Same File Detected"

;The following value is the length of each Warning Message
    wac01_len equ 0017d
    wac02_len equ 0018d

;The following String is Notice Message and code
    noc01 db "Successfully Generated"

;The following value is the length of each Notice Message
    noc01_len equ 0022d

;The LBA Port Data

;- LBA Registr Description ------------------------------
;|      LBA Contain 8 Registrs
;|
;--------------------------------------------------------

    LBA_Data_Reg            equ 01f0h
    LBA_Features_Reg        equ 01f1h
    LBA_Sector_Count_Reg    equ 01f2h
    LBA_Low_Address_Reg     equ 01f3h
    LBA_Mid_Address_Reg     equ 01f4h
    LBA_High_Address_Reg    equ 01f5h
    LBA_Device_Register     equ 01f6h
    LBA_Command_Register    equ 01f7h

;The following String is CLI(Command Line Interface)&code
    coc01 db "NLTech CreateFile (16-bit)"
    coc02 db "Version:0.0.1_dev_alpha"

;The following value is the length of each CLI word
    coc01_len equ 0026d
    coc02_len equ 0023d

data ends

stack segment stack

    db 0020d dup(0)

stack ends

code segment

main:
    mov ax,data
    mov ds,ax
    mov ax,stack
    mov ss,ax
    mov sp,0014h    ;protect the stack
    call Stack_Protect
    call Direct_String_Opt
    mov ax,4c00h
    int 21h

Stack_Protect proc

    ;- Stack_Protect --------------------
    ;Description:
    ;   This Function implement the 
    ;   stack pointer and stack protect
    ;
    ;Details:
    ;   If the SP Registr's value is 
    ;   less than 0, the program will
    ;   jump to the sp_Restore Function
    ;
    ;       sp_Restore:
    ;           This Function set your
    ;           SP Registr to 0014H
    ;           which is the original
    ;           value of stack pointer
    ;
    ;       sp_Restore
    ;           while sp doesn't fill
    ;           the requirement This
    ;           Function will return to
    ;           main process
    ;
    ;------------------------------------

    mov ax,sp
    sub ax,0000h
    jl  sp_Restore
    jge sp_return

    sp_Restore:
        ;reset sp
        mov sp,0014h
        ret

    sp_return:
        ret

Stack_Protect endp

Direct_String_Opt proc

    ret

Direct_String_Opt endp

code ends

end  main
