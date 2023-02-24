bits 64;

%include "../io.asm"

%define STDIN 0
%define READ 0
%define STDOUT 1
%define WRITE 1
%define EXIT 60

%define INPUT_LEN 255
%define NEEDED 3

section .data
    prompt db "Input a line of 255 or less characters",10
    prompt_len equ $-prompt

section .bss
    input resb INPUT_LEN
    output resb 3

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
    mov rdx, INPUT_LEN
    syscall

    mov rcx, rax
    xor rdx, rdx     ; 'A' count
    xor rax, rax    ; needed words count
    dec rsi

main_loop:
    inc rsi
    dec rcx
    cmp rcx, 0
    jl end

    cmp byte[rsi], ' '
    jne next

    cmp rax, NEEDED
    xor rdx, rdx
    jl main_loop
    inc rax

next:
    cmp byte[rsi], 'A'
    jne main_loop
    inc rdx
    jmp main_loop

end:
    mov rsi, output
    call IntToStr64

    mov rdx, rax
    mov rax, WRITE
    mov rdi, STDOUT
    syscall

    xor rdi, rdi
    mov rax, EXIT
    syscall
