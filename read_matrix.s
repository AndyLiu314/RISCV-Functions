.globl read_matrix


.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
# Returns:
#   a0 is the pointer to the matrix in memory
#   a1 is a pointer to an integer, we will set it to the number of rows
#   a2 is a pointer to an integer, we will set it to the number of columns
# ==============================================================================
read_matrix:
# prologue
    addi sp, sp, -36
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)

    mv a1, a0
    li a2, 0

# check file path
    jal fopen
    mv s3, a0 # s3 is file descriptor 

    mv a1, s3
    jal ferror
    li t0, 0
    bne a0, t0, eof_or_error

# malloc row pointer
    li a0, 4 
    jal malloc 
    mv s0, a0 # s0 row ptr 

# Malloc col pointer
    li a0, 4
    jal malloc 
    mv s1, a0 # s1 col ptr

# Read number of rows
    mv a1, s3
    mv a2, s0 
    li a3, 4
    jal fread

    li t1, 4
    bne a0, t1, eof_or_error

# Read number of cols
    mv a1, s3
    mv a2, s1
    li a3, 4
    jal fread

    li t1, 4
    bne a0, t1, eof_or_error

# Calculate bytes
    lw s4, 0(s0)
    lw s5, 0(s1) # multiplies dimensions to find how many elements there are
    mul s6, s4, s5

    li t2, 4
    mul s6, s6, t2 

# Allocate space for matrix and read it.
    mv a0, s6
    jal malloc 
    mv s2, a0 # s2 has matrix ptr

    mv a1, s3
    mv a2, s2
    mv a3, s6
    jal fread

    bne a0, s6, eof_or_error

# Return value
    mv a0, s2
    mv a1, s0
    mv a2, s1

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    addi sp, sp, 36

    ret

eof_or_error:
    li a1 1
    jal exit2