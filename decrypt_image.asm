# ID1: 201526390
# ID2: 201635180
# Authors: Yusef Alamri, Mohammed Al-Oraifi
# Section: 52
# Side project: PGM Read and Write

.data
#"This program will read an image of type .pgm and output the image after processing."
msg0: 	  .asciiz "\nDone!"
filename:   .asciiz "nature_small_encrypted.pgm"	# filename for input
out_name:   .asciiz "nature_small_decrypted.pgm"  			# filename for output
header: 	  .space  512				# 512 bytes or characters, the header itself
header_size:.word 	1				# Number of bits in header
image_size: .word 	1				# Number of bits in image (sans header)
file_size: .word 	1				# Number of bits in file (image + header)
image_pixels:.space 26000			# 26000 bytes or characters, the pixels only (after finishing the call)
out_image:  .space  26000			# 26000 bytes or characters
cipher_key: .byte 0xcc, 0xdd, 0xee, 0xff, 0x88, 0x99, 0xaa, 0xbb, 0x44, 0x55, 0x66, 0x77, 0x00, 0x11, 0x22, 0x33
all_keys: .space 176  # 176 bytes for all of the round keys
inv_s_box: .byte 0x52, 0x09, 0x6A, 0xD5, 0x30, 0x36, 0xA5, 0x38, 0xBF, 0x40, 0xA3, 0x9E, 0x81, 0xF3, 0xD7, 0xFB,
   		 0x7C, 0xE3, 0x39, 0x82, 0x9B, 0x2F, 0xFF, 0x87, 0x34, 0x8E, 0x43, 0x44, 0xC4, 0xDE, 0xE9, 0xCB,
   		 0x54, 0x7B, 0x94, 0x32, 0xA6, 0xC2, 0x23, 0x3D, 0xEE, 0x4C, 0x95, 0x0B, 0x42, 0xFA, 0xC3, 0x4E,
  		 0x08, 0x2E, 0xA1, 0x66, 0x28, 0xD9, 0x24, 0xB2, 0x76, 0x5B, 0xA2, 0x49, 0x6D, 0x8B, 0xD1, 0x25,
		 0x72, 0xF8, 0xF6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xD4, 0xA4, 0x5C, 0xCC, 0x5D, 0x65, 0xB6, 0x92,
		 0x6C, 0x70, 0x48, 0x50, 0xFD, 0xED, 0xB9, 0xDA, 0x5E, 0x15, 0x46, 0x57, 0xA7, 0x8D, 0x9D, 0x84,
    		 0x90, 0xD8, 0xAB, 0x00, 0x8C, 0xBC, 0xD3, 0x0A, 0xF7, 0xE4, 0x58, 0x05, 0xB8, 0xB3, 0x45, 0x06,
    		 0xD0, 0x2C, 0x1E, 0x8F, 0xCA, 0x3F, 0x0F, 0x02, 0xC1, 0xAF, 0xBD, 0x03, 0x01, 0x13, 0x8A, 0x6B,
    		 0x3A, 0x91, 0x11, 0x41, 0x4F, 0x67, 0xDC, 0xEA, 0x97, 0xF2, 0xCF, 0xCE, 0xF0, 0xB4, 0xE6, 0x73,
    		 0x96, 0xAC, 0x74, 0x22, 0xE7, 0xAD, 0x35, 0x85, 0xE2, 0xF9, 0x37, 0xE8, 0x1C, 0x75, 0xDF, 0x6E,
    		 0x47, 0xF1, 0x1A, 0x71, 0x1D, 0x29, 0xC5, 0x89, 0x6F, 0xB7, 0x62, 0x0E, 0xAA, 0x18, 0xBE, 0x1B,
    		 0xFC, 0x56, 0x3E, 0x4B, 0xC6, 0xD2, 0x79, 0x20, 0x9A, 0xDB, 0xC0, 0xFE, 0x78, 0xCD, 0x5A, 0xF4,
    		 0x1F, 0xDD, 0xA8, 0x33, 0x88, 0x07, 0xC7, 0x31, 0xB1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xEC, 0x5F,
    		 0x60, 0x51, 0x7F, 0xA9, 0x19, 0xB5, 0x4A, 0x0D, 0x2D, 0xE5, 0x7A, 0x9F, 0x93, 0xC9, 0x9C, 0xEF,
    		 0xA0, 0xE0, 0x3B, 0x4D, 0xAE, 0x2A, 0xF5, 0xB0, 0xC8, 0xEB, 0xBB, 0x3C, 0x83, 0x53, 0x99, 0x61,
    		 0x17, 0x2B, 0x04, 0x7E, 0xBA, 0x77, 0xD6, 0x26, 0xE1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0C, 0x7D

SBox:.byte	 0x63,0x7c,0x77,0x7b,0xf2,0x6b,0x6f,0xc5,0x30,0x01,0x67,0x2b,0xfe,0xd7,0xab,0x76
		,0xca,0x82,0xc9,0x7d,0xfa,0x59,0x47,0xf0,0xad,0xd4,0xa2,0xaf,0x9c,0xa4,0x72,0xc0
		,0xb7,0xfd,0x93,0x26,0x36,0x3f,0xf7,0xcc,0x34,0xa5,0xe5,0xf1,0x71,0xd8,0x31,0x15
		,0x04,0xc7,0x23,0xc3,0x18,0x96,0x05,0x9a,0x07,0x12,0x80,0xe2,0xeb,0x27,0xb2,0x75
		,0x09,0x83,0x2c,0x1a,0x1b,0x6e,0x5a,0xa0,0x52,0x3b,0xd6,0xb3,0x29,0xe3,0x2f,0x84
		,0x53,0xd1,0x00,0xed,0x20,0xfc,0xb1,0x5b,0x6a,0xcb,0xbe,0x39,0x4a,0x4c,0x58,0xcf
		,0xd0,0xef,0xaa,0xfb,0x43,0x4d,0x33,0x85,0x45,0xf9,0x02,0x7f,0x50,0x3c,0x9f,0xa8
		,0x51,0xa3,0x40,0x8f,0x92,0x9d,0x38,0xf5,0xbc,0xb6,0xda,0x21,0x10,0xff,0xf3,0xd2
		,0xcd,0x0c,0x13,0xec,0x5f,0x97,0x44,0x17,0xc4,0xa7,0x7e,0x3d,0x64,0x5d,0x19,0x73
		,0x60,0x81,0x4f,0xdc,0x22,0x2a,0x90,0x88,0x46,0xee,0xb8,0x14,0xde,0x5e,0x0b,0xdb
		,0xe0,0x32,0x3a,0x0a,0x49,0x06,0x24,0x5c,0xc2,0xd3,0xac,0x62,0x91,0x95,0xe4,0x79
		,0xe7,0xc8,0x37,0x6d,0x8d,0xd5,0x4e,0xa9,0x6c,0x56,0xf4,0xea,0x65,0x7a,0xae,0x08
		,0xba,0x78,0x25,0x2e,0x1c,0xa6,0xb4,0xc6,0xe8,0xdd,0x74,0x1f,0x4b,0xbd,0x8b,0x8a
		,0x70,0x3e,0xb5,0x66,0x48,0x03,0xf6,0x0e,0x61,0x35,0x57,0xb9,0x86,0xc1,0x1d,0x9e
		,0xe1,0xf8,0x98,0x11,0x69,0xd9,0x8e,0x94,0x9b,0x1e,0x87,0xe9,0xce,0x55,0x28,0xdf
		,0x8c,0xa1,0x89,0x0d,0xbf,0xe6,0x42,0x68,0x41,0x99,0x2d,0x0f,0xb0,0x54,0xbb,0x16
placeholder: .word 0  # for storing g(w[3])
RCon: .byte 0x01 , 0x02 , 0x04 , 0x08, 0x10 , 0x20 , 0x40 , 0x80 , 0x1B , 0x36		
################### Code segment #####################
.text
main:

# Arguments are in .data already
jal readPGM

la $a0, image_pixels
la $a1, cipher_key
move $a2, $a0		#started from $s2 because $s0 and $s1 are used inside the read and write functions
li $s2, 0
move $s4, $a0
move $s5, $a1
main_loop:
li $s3, 1625
bge $s2, $s3, end_main_loop
jal print_state ## printing the input cipher_text
move $a0, $a1
jal print_state ## printing the input cipher_key
move $a0, $s4
move $a1, $s5
jal AES_decrypt
move $a0, $s4
jal print_state ## printing the output plain_text
addi $s2, $s2, 1
addi $s4, $s4, 16
move $a0, $s4
move $a1, $s5
move $a2, $s4
j main_loop
end_main_loop:
# HOW TO USE ME:
################################################
# <Encryotion code goes here>
# You should encrypt the content of image_pixels
# after calling the readPGM function.
# 
# When you finish encrypting the image_pixels,
# just call the writePGM function below.
################################################
# Note: The read and write function aren't calling auxiliary functions inside of them.


# HOW THIS CODE WORKS:
################################################
# The readPGM takes a .pgm file and slices the
# header and image_pixels and stores them in
# the corrosponding labels.
# 
# The writePGM combines the sliced header and
# image_pixels back and writes them to "y.pgm".
################################################

# Arguments are in .data already
jal writePGM

la $a0, msg0
li $v0, 4
syscall

########## Terminating code
li, $v0, 10
syscall


print_state:
move $t0, $a0
li $t1, 16
print_state_loop:
lw $a0, 0($t0)
li $v0, 34
syscall 
li $v0, 11
li $a0, ' '
syscall 
addi $t1, $t1, -4
addi $t0, $t0, 4
bnez $t1, print_state_loop
li $v0, 11
li $a0, '\n'
syscall 
jr $ra


readPGM:
#	Registers usage:
# 	$t0, file descriptor
# 	$t1, $t2, $s0, and $s1 may be used inside loops
#	$t3, counters and sometimes $t4 & $t5

# open a file for reading
li   $v0, 13       # system call for open file
la   $a0, filename 
li   $a1, 0        # Open for reading
li   $a2, 0
syscall
# file descriptor in $v0
move $t0, $v0		# file descriptor

# read from file
li   $v0, 14       # system call for read from file
move $a0, $t0      # file descriptor
la   $a1, image_pixels   # address of buffer to which to read
li   $a2, 26000      # hardcoded buffer length
syscall
# number of read characters in $v0
sw $v0, file_size

# save header
la $t1, image_pixels
la $t2, header
li $t3, 0

loop:
lb $s0, 0($t1)
sb $s0, 0($t2)

addi $t3, $t3, 1 # header bits number

bne $s0, 0x0A, skip_count # skips counting line feeds
addi $s1, $s1, 1 # line feed counter

bne $s1, 1, skip_count # Enter here after the first line feed
lb $s0, 1($t1) # Load forthcoming byte for checking
bne $s0, 0x23, no_comment # If that byte is (#), decrease current counter by 1

addi $s1, $s1, -1 # a convoluted way of dealing with comments
no_comment:

skip_count:
add $t1, $t1, 1 #move to next char
add $t2, $t2, 1 #move reading pointer

bne $s1, 3, loop ###number of line feeds before exiting

sw $t3, header_size

### Calculate image pixels size:
lw $s0, file_size
sub $s0, $s0, $t3
sw $s0, image_size

# delete header
la $t1, image_pixels
la $t2, image_pixels
lw $t3, header_size # number of bits in header

add $t1, $t1, $t3 # skip header bits

lw $t3, image_size # overwrite header_size

pixels_loop:
lb $s0, 0($t1)
sb $s0, 0($t2)

addi $t1, $t1, 1
addi $t2, $t2, 1
addi $t3, $t3, -1 # Pixel counter

bne $t3, $0, pixels_loop

# close the file 
li   $v0, 16       # system call for close file
move $a0, $t0      # file descriptor to close
syscall            # close file

jr $ra

writePGM:
#	Registers usage:
# 	$a0, filename (address of filename string)
# 	$t0, file descriptor
# 	$t1, $t2, $s0, and $s1 may be used inside loops
#	$t3, counters and sometimes $t4 & $t5

# write header
la $t1, header
la $t2, out_image
lw $t3, header_size

loop2:
lb $s0, 0($t1)
sb $s0, 0($t2)

add $t1, $t1, 1 # move to next char
add $t2, $t2, 1 # move writing pointer
add $t3, $t3, -1 # header counter

bne $t3, $0, loop2

## Write the rest (the encrypted part)
la $t1, image_pixels
la $t2, out_image
lw $t3, header_size
lw $t4, image_size

add $t2, $t2, $t3 # avoid overwriting header

loop3:
lb $s0, 0($t1)
sb $s0, 0($t2)

add $t1, $t1, 1 # move to next char
add $t2, $t2, 1 # move writing pointer
addi $t4, $t4, -1 # Pixel counter

bne $t4, $0, loop3

# open a file for writing
li   $v0, 13       # system call for open file
la 	$a0, out_name
li   $a1, 1        # Open for writing
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)

# write the file
move $a0, $v0      # save the file descriptor
li   $v0, 15       # system call for close file
la	$a1, out_image
lw   $a2, file_size # number of bits to write argument
syscall            # close file

# close the file 
li   $v0, 16       # system call for close file
move $a0, $t0      # file descriptor to close
syscall            # close file

jr $ra

AES_decrypt:
li $t0, 0
li $t1, 4
move $t2, $a0
move $t3, $a2
aes_decrypt_loop1: ## copy the cipher text to the plain text
beq $t0, $t1, end_aes_decrypt_loop1
lw $t4, 0($t2)
sw $t4, 0($t3)
addi $t2, $t2, 4
addi $t3, $t3, 4
addi $t0, $t0, 1
j aes_decrypt_loop1
end_aes_decrypt_loop1:

addi $sp, $sp, -16
sw $a2, 4($sp)			#storing the address of the plain text in the stack
sw $ra, 12($sp)			#storing the return address in the stack
move $a0, $a1			#move the address of the cipher key to $a0
la $a1, all_keys		#move the address of all keys 
#move $t0, $a1
#addi $t0, $t0, 160
#sw $t0, 0($sp)			#store the address of all keys in the stack
jal key_expansion		#key_expansion(&cipher_key, &all_keys)
addi $v0, $v0, 160		#adding 160 to point at the last round key for the decryption
sw $v0, 0($sp)			#store the address of all keys in the stack
#la $a1, all_keys
#sw $a1, 0($sp)
#lw $a1, ($sp) 
move $a1, $v0			#$a1 = &all_keys
lw $a0, 4($sp)			#$a0 = &plain_text
move $a2, $a0			#$a2 = &plain_text
jal addRoundKey
lw $t0, 0($sp)			#$a1 = this round key
addi $t0, $t0, -16
sw $t0, 0($sp)
#####################################
li $t0, 0
sw $t0, 8($sp)			#storing the index i for the loop
aes_decrypt_main_loop:
#lw $t0, 8($sp)
li $t1, 8			#$t1 = 9 to use it for the loop
bgt $t0, $t1, end_aes_decrypt_main_loop
lw $a0, 4($sp)
jal InvShiftRow
lw $a0, 4($sp)
jal InvSubBytesMatrix
lw $a1, 0($sp)			#$a1 = this round key
lw $a0, 4($sp)			#$a0 = $cipher_text
move $a2, $a0			#$a2 = $cipher_text
jal addRoundKey
lw $a0, 4($sp)
jal InvMix_columns
lw $t0, 8($sp)
addi $t0 ,$t0, 1
sw $t0, 8($sp)			#increment the index for the loop
lw $a1, 0($sp)			#$a1 = this round key
addi $a1, $a1, -16
sw $a1, 0($sp)
j aes_decrypt_main_loop
end_aes_decrypt_main_loop:		#end of the 9 rounds

lw $a0, 4($sp)
jal InvShiftRow
lw $a0, 4($sp)
jal InvSubBytesMatrix
lw $a1, ($sp)			#$a1 = this round key
lw $a0, 4($sp)			#$a0 = $cipher_text
move $a2, $a0			#$a2 = $cipher_text
jal addRoundKey
lw $ra, 12($sp)			#loading the return address
addi $sp, $sp, 16
jr $ra				#now the cipher text address should have the encrypted text


InvShiftRow:
addi $t0, $a0, 2
lb $t1, 0($t0)
lb $t2, 4($t0)
lb $t3, 8($t0)
lb $t4, 12($t0)

sb $t4, 0($t0)
sb $t1, 4($t0)
sb $t2, 8($t0)
sb $t3, 12($t0)

addi $t0, $t0, -1
lb $t1, 0($t0)
lb $t2, 4($t0)
lb $t3, 8($t0)
lb $t4, 12($t0)

sb $t3, 0($t0)
sb $t4, 4($t0)
sb $t1, 8($t0)
sb $t2, 12($t0)

addi $t0, $t0, -1
lb $t1, 0($t0)
lb $t2, 4($t0)
lb $t3, 8($t0)
lb $t4, 12($t0)

sb $t2, 0($t0)
sb $t3, 4($t0)
sb $t4, 8($t0)
sb $t1, 12($t0)
jr $ra


InvSubBytes:
la $a1 , inv_s_box # load Inverse SBox
add $a0 , $a1 , $a0 # add argument byte
lb $v0 , ($a0) # substituted byte in $v0
jr $ra 

GFMul4B:
# $a0 contains the first operand (word = 4bytes)
# $a1 contains the second operand (word = 4bytes)
addi $sp, $sp, -16
sw $ra, 0($sp)
sw $a0, 4($sp)
sw $a1, 8($sp)

lw $a0, 4($sp)
lw $a1, 8($sp)
srl $a0, $a0, 24
srl $a1, $a1, 24
andi $a0, $a0, 0xFF
andi $a1, $a1, 0xFF
jal GMul
sll $v0, $v0, 24
sw $v0, 12($sp)

lw $a0, 4($sp)
lw $a1, 8($sp)
srl $a0, $a0, 16
srl $a1, $a1, 16
andi $a0, $a0, 0xFF
andi $a1, $a1, 0xFF
jal GMul
lw $t0, 12($sp)
sll $v0, $v0, 16
or $v0, $v0, $t0
sw $v0, 12($sp)

lw $a0, 4($sp)
lw $a1, 8($sp)
srl $a0, $a0, 8
srl $a1, $a1, 8
andi $a0, $a0, 0xFF
andi $a1, $a1, 0xFF
jal GMul
lw $t0, 12($sp)
sll $v0, $v0, 8
or $v0, $v0, $t0
sw $v0, 12($sp)

lw $a0, 4($sp)
lw $a1, 8($sp)
andi $a0, $a0, 0xFF
andi $a1, $a1, 0xFF
jal GMul
lw $t0, 12($sp)
or $v0, $v0, $t0

endGFMul4B:
lw $ra, 0($sp)
addi $sp, $sp, 16
jr $ra


# $a0 contaons the first operand (byte) a
# $a1 contaons the second operand (byte) b

GMul:
li $t0, 0 # counter
and $v0, $v0, $zero # clearing result register
GMul_Loop:
beq $t0, 8, endGMul_Loop
andi $t1, $a1, 1
beqz $t1, GMul_else1
xor $v0, $v0, $a0
GMul_else1:
andi $t1, $a0, 0x80
sll $a0, $a0, 1
beqz $t1, GMul_else2
xori $a0, $a0, 0x1B
GMul_else2:
srl $a1, $a1, 1
addi $t0, $t0, 1
j GMul_Loop
endGMul_Loop:
andi $v0, $v0, 0xFF
jr $ra


InvMix_columns:
li $t0, 4
addi $sp, $sp, -12
sw $ra, 0($sp)
InvMix_loop:beqz $t0, end_InvMix
sw $a0, 4($sp)
sw $t0, 8($sp)

lw $a0, ($a0)
li $a1, 0x0e0b0d09
jal GFMul4B
# and $t1, $t0, $t1
srl $t2, $v0, 8
srl $t3, $v0, 16
srl $t4, $v0, 24
xor $t1, $v0, $t2
xor $t3, $t3, $t4
xor $t1, $t1, $t3
andi $t5, $t1, 0xff ## should be stored in the stack

lw $a0, 4($sp)
lw $a0, 0($a0)
li $a1, 0x090e0b0d
jal GFMul4B
srl $t2, $v0, 8
srl $t3, $v0, 16
srl $t4, $v0, 24
xor $t1, $v0, $t2
xor $t3, $t3, $t4
xor $t1, $t1, $t3
andi $t1, $t1, 0xff
sll $t5, $t5, 8
or $t5, $t5, $t1

lw $a0, 4($sp)
lw $a0, 0($a0)
li $a1, 0x0d090e0b
jal GFMul4B
srl $t2, $v0, 8
srl $t3, $v0, 16
srl $t4, $v0, 24
xor $t1, $v0, $t2
xor $t3, $t3, $t4
xor $t1, $t1, $t3
andi $t1, $t1, 0xff
sll $t5, $t5, 8
or $t5, $t5, $t1

lw $a0, 4($sp)
lw $a0, 0($a0)
li $a1, 0x0b0d090e
jal GFMul4B
srl $t2, $v0, 8
srl $t3, $v0, 16
srl $t4, $v0, 24
xor $t1, $v0, $t2
xor $t3, $t3, $t4
xor $t1, $t1, $t3
andi $t1, $t1, 0xff
sll $t5, $t5, 8
or $t5, $t5, $t1

lw $a0, 4($sp)
sw $t5, 0($a0)
addi $a0, $a0, 4
lw $t0, 8($sp)
addi $t0, $t0, -1
j InvMix_loop
end_InvMix:
lw $ra, 0($sp)
addi $sp, $sp, 12
jr $ra

addRoundKey:
li $t0,0
addRoundKeyLoop:
lw $t1,($a0)
lw $t2,($a1)
xor $t1,$t1,$t2
sw $t1,($a2)
addiu $t0,$t0,1
addiu $a0,$a0,4
addiu $a1,$a1,4
addiu $a2,$a2,4
blt $t0,4,addRoundKeyLoop
jr $ra

key_expansion:
	move $t0 , $a0 # moving the base address to $t0
	move $t1 , $a1 # moving output address to $t1
	# we assume out_array is in $a1
	move $v0,$a1	# contains the base address out output
		# note that $v0, does not change during the execution
		
	li $t2 , 0
	copy_base: # preparing round key 0
		lb $t3,0($t0) 
		sb $t3,0($a1)
		addi $t0,$t0,1
		addi $a1,$a1,1
		addi $t2,$t2,1
		bne $t2,16,copy_base # end of copying loop
# $t1 now contains address of output roundkey
	addi $t2 , $a1 , -4 # to access w[3]
	move $t3 , $v0 # to access w[0]
	li $t6 , 0	# i
	li $t8 , 0	# counter is reset every 4 loop iterations
	li $t1,0 # $t1
	addi $sp , $sp , -4
	sw $s0 , ($sp) # so that the original value of $s0 is not lost
	la $s0 , placeholder
	exp_procedure:
		lw $t4 , ($t2) # starts at w[3]
		lw $t5 , ($t3) # starts at w[0]
		bnez $t8,skip_rot_sub_add #so if the remainder !=0 dont rotate, else, do the rotation and proced to the xoring part
		rol $t4,$t4,8 # rotating w[3]
		sw $t4 , ($s0)
		li $t0 , 0 # used for subbing
		subbing:
			lbu $t7 , ($s0) # loading from placeholder
			addi $sp , $sp , -16
			sw $ra , ($sp)
			sw $a0 , 4($sp)
			sw $a1 , 8($sp)
			sw $v0 , 12($sp)
			move $a0 , $t7
			jal SubBytes # subbing the byte
			move $t7,$v0 # store it back into memory after moving
			lw $ra,($sp)
			lw $a0,4($sp)
			lw $a1 , 8($sp)
			lw $v0 , 12($sp)
			addi $sp , $sp , 16
			sb $t7 , ($s0)
			addi $t0 , $t0 , 1
			addi $s0 , $s0 , 1
			bne $t0 , 4 , subbing
		addi $s0 , $s0 , -4 # reset placeholder counter to start
		lw $t4 , ($s0) #loading the word after completing the subbing
		la $t9, RCon
		add $t9, $t9, $t1
		addi $t1, $t1, 1
		lb $t9, ($t9)
		sll $t9, $t9, 24
		xor $t4, $t4, $t9
		skip_rot_sub_add:
			addi $t8,$t8,1
			xor $t4,$t5,$t4 # xoring g(w[3]) with w[0]
			sw $t4 , ($a1) # storing the value
			addiu $a1,$a1,4
			addiu $t2,$t2,4
			addiu $t3,$t3,4 # incrementing all pointers
			addiu $t6,$t6, 4 # word++
			bne $t8, 4, skip_reseting
		li $t8, 0
		skip_reseting:
			bne $t6,160,exp_procedure # looping for 160 words
	lw $s0 , ($sp) # so that the original value of $s0 is not lost
	addi $sp , $sp , 4
	jr $ra

SubBytes:
la $a1,SBox		#load the address into $a1

addu $a1,$a1,$a0	#go to SBox[$a0]

lb $v0,0($a1)		#load the byte into $v0
andi $v0, $v0, 0xFF
jr $ra			#return

InvSubBytesMatrix:			#A helper function to do the subbytes
addi $sp, $sp, -12
li $t0, 0
sw $a0, 0($sp)
sw $t0, 4($sp)
sw $ra, 8($sp)
InvSubBytesMatrix_loop:
li $t1, 16
bge $t0, $t1, end_InvSubBytesMatrix_loop
lb $a0, ($a0)
andi $a0, $a0, 0xFF
jal InvSubBytes
lw $a0, 0($sp)
lw $t0, 4($sp)
sb $v0, 0($a0)
addi $a0, $a0, 1
addi $t0, $t0, 1
sw $a0, 0($sp)
sw $t0, 4($sp)
j InvSubBytesMatrix_loop
end_InvSubBytesMatrix_loop:
lw $ra, 8($sp)
addi $sp, $sp, 12
jr $ra
