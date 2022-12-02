section .data:

Arr dq 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 2, 0, 0, 0, 2, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0 , 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,2
Free dq 0 ; This is the symbol for a free space where we can put a lizard
Lizard dq 1 ;This is the symbol for a free space where we can put a lizard
Tree dq 2 ;This is the symbol for a tree
UnSafe dq 3; This is the symbol for a space thats under attack
rows dq 8 ; Thiswill be used in calculations as n(number of rows or columns)
rown dq 64 ;This is the number n * size of an int which is 8 too
section .bss
buffer resb 8 ;This is used in calculations of index
row resb 8 ; This is used in calculating
col resb 8 ; This is the symbol for a free space where we can put a lizard
section .text:


global _start

_start:
mov r12, [rows] ;r12 = $t1 
mov r13, [rows]  ;r13 = $s5 to terminate infinite loop
mov r8, Arr ;r8 = $t2
mov r9, r8 ;r9 = $t5
catch_TraverseUp:
mov r10, [r9]
;Compre the element to see whether it is 0, 2, 3
cmp r10, [Free]
je zero_element
cmp r10, [Tree]
je CaseTree
cmp r10, [UnSafe]
je UnSafe_element


mov r11, [Lizard]
mov [r9], r11 ;sw 1, ($t5)
UpdateSafety:
;############################ Now we call the function that claculates index to know limits of traversing
call CompInd
call TraverseUp
;return from TraverseUp and go to TraverseDown


call CompInd

call TraverseDown
;Note that the row and column index changed
call CompInd 
call TraverseRight
call CompInd ;I need to reset the row and index of current element


call TraverseLeft
call CompInd ;This get ros in $a1 and column in $a2
call TraverseRightUp
call CompInd 
call TraverseLeftUp
call CompInd 
call TraverseRightDown 
call CompInd
call TraverseLeftDown                       
jmp NextSlot


CaseTree:           ;if its a tree we skip this element
jmp NextSlot
UnSafe_element: ;if its a unsafe element we skip this element
jmp NextSlot

NextSlot:
mov rax, 1
mov rdi,1
mov rsi, testing
mov rdx, 4
syscall

mov r11, [rown]
add r9, r11
dec r12
cmp r12, [Free]
je NextColumn
jmp catch_TraverseUp
NextColumn:
mov r12, [rows]                
add r8, 8
mov r9, r8
dec r13
cmp r13, [Free]
je printing
jmp catch_TraverseUp
; ####################### This function calculates index to know limits of traversal############
CompInd:
mov r14, Arr ;magic number in r14
mov r15, r9 ;move $t8, $t5
sub r15, r14 ;r15 = $a1
mov rax, r15
mov rbx, [rown]
div rbx
mov [row], rax

mov r15, r9
sub r15, r14

mov rax, [row]
mov rbx, [rown]
mul rbx
mov [col], rax
sub r15, [col]
mov rax, r15
mov rbx, [rows]
div rbx
ret


TraverseRight:
mov r15, r9
mov r14, [col]
inc r14
cmp r14, [rows]
jl TraverseRightValid
jmp TraverseRightFinished
TraverseRightValid:
add r15, 8
mov r11, [r15]
cmp r11, [Tree]
je TraverseRightFinished
cmp r11, [Lizard]
je TraverseRightFinished
mov r11, [UnSafe]
mov [r15], r11
jmp TraverseRight
TraverseRightFinished:
ret

                        ; this traverses left  
TraverseLeft:
mov r15, r9
mov r14, [col]
dec r14
cmp r14, 0
jge TraverseLeftValid
jmp TraverseLeftFinished
TraverseLeftValid:
sub r15, 8
mov r11, [r15]
cmp r11, [Tree]           ;it stops when it hits a tree
je TraverseLeftFinished
cmp r11, [Lizard]
je TraverseLeftFinished
mov r11, [UnSafe]
mov [r15], r11
jmp TraverseLeft
TraverseLeftFinished:
ret

; this traverses upward
TraverseUp:
mov r15, r9 ;r15 = $t8
mov r14, [row] ;a1 = r14
dec r14 ;sub a1, a1, 1
cmp r14, 0
jge TraverseUpValid
jmp TraverseUpFinished
TraverseUpValid:
sub r15, [rown] ;sub $t8, $t6
mov r11, [r15]
cmp r11, [Tree]               ;it stops when it hits a tree
je TraverseUpFinished
cmp r11, qword[Lizard]
je TraverseUpFinished
mov r11, [UnSafe]
mov [r15], r11
jmp TraverseUp
TraverseUpFinished:
ret

; this traverses downward
TraverseDown:
mov r15, r9 ;r15 = $t8
mov r14, [row] ;a1 = r14
inc r14 ;sub a1, a1, 1
cmp r14, [rows]
jl TraverseDownValid
jmp TraverseDownFinished
TraverseDownValid:
add r15, [rown] ;sub $t8, $t6
mov r11, [r15]
cmp r11, [Tree]               ;it stops when it hits a tree
je TraverseDownFinished
cmp r11, [Lizard]
je TraverseDownFinished
mov r11, [UnSafe]
mov [r15], r11
jmp TraverseDown
TraverseDownFinished:
ret


; this traverses a diagonal
TraverseRightUp:
mov r15, r9
mov rax, [row]
mov rbx, [col]
dec rax
inc rbx
cmp rax, 0
jl TraverseRightUpFinished
cmp rbx, [rows]
jge TraverseRightUpFinished
TraverseRightUpValid:
sub r15, [rown]
add r15, 8   
mov r11, [r15]
cmp r11, [Tree]          ;it stops when it hits a tree
je TraverseRightUpFinished
cmp r11, [Lizard]
je TraverseRightUpFinished
mov r11, [UnSafe]
mov [r15], r11
jmp TraverseRightUp
TraverseRightUpFinished:
ret



; this traverses a diagonal
TraverseRightDown:
mov r15, r9
mov rax, [row]
mov rbx, [col]
inc rax
inc rbx
cmp rax, [rows]
jge TraverseRightDownFinished
cmp rbx, [rows]
jge TraverseRightDownFinished
enter_borders_TraverseRightDown:
add r15, [rown]
add r15, 8
mov r11, [r15]
cmp r11, [Tree]
je TraverseRightDownFinished
cmp r11, [Lizard]
je TraverseRightDownFinished
mov r11, [UnSafe]
mov [r15], r11
jmp TraverseRightDown
TraverseRightDownFinished:
ret



; this traverses a diagonal
TraverseLeftUp:
mov r15, r9
mov rax, [row]
mov rbx, [col]
dec rax
dec rbx
cmp rax, 0
jl TraverseLeftUpFinished
cmp rbx, 0
jl TraverseLeftUpFinished
TraverseLeftUpValid:
sub r15, [rown]
sub r15, 8
mov r11, [r15]
cmp r11, [Tree]          ;it stops when it hits a tree
je TraverseLeftUpFinished
cmp r11, [Lizard]
je TraverseLeftUpFinished
mov r11, [UnSafe]
mov [r15], r11
jmp TraverseLeftUp
TraverseLeftUpFinished:
ret
; this traverses the diagonal
TraverseLeftDown:
mov r15, r9
mov rax, [row]
mov rbx, [col]
inc rax
dec rbx
cmp rax, [rows]
jge TraverseLeftDownFinished
cmp rbx, 0
jl TraverseLeftDownFinished
TraverseLeftDownValid:
sub r15, [rown]
sub r15, 8
mov r11, [r15]
cmp r11, [Tree]          ;it stops when it hits a tree
je TraverseLeftDownFinished
cmp r11, [Lizard]
je TraverseLeftDownFinished
mov r11, [UnSafe]
mov [r15], r11
jmp TraverseLeftDown
TraverseLeftDownFinished:
ret
Print:
exit:
mov rax, 1
int 0x80

