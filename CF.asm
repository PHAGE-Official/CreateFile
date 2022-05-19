;------------------------------------------------------------------------------------
;			これはCF.EXEのソースコードです
;			The source File of CF.EXE (CreateFile)
;			Это исходный код CF.EXE
;			此文件是CF.EXE的源码
;
;					Copy all Rights(C) 2022 NLTech Coporation
;					Current Version:0.0.1_dev_alpha
;					Create Data:2022-05-19
;					Original Author:ES
;					Last update time:2022-05-19
;
;					*Change logs*
;			2022:-05-19:File created		
;
;------------------------------------------------------------------------------------

assume cs:code,ds:data,ss:stack

;====================================Data Segment====================================

data segment

	LBA_Data_Reg		 equ 01F0H
	LBA_Feature_Reg 	 equ 01F1H
	LBA_Sector_Cout_Reg  equ 01F2H

	LBA_Low_Address_Reg  equ 01F3H
	LBA_Mid_Address_Reg  equ 01F4H
	LBA_High_Address_Reg equ 01F5H

	LBA_Device_Reg		 equ 01F6H
	LBA_Command_Reg		 equ 01F7H

data ends

;=====================================Stack Segment==================================

stack segment

	db 0020h dup(0)

stack ends

;=====================================Code Segment===================================

code segment

main:
	mov ax,stack
	mov ss,ax
	mov ax,data
	mov ds,ax
	mov ax,0000h
	call Disk_Sector_Set
	mov al,11100000b  ;the low 4-bit are used as an extension address for LBA address
					  ;the bit7 & bit5 should always set 1
					  ;the bit6 is used to select LBA(1) or CHS(0)
					  ;the bit4 means whether you need to select a drive(usually not)
	push ax
	mov al,00000010b
	push ax
	mov al,00000000b
	push ax
	mov al,00000001b
	push ax
	call Disk_LBA_Address_Set
	mov ax,4c00h
	int 21h
	

;--Disk_Sector_Set------------------------------------------------------------------
;
;Description:Save the count of how many sectors you want to read in the al regeister
;Possible Value: (al)0~255
;Use reg:al,dx
;-----------------------------------------------------------------------------------

Disk_Sector_Set proc

	push dx
	mov dx,LBA_Sector_Cout_Reg
	out dx,al
	pop dx
	ret

Disk_Sector_Set endp

;--Disk_LBA_Address_Set--------------------------------------------------------------
;
;Description:Read from the address you specified
;Tips:It's very DANGEROUS to operate LBA Address without set up Sector Count!!!
;Possible Valur:0x0000000000000000000000000000~0xffffffffffffffffffffffffffff
;Use reg:ax,ss,sp
;------------------------------------------------------------------------------------

Disk_LBA_Address_Set proc

	pop ax
	mov dx,LBA_Low_Address_Reg
	out dx,al
	pop ax
	mov dx,LBA_Mid_Address_Reg
	out dx,al
	pop ax
	mov dx,LBA_High_Address_Reg
	out dx,al
	pop ax
	mov dx,LBA_Device_Reg
	out dx,al
	ret

Disk_LBA_Address_Set endp

code ends
end  main