bits 64;

%define STDOUT 1
%define WRITE 1

%define MAX_LEN 255

section .data
    enter_ db 10

section .bss
    input_len resq 1
    first_len resq 1
    second_len resq 1

    output resb MAX_LEN
    first_word resb MAX_LEN
    second_word resb MAX_LEN

    input_start resq 1

    first resq 1
    second resq 1

section .text
global swap_words

swap_words:
    mov [input_start], rdi
    mov [input_len], rsi
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
    jle end

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

form_result:
    mov rsi, input_start
    mov rdi, output
    mov rcx, input_len
    mov rdx, 1

result_loop:
    cmp rdx, [first]
    je add_second

    cmp rdx, [second]
    je add_first
    
    movsb
    cmp byte[rsi], ' '
    jne next
    
    inc rdx

next:   
    dec rcx
    jmp result_loop

add_first:

add_second:

end:
    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, first_word
    mov rdx, [first_len]
    syscall

    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, enter_
    mov rdx, 1
    syscall

    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, second_word
    mov rdx, [second_len]
    syscall

    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, enter_
    mov rdx, 1
    syscall
    ret

process_word:
    push rcx
    mov rcx, rsi
    sub rcx, rax
    mov [rbx], rcx
    push rsi
    mov rsi, rax

    cld
    rep movsb

    pop rsi
    pop rcx
    ret
