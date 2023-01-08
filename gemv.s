.globl gemv

.text
# =======================================================
# FUNCTION: Matrix Vector Multiplication
# 	d = gemv(m0, m1)
#   If the dimensions don't match, exit with exit code 2
# Arguments:
# 	a0 is the pointer to the start of m0
#	a1 is the # of rows (height) of m0
#	a2 is the # of columns (width) of m0
#	a3 is the pointer to the start of v
# 	a4 is the # of rows (height) of v
#	a5 is the pointer to the the start of d
# Returns:
#	None, sets d = gemv(m0, m1)
# =======================================================
gemv:

    # Error if mismatched dimensions
    bne a2, a4, mismatched_dimensions

    # Prologue
    li t0, 0
    li s0, 0
    li t1, 0

    # Dot Loop for Finding Dot Product
dot_loop_start:
    beq t1, a4, dot_loop_end
    lw t2, 0(a0)
    lw t3, 0(a3)
    mul t4, t2, t3
    add s0, s0, t4 
    addi a0, a0, 4
    addi a3, a3, 4
    addi t1, t1, 1
    j dot_loop_start

dot_loop_end:
    beq t1, zero, outer_loop_start_gemv
    addi a3, a3, -4
    addi t1, t1, -1
    j dot_loop_end

outer_loop_start_gemv:
    beq t0, a1, outer_loop_end_gemv
    sw s0, 0(a5)
    addi a5, a5, 4
    addi t0, t0, 1
    li s0, 0

    j dot_loop_start

#Epilogue
outer_loop_end_gemv:
    ret

mismatched_dimensions:
    li a1 2
    jal exit2