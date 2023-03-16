bits 64;

%define STDOUT 1
%define WRITE 1
%define EXIT 60

%define MAX_LEN 255

section .data
    err_msg db "Invalid word position",10
    err_len equ $-err_msg

section .bss
    input_len resq 1
    first_len resq 1
    second_len resq 1

    output resb MAX_LEN + 1
    first_word resb MAX_LEN
    second_word resb MAX_LEN

    input_start resq 1

    first resq 1
    second resq 1

section .text
global swap_words
extern print_exchanged

swap_words:
    mov [input_start], rdi
    mov [input_len], rsi

    cmp rdx, rcx
    jle less
    xchg rdx, rcx

less:
    cmp rdx, 0
    jle error

    mov [first], rdx
    mov [second], rcx

    mov rcx, [input_len]
    mov rsi, [input_start]
    mov rax, rsi
    mov rdi, output
    xor rdx, rdx

find_space:
    dec rcx
    cmp rcx, 0
    jle error

    inc rsi

    cmp byte[rsi], ' '
    jne find_space

    inc rdx
    inc rsi

    cmp rdx, [first]
    je process_first

    cmp rdx, [second]
    je process_second

    mov rax, rsi
    jmp find_space

process_first:
    mov rdi, first_word
    mov rbx, first_len
    call process_word
    jmp find_space

process_second:
    mov rdi, second_word
    mov rbx, second_len
    call process_word
    jmp form_result

process_word:
    push rcx
    mov rcx, rsi
    sub rcx, rax
    dec rcx
    mov [rbx], rcx
    push rsi
    mov rsi, rax

    cld
    rep movsb

    pop rsi
    pop rcx
    mov rax, rsi
    ret

form_result:
    mov rsi, [input_start]
    mov rdi, output
    mov rcx, [input_len]
    mov rdx, 1
result_loop:
    cmp rcx, 0
    jle end

    cmp rdx, [first]
    je add_second

    cmp rdx, [second]
    je add_first
    
    cld
    movsb

    cmp byte[rsi], ' '
    jne next
    inc rdx
    movsb

next:
    dec rcx
    jmp result_loop

add_first:
    mov rax, [second_len]
    mov rbx, first_word
    mov r10, [first_len]

    call add_word
    jmp result_loop
    
add_second:
    mov rax, [first_len]
    mov rbx, second_word
    mov r10, [second_len]

    call add_word
    jmp result_loop

add_word:
    add rsi, rax
    sub rcx, rax
    push rcx
    push rsi
    mov rsi, rbx
    mov rcx, r10

    cld
    rep movsb

    pop rsi
    pop rcx

    movsb
    inc rdx
    ret

end:
    ; mov rbx, [first_len]
    ; mov byte[first_word + rbx], 0

    ; mov rbx, [second_len]
    ; mov byte[second_word + rbx], 0

    mov rdi, first_word
    mov rsi, second_word
    call print_exchanged

    ; mov rax, [input_len]
    ; mov byte[output + rax - 1], 0
    mov rax, output
    ret

error:
    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, err_msg
    mov rdx, err_len
    syscall

    mov rdx, -1
    mov rax, EXIT
    syscall
