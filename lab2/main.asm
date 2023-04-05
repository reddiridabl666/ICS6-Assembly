BITS 64;

%include "../io.asm"

%define STDIN 0
%define READ 0
%define STDOUT 1
%define WRITE 1
%define EXIT 60

section .data
    prompt db "Enter numbers a, b, y each in its own line:", 10
    prompt_len equ $-prompt

    zero_error db "Zero division error", 10
    zero_error_len equ $-zero_error

    err_msg db "Error: make sure that each line is a single number",10
    err_len equ $-err_msg

    buff times 8 db 0 

    input times 16 db 0
    input_len equ $-input

section .bss
    f resq 1
    read_counter resb 1

    a resq 1
    b resq 1
    y resq 1

section .text
global _start

_start:
    mov eax, WRITE
    mov edi, STDOUT
    mov esi, prompt
    mov edx, prompt_len
    syscall

    mov eax, READ
    mov edi, STDIN
    mov esi, input
    mov edx, input_len
    syscall

    call StrToInt64
    cmp ebx, 0
    jne error
    mov [a], eax

    mov eax, READ
    mov edx, input_len
    syscall

    call StrToInt64
    cmp ebx, 0
    jne error
    mov [b], eax

    mov eax, READ
    mov edx, input_len
    syscall

    call StrToInt64
    cmp ebx, 0
    jne error
    mov [y], eax

    mov eax, [a]
    imul qword [a]
    sub eax, [b]

    mov ebx, [y]
    add ebx, [a]

    cmp ebx, 0
    je zero
    
    cqo
    idiv ebx
    mov [f], eax

    mov eax, [a]
    dec eax
    mul eax

    add eax, [f]

    mov esi, buff
    call IntToStr64

    mov edx, eax
    mov eax, WRITE
    mov edi, STDOUT   
    syscall

exit:
    xor edi, edi
    mov eax, EXIT
    syscall

error:
    mov eax, WRITE
    mov edi, STDOUT
    mov esi, err_msg
    mov edx, err_len
    syscall
    jmp exit

zero:
    mov eax, WRITE
    mov edi, STDOUT
    mov esi, zero_error
    mov edx, zero_error_len
    syscall
    jmp exit
