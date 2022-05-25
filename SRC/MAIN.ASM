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
    coc03 db "Console:"

;The following value is the length of each CLI word
    coc01_len equ 0026d
    coc02_len equ 0023d
    coc03_len equ 0008d

;The following String is Console
    con01 db "you can type in 'h' for help"

;The following value is the length of each Console word
    con01_len equ 0028d

;The following String is Console elp Message and code

    che01 db "(h)help"
    che02 db "(l)list"
    che03 db "(q)quit"
    che04 db "(f)File Check"

;The following value is the length of each Help word

    che01_len equ 0007d
    che02_len equ 0007d
    che03_len equ 0007d
    che04_len equ 0013d


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

    mov bx,OFFSET coc01    ;adr pointer
    mov dh,0002h    ;color pointer
    mov bp,0036h    ;position pointer
    mov cx,coc01_len
    call Direct_String_Opt

    mov bx,OFFSET coc02
    mov bp,00a0h
    mov cx,coc02_len
    call Direct_String_Opt

    call Key_In


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
    ;           SP Registr to 0014h
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

    ;- Direct_String_Opt ----------------
    ;Description:
    ;   This Function print the character
    ;   in the current ds:[bx] directly 
    ;   on the screen.
    ;
    ;Registr Using:
    ;   This Function accept parameter in
    ;   the following registers
    ;
    ;   |-BX:String address pointer
    ;   |
    ;   |-CX:character counter
    ;   |
    ;   |-DH:color pointer
    ;   |
    ;   |-BP:screen position pointer
    ;
    ;------------------------------------

    push ax
    mov ax,0b800h
    mov es,ax

    l0:
        mov al,ds:[bx]
        mov ah,dh
        mov es:[bp],ax
        add bp,0002h    ;next screen position
        inc bx          ;next character address

    loop l0

    pop ax

    ret

Direct_String_Opt endp

Key_In proc

    mov ah,01h
    int 21h
    cmp al,0dh  ;The ascii code of enter
    jz Key_Restore
    jnz Key_Next
    
    Key_Restore:
        ret

    Key_Next:
        cmp  al,0063h   ;compare with 'c'
        jz Command_Console
        push ax
        call Stack_Protect  ;check stack
        jmp Key_In

Key_In endp

Command_Console proc

;----------------------------------------
;Description:
;       This is the entrance of the
;       cf console.
;
;----------------------------------------

    mov bx,offset coc03
    mov cx,coc03_len
    mov bp,0140h
    mov dh,0bh
    call Direct_String_Opt

    mov bx,OFFSET con01
    mov cx,con01_len
    mov bp,01e0h
    mov dh,04h
    call Direct_String_Opt
    
    call Console_In
    ret

Command_Console endp

Console_In proc
    
    mov cx,0000h    ;initialize counter
    mov ah,01h
    int 21h
    cmp al,0071h      ;'q' to quit
    jz Console_Quit
    cmp al,0068h      ;'h' to quit
    jz Console_Help
    jnz Char_Save

    Char_Save:
        
        push ax
        call Stack_Protect
        add sp,2
        call Console_In

    Console_Quit:
        
        mov ax,4c00h
        int 21h

    Console_Help:
        
        mov bx,offset che01
        mov cx,che01_len
        mov dh,0ah
        mov bp,0280h
        call Direct_String_Opt

        mov bx,offset che02
        mov cx,che02_len
        mov bp,0290h
        call Direct_String_Opt

        mov bx,offset che03
        mov cx,che03_len
        mov bp,02a0h
        call Direct_String_Opt

        mov bx,offset che04
        mov cx,che04_len
        mov bp,02b0h
        call Direct_String_Opt

        call Console_In

Console_In endp

code ends

end  main
