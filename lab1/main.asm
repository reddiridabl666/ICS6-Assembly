bits 64;

section .data              ; сегмент инициализированных переменных
    ExitMsg db "Press Enter to Exit",10  ; выводимое сообщение
    lenExit equ $-ExitMsg

    A dw -30
    B dw 21

    val1 db 255
    chart dw 256
    lue3 dw -128
    v5 db 10h
     db 100101B
    beta db 23, 23h, 0ch
    sdk db "Hello", 10
    min dw -32767
    valar times 5 db 8

    val dw 25
    val2 dd -35
    name db "Леонид Leonid"

    val_25_00 dw 37
    val_00_25 dw 9472
    val_00_25_2 dw 0025h

    f1 dw 65535
    f2 dd 65535

    d1 dw 5
    d2 dw -5

section .bss               ; сегмент неинициализированных переменных
    InBuf   resb    10            ; буфер для вводимой строки
    lenIn   equ     $-InBuf

    X resd 1

    alu resw 10
    fl resb 5
    
section .text         ; сегмент кода
global  _start
_start:
    mov ax, [d1]
    mov ax, [d2]

    mov EAX,[A] ; загрузить число A в регистр EAX
    add EAX,5   ; сложить EAX и 5, результат в EAX
    sub EAX,[B] ; вычесть число B, результат в EAX
    mov [X],EAX ; сохранить результат в памяти
    
    ; write
    mov     rax, 1        ; системная функция 1 (write)
    mov     rdi, 1        ; дескриптор файла stdout=1
    mov     rsi, ExitMsg  ; адрес выводимой строки
    mov     rdx, lenExit  ; длина строки
    syscall               ; вызов системной функции
    ; read
    mov     rax, 0        ; системная функция 0 (read)
    mov     rdi, 0        ; дескриптор файла stdin=0
    mov     rsi, InBuf    ; адрес вводимой строки
    mov     rdx, lenIn    ; длина строки
    syscall               ; вызов системной функции

    add word[f1], 1
    add dword[f2], 1

    ; exit
    mov     rax, 60       ; системная функция 60 (exit)
    xor     rdi, rdi      ; return code 0    
    syscall               ; вызов системной функции
