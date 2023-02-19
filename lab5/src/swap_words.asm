bits 64;

section .data
    msg db "Asm successfully called",10
    msg_len equ $-msg

section .bss

section .text
global swap_words

swap_words:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msg_len
    syscall
    ret
