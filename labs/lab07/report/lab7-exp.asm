section .data
    promptA db "A: ", 0
    promptB db "B: ", 0
    promptC db "C: ", 0
    result db "The smallest number is: ", 0
    newline db 0xA, 0          ; Newline character for output
    inputBuffer db 10, 0       ; Buffer for user input

section .bss
    A resd 1                  ; Space for variable A
    B resd 1                  ; Space for variable B
    C resd 1                  ; Space for variable C
    smallest resd 1           ; Space for the smallest value

section .text
    global _start

_start:
    ; Prompt and input A
    mov eax, 4                 ; syscall: write
    mov ebx, 1                 ; file descriptor: stdout
    mov ecx, promptA           ; Message to print
    mov edx, 3                 ; Message length
    int 0x80                   ; Make the system call

    mov eax, 3                 ; syscall: read
    mov ebx, 0                 ; file descriptor: stdin
    mov ecx, inputBuffer       ; Buffer for input
    mov edx, 10                ; Max input size
    int 0x80                   ; Make the system call
    call str_to_int            ; Convert input to integer
    mov [A], eax               ; Store the result in A

    ; Prompt and input B
    mov eax, 4
    mov ebx, 1
    mov ecx, promptB
    mov edx, 3
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, inputBuffer
    mov edx, 10
    int 0x80
    call str_to_int
    mov [B], eax

    ; Prompt and input C
    mov eax, 4
    mov ebx, 1
    mov ecx, promptC
    mov edx, 3
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, inputBuffer
    mov edx, 10
    int 0x80
    call str_to_int
    mov [C], eax

    ; Find the smallest value
    mov eax, [A]               ; Load A into EAX
    mov ebx, [B]               ; Load B into EBX
    cmp eax, ebx
    jle .check_c
    mov eax, ebx               ; If B < A, move B into EAX

.check_c:
    mov ebx, [C]               ; Load C into EBX
    cmp eax, ebx
    jle .found_smallest
    mov eax, ebx               ; If C < (A or B), move C into EAX

.found_smallest:
    mov [smallest], eax        ; Store the smallest value

    ; Print result
    mov eax, 4                 ; syscall: write
    mov ebx, 1                 ; file descriptor: stdout
    mov ecx, result            ; Message to print
    mov edx, 25                ; Message length
    int 0x80

    mov eax, [smallest]        ; Load the smallest number into EAX
    call print_int             ; Print the smallest number

    ; Exit program
    mov eax, 1                 ; syscall: exit
    xor ebx, ebx               ; Exit code 0
    int 0x80

; ---- Helper Functions ----

str_to_int:
    xor eax, eax               ; Clear EAX
    xor ecx, ecx               ; Clear ECX
    xor ebx, ebx               ; Clear EBX
    mov esi, inputBuffer       ; Point to the input buffer

.parse_loop:
    mov bl, byte [esi]         ; Load next character
    cmp bl, 0xA                ; Check for newline
    je .done_parse
    sub bl, '0'                ; Convert ASCII to integer
    imul eax, eax, 10          ; Multiply current number by 10
    add eax, ebx               ; Add the digit to EAX
    inc esi                    ; Move to the next character
    jmp .parse_loop

.done_parse:
    ret

print_int:
    xor ecx, ecx               ; Clear ECX
    mov ebx, 10                ; Divisor for number conversion

.convert_loop:
    xor edx, edx               ; Clear EDX
    div ebx                    ; Divide EAX by 10
    add dl, '0'                ; Convert remainder to ASCII
    push dx                    ; Push digit onto stack
    inc ecx                    ; Increment digit counter
    test eax, eax              ; Check if quotient is 0
    jnz .convert_loop

.print_digits:
    dec ecx                    ; Decrement counter
    pop eax                    ; Get ASCII character
    mov edx, 1                 ; Length of character
    mov ecx, eax               ; Character to print
    call write_char
    jnz .print_digits
    ret

write_char:
    mov eax, 4                 ; syscall: write
    mov ebx, 1                 ; file descriptor: stdout
    int 0x80
    ret
