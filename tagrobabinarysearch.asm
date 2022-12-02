# load $s0: base address
# load $s1: array size
# $s2: the search element
# return index at $v0

.data
myArray:   .word 1, 4, 5, 7, 9, 12, 15, 17, 13, 21, 30
arraySize: .word 11

.text

.globl main

main:
    # perform the first test
    addi $a1, $zero, 15
    jal  binarySearch
    add  $s3, $v0, $zero

exit:
    li $v0, 10
    syscall

binarySearch:
    la   $s0, myArray            # load the base address to $s0
    add  $a0, $zero, $zero       # $a0 is now the first index 0
    lw   $s1, arraySize          # load the array size to $s1
    addi $s1, $s1,  -1           # now $s1 is the last index
    add  $s2, $zero, $a1         # now store the search element into $s2

    j loop                       # do the loop

loop:
    add $t0, $s1, $a0          # have a temp reg to calculate the sum of  high and low
    sra $t1, $t0, 1            # store mid index value into $t1
    add $t1, $t1, $s0          # move to the arr[middle]
    beq $t1, $s2, return       # if the arr[mid] is equal to search value, return mid
    slt $t2, $t1, $s2          # if mid < search, $t2 = 1
    beq $t2, $zero, leftHalf   # if mid > search, go left
    j   rightHalf              # if mid < search, go right

leftHalf:
    add $s1, $t1, -1             # modify the max, max=mid-1
    j loop                    # back to the loop

rightHalf:
    addi $t1, $t1,   1
    add  $a0, $zero, $t1         # modify the min, min=mid+1
    j    loop                 # back to the loop

return:
    add $ra, $zero, $t1
    jr  $ra