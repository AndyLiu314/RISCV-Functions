.import ../read_matrix.s
.import ../utils.s

.data
file_path: .asciiz "./test_files/test_input.bin"

.text
main:
    # Read matrix into memory
    la a0, file_path
    jal read_matrix

    # Print out elements of matrix
    lw a1, 0(a1)
    lw a2, 0(a2)
    jal print_int_array

    jal free

    mv a0, a1
    jal free

    mv a0, a2
    jal free

    # Terminate the program
    addi a0, x0, 10
    ecall