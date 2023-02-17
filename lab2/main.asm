BITS 64;

%include "../io.asm"

%define STDIN 0
%define READ 0
%define STDOUT 1
%define WRITE 1
%define EXIT 60

%define ZERO 0x30
%define NINE 0x39

%define a qword numbers[0]
%define b qword numbers[8]
%define y qword numbers[16]

section .data
    prompt db "Enter numbers a, b, y:", 10
    prompt_len equ $-prompt

    ; a dq 5
    ; b dq 4
    ; y dq 2

    buff times 8 db 0 

    input times 16 db 0
    input_len equ $-input

section .bss
    f resq 1
    read_counter resb 1

    ; a resq 1
    ; b resq 1
    ; y resq 1
    numbers resq 3

section .text
global _start

_start:
    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

mov byte[read_counter], 3

read_number:
    mov rax, READ
    mov rdi, STDIN
    mov rsi, input
    mov rdx, input_len
    syscall

    call StrToInt64

    mov rdx, [read_counter]
    mov [numbers + rdx * 8], rax

    dec byte[read_counter]
    cmp byte[read_counter], 0
    jg read_number

    mov rsi, [input + 8]
    call StrToInt64
    mov b, rax

    mov rsi, [input + 8]
    call StrToInt64
    mov y, rax

    mov rax, a
    mul qword a
    sub rax, b

    mov rbx, y
    add rbx, a

    cqo
    div rbx
    mov [f], rax

    mov rax, a
    dec rax
    mul rax

    add rax, [f]

    mov rsi, buff
    call IntToStr64

    mov rdx, rax
    mov rax, WRITE
    mov rdi, STDOUT   
    syscall

    xor rdi, rdi
    mov rax, EXIT
    syscall
