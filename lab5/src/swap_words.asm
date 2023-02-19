bits 64;

%define MAX_LEN 255

section .data
    msg db "Asm successfully called",10
    msg_len equ $-msg

    input times MAX_LEN db 0

section .bss
    input_len resq 1
    first resq 1
    second resq 1

section .text
global swap_words

swap_words:
    mov [input_len], rsi
    mov [first], rdx
    mov [second], r10

    mov rcx, [input_len]
    mov rsi, rdi
    mov rdi, input
    cld
    rep movsb

    mov rdx, input_len
    mov rsi, input
    mov rax, 1
    mov rdi, 1
    syscall
    ret
