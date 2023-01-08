.globl sdot

.text
# =======================================================
# FUNCTION: Dot product of 1 sparse vectors and 1 dense vector
# Arguments:
#   a0 is the pointer to the start of v0 (sparse, coo format)
#   a1 is the pointer to the start of v1 (dense)
#   a2 is the number of non-zeros in vector v0
# Returns:
#   a0 is the sparse dot product of v0 and v1
# =======================================================
#
# struct coo {
#   int row;
#   int index;
#   int val;
# };   
# Since these are vectors row = 0 always for v0.
#for (int i = 0 i < nnz; i++) {
#    sum = sum + v0[i].value * v1[coo[i].index];
# }
sdot:
    # Prologue    
    # Save arguments
    # Set strides. Note that v0 is struct. v1 is array.
    # Set loop index
    # Set accumulation to 0

    li t0, 0
    li s3, 0

loop_start:
    beq t0, a2, loop_end
    lw s0, 8(a0) # coo value
    lw s1, 4(a0) # coo index

    slli s1, s1, 2
    add a1, a1, s1
    lw s2, 0(a1) # dense value 

    mul t1, s0, s2
    add s3, s3, t1 # accumulator

    addi a0, a0, 12
    sub a1, a1, s1
    addi t0, t0, 1
    j loop_start

    # Check outer loop condition
    # load v0[i].value. The actual value is located at offset  from start of coo entry
    # What is the index of the coo element?
    # Lookup corresponding index in dense vector
    # Load v1[coo[i].index]
    # Multiply and accumulate
    # Bump ptr to coo entry
    # Increment loop index

loop_end:
    # Epilogue
    mv a0, s3

    ret
