bits 64;

%include "../io.asm"

%define STDIN 0
%define READ 0
%define STDOUT 1
%define WRITE 1
%define EXIT 60

%define ROW_LENGTH 5
%define MIN -32768
%define MATRIX_SIZE 25

section .data
    prompt db "Enter 5*5 matrix:", 10
    prompt_len equ $-prompt

    err_line db "Each line should have exactly 5 numbers divided by spaces", 10
    err_line_len equ $-err_line

    err_num db "Only numbers and spaces can be entered", 10
    err_num_len equ $-err_num

    output times 8 db 0 

    input times 32 db 0
    input_len equ $-input

    matrix times MATRIX_SIZE dq 0

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

    mov rcx, ROW_LENGTH
    xor rdi, rdi

read_line:
    push rcx
    push rdi

    mov rax, READ
    mov rdi, STDIN
    mov rsi, input
    mov rdx, input_len
    syscall

    pop rdi

    mov rcx, rax
    xor rdx, rdx
    xor r10, r10

process_line:
    cmp byte[input + rdx], 10
    je process_number

    cmp byte[input + rdx], ' '
    jne next

    mov byte[input + rdx], 10
    cmp r10, rdx
    jne process_number
    jmp next

process_number:
    push rdx

    call StrToInt64
    cmp rbx, 0
    jne error_num

    cmp rdi, MATRIX_SIZE
    jge error_line

    mov [matrix + 8 * rdi], rax
    inc rdi

    pop rdx
    mov r10, rdx
    inc r10
    lea rsi, [input + r10]

next:
    inc rdx
    loop process_line

    pop rcx

    mov rax, ROW_LENGTH
    sub rax, rcx
    inc rax
    push rdx
    mov rdx, ROW_LENGTH
    mul rdx
    pop rdx

    cmp rdi, rax
    jne error_line

    dec rcx
    cmp rcx, 0
    jne read_line

; logic starts here    
    mov rcx, ROW_LENGTH
    mov rax, MIN
    xor rdx, rdx

matrix_loop:
    mov rbx, rcx
    mov rcx, ROW_LENGTH
inner_loop:
    cmp rbx, rcx
    jle skip

    cmp [matrix + rdx * 8], rax 
    jle skip

    mov rax, [matrix + rdx * 8]
skip:
    inc rdx
    loop inner_loop

    mov rcx, rbx
    loop matrix_loop

    mov rsi, output
    call IntToStr64

    mov rdx, rax
    mov rax, WRITE
    mov rdi, STDOUT   
    syscall

exit:
    xor rdi, rdi
    mov rax, EXIT
    syscall

error_line:
    mov rax, WRITE
    mov rdi, STDOUT   
    mov rsi, err_line
    mov rdx, err_line_len
    syscall
    jmp exit

error_num:
    mov rax, WRITE
    mov rdi, STDOUT   
    mov rsi, err_num
    mov rdx, err_num_len
    syscall
    jmp exit
