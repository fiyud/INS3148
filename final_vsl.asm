#make_bin#
org 100h

my_data segment
    CONTROL         EQU 06H  
    PORTA           EQU 00H   
    PB              EQU 02H  
    PC              EQU 04H   
    LCD_RS_MASK     EQU 01H  
    LCD_E_MASK      EQU 02H   
my_data ends

mycode segment
    assume cs:mycode, ds:my_data
    mov ax, my_data
    mov ds, ax

Start:
    mov dx, CONTROL
    mov al, 10000010b
    out dx, al

    call LCD_INIT

again:
    mov dx, PB
    in al, dx
    mov [2000h], al

    mov al, [2000h]
    test al, 1
    jnz odd_number

    mov bl, 2
    mul bl
    jmp store_result

odd_number:
    mov bl, 2
    mul bl
    dec al

store_result:
    mov [2000h], al

    mov bl, 10
    mov ah, 0
    div bl
    mov [1032h], al  
    mov [1031h], ah   

    call LCD_SET_COMMAND
    mov al, 80h        
    call LCD_SEND

    call LCD_SET_DATA
    mov al, 'T'
    call LCD_SEND
    mov al, 'e'
    call LCD_SEND
    mov al, 'm'
    call LCD_SEND
    mov al, 'p'
    call LCD_SEND
    mov al, '='
    call LCD_SEND
    mov al, ' '
    call LCD_SEND

    mov al, [1032h]
    add al, '0'
    call LCD_SEND

    mov al, [1031h]
    add al, '0'
    call LCD_SEND

    mov al, 0DFh
    call LCD_SEND
    mov al, 'C'
    call LCD_SEND

    call DELAY
    jmp again

LCD_SET_COMMAND:
    mov al, 0
    out PC, al        
    ret

LCD_SET_DATA:
    mov al, LCD_RS_MASK
    out PC, al       
    ret

LCD_SEND:
    out PORTA, al    

    in al, PC
    or al, LCD_E_MASK
    out PC, al
    call DELAY
    and al, ~LCD_E_MASK
    out PC, al
    call DELAY
    ret

LCD_INIT:
    call LCD_SET_COMMAND
    mov al, 38h        
    call LCD_SEND

    mov al, 0Ch        
    call LCD_SEND

    mov al, 01h       
    call LCD_SEND

    mov al, 06h       
    call LCD_SEND
    ret

DELAY:
    mov cx, 0FFh
@@loop:
    nop
    loop @@loop
    ret

mycode ends
end Start
