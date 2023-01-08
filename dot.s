.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 is the pointer to the start of v0
#   a1 is the pointer to the start of v1
#   a2 is the length of the vectors
# Returns:
#   a0 is the dot product of v0 and v1
# =======================================================
dot:
    # Prologue
    li t0, 0 # t1 = 0
    li s0, 0 #s0 = 0

loop_start:
    beq t0, a2, loop_end
    lw t1, 0(a0) 
    lw t2, 0(a1)
    mul t3, t1, t2 # t3 = t1 * t2
    add s0, s0, t3 
    addi a0, a0, 4
    addi a1, a1, 4
    addi t0, t0, 1
    j loop_start

loop_end:
    mv a0, s0
    # Epilogue
    ret
