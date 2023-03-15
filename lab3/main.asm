bits 64;

%include "../io.asm"

%define STDIN 0
%define READ 0
%define STDOUT 1
%define WRITE 1
%define EXIT 60

section .data
    prompt db "Input two numbers, each on its own line",10
    prompt_len equ $-prompt

    err_msg db "Error: make sure that each line is a single number",10
    err_len equ $-err_msg

    input times 8 db 0
    input_len equ $-input

    output times 8 db 0

section .bss
    a resd 1
    c resd 1

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
    mov [c], eax

    mov eax, [a]
    cdq
    idiv dword [c]

    cmp eax, 2
    jg true
    jl false

    cmp edx, 0
    jg true
    jmp false

true:
    mov eax, [a]
    sub eax, [c]
    imul eax
    add eax, [c]

    jmp return

false:
    mov eax, [c]
    mov edx, 2
    imul edx
    add eax, [a]

return:
    mov esi, output
    call IntToStr64

    mov edx, eax
    mov eax, WRITE
    mov edi, STDOUT
    syscall

    jmp exit

error:
    mov eax, WRITE
    mov edi, STDOUT
    mov esi, err_msg
    mov edx, err_len
    syscall

exit:
    xor edi, edi
    mov eax, EXIT
    syscall
