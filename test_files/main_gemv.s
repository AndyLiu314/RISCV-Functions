.import ../read_matrix.s
.import ../gemv.s
.import ../dot.s
.import ../utils.s

.data
output_step1: .asciiz "\n**Step result = gemv(matrix, vector)**\n"

.globl main

.text
main:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0: int argc
    #   a1: char** argv
    #
    # Usage:
    #   main.s <VECTOR_PATH> <MATRIX_PATH> 

    # Exit if incorrect number of command line args
    
# =====================================
# LOAD MATRIX and VECTOR. Iterate over argv.
# =====================================
# Load Matrix  
    mv s0, a0 # keep the argc (maybe not)
    lw t0, 8(a1) # matrix path

# Load Vector
    lw s1, 4(a1) # vector path

# Read Matrix
    mv a0, t0
    jal read_matrix

    #lw a1, 0(s3)
    #lw a2, 0(s4)
    #jal print_int_array

    mv s2, a0 
    lw s3, 0(a1)
    lw s4, 0(a2)
    
# Read Vector
    mv a0, s1 
    jal read_matrix

    #lw a1, 0(a1)
    #lw a2, 0(a2)
    #jal print_int_array

    mv s5, a0 # vector ptr
    lw s6, 0(a1) # vector rows (vector cols always 1)

# =====================================
# RUN GEMV
# =====================================
    
    li t1, 4
    lw t0, 0(s3)
    mul t0, t0, t1 # result matrix size (bytes)

    mv a0, t0 
    jal malloc 
    mv s7, a0 # result matrix ptr
    
    mv a0, s2
    mv a1, s3
    mv a2, s4
    mv a3, s5
    mv a4, s6
    mv a5, s7
    jal gemv


# SPMV :    m * v

    la a1, output_step1
    jal print_str

    ## FILL OUT. Output is a dense vector.
#    mv a0,# Base ptr
#    mv a1,#rows
#    mv a2,#cols
#    jal print_int_array

    mv a0, s7 
    mv a1, s3
    li a2, 1
    jal print_int_array

    mv a0, s7 
    jal free 

    # Print newline afterwards for clarity
    li a1 '\n'
    #jal print_char

    jal exit
