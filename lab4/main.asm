bits 64;

%include "../io.asm"

%define STDIN 0
%define READ 0
%define STDOUT 1
%define WRITE 1
%define EXIT 60

section .data
    prompt db "Enter matrix 5*5:", 10
    prompt_len equ $-prompt

    output times 8 db 0 

    input times 32 db 0
    input_len equ $-input

    matrix times 25 dq 0

section .bss
    res resq 1

section .text
global _start

_start:
    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

    mov rax, READ
    mov rdi, STDIN
    mov rsi, input
    mov rdx, input_len
    syscall

    mov rax, res
    mov rsi, output
    call IntToStr64

    mov rdx, rax
    mov rax, WRITE
    mov rdi, STDOUT   
    syscall

    xor rdi, rdi
    mov rax, EXIT
    syscall
