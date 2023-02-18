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

    input times 8 db 0
    input_len equ $-input

    output times 8 db 0

section .bss
    a resq 1
    c resq 1

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

    call StrToInt64
    mov [a], rax

    mov rax, READ
    mov rdx, input_len
    syscall

    call StrToInt64
    mov [c], rax

    mov rax, [a]
    cqo
    idiv qword [c]

    cmp rax, 2
    jg true
    jl false

    cmp rdx, 0
    jg true
    jmp false

true:
    mov rax, [a]
    sub rax, [c]
    mul rax
    add rax, [c]

    jmp return

false:
    mov rax, [c]
    mov rdx, 2
    mul rdx
    add rax, [a]

return:
    mov rsi, output
    call IntToStr64

    mov rdx, rax
    mov rax, WRITE
    mov rdi, STDOUT
    syscall

    xor rdi, rdi
    mov rax, EXIT
    syscall
