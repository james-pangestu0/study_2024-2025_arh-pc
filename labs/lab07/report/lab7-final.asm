





section .data
    prompt_x db "Enter value for x: ", 0
    prompt_a db "Enter value for a: ", 0
    result_msg db "The value of f(x) is: ", 0
    newline db 10, 0

section .bss
    x resb 4          ; To store x
    a resb 4          ; To store a
    result resb 4     ; To store result
    buffer resb 16    ; Temporary buffer for input/output

section .text
    global _start

_start:
    ; Prompt and read x
    mov eax, 4         ; syscall: write
    mov ebx, 1         ; file descriptor: stdout
    mov ecx, prompt_x  ; message to write
    mov edx, 18        ; message length (adjusted for neat spacing)
    int 0x80

    mov eax, 3         ; syscall: read
    mov ebx, 0         ; file descriptor: stdin
    mov ecx, buffer    ; input buffer
    mov edx, 16        ; max input size
    int 0x80
    call str_to_int    ; Convert string to integer
    mov [x], eax       ; Store input as integer in x

    ; Prompt and read a
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_a
    mov edx, 18        ; message length (adjusted for neat spacing)
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 16
    int 0x80
    call str_to_int
    mov [a], eax       ; Store input as integer in a

    ; Compute f(x)
    mov eax, [x]       ; Load x into eax
    mov ebx, [a]       ; Load a into ebx
    cmp eax, ebx       ; Compare x and a
    jl .case1          ; If x < a, jump to case1
    jmp .case2         ; Otherwise, go to case2

.case1:
    mov eax, [a]       ; Load a into eax
    imul eax, 2        ; Calculate 2a
    sub eax, [x]       ; Subtract x from 2a
    mov [result], eax  ; Store the result
    jmp .print_result

.case2:
    mov eax, 8         ; f(x) = 8
    mov [result], eax  ; Store the result
    jmp .print_result

.print_result:
    ; Print result message
    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, 23
    int 0x80

    ; Convert result to string and print it
    mov eax, [result]
    call int_to_str
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 16
    int 0x80

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Exit
    mov eax, 1         ; syscall: exit
    xor ebx, ebx       ; exit code: 0
    int 0x80

; Convert a null-terminated string in buffer to an integer
str_to_int:
    xor eax, eax       ; Clear eax for the result
    xor ebx, ebx       ; Clear ebx (used as a multiplier)
    mov ecx, buffer    ; Point ecx to the buffer

.next_char:
    mov bl, byte [ecx] ; Load the next character
    cmp bl, 10         ; Check for newline
    je .done           ; Stop if newline
    sub bl, '0'        ; Convert ASCII to digit
    imul eax, eax, 10  ; Multiply result by 10
    add eax, ebx       ; Add the digit to result
    inc ecx            ; Move to the next character
    jmp .next_char

.done:
    ret

; Convert integer in eax to a string in buffer
int_to_str:
    mov ecx, buffer    ; Point ecx to the buffer
    add ecx, 15        ; Start at the end of the buffer
    mov byte [ecx], 0  ; Null-terminate the string
    dec ecx

    test eax, eax      ; Check if number is 0
    jnz .convert
    mov byte [ecx], '0'
    dec ecx
    ret

.convert:
    xor ebx, ebx       ; Clear ebx
    mov ebx, 10        ; Set divisor to 10

.convert_loop:
    xor edx, edx       ; Clear edx for division
    div ebx            ; Divide eax by 10
    add dl, '0'        ; Convert remainder to ASCII
    mov byte [ecx], dl ; Store character in buffer
    dec ecx            ; Move to the next position
    test eax, eax      ; Check if result is 0
    jnz .convert_loop  ; Continue if not 0

    inc ecx            ; Move to the first character
    ret

























































