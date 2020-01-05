	mv      a5, a0
	beqz	a0, .L7
	li      a0, 0
.L4:
	add     a0, a0, a5
	addi	a5, a5, -1
	bnez	a5, .L4
.L7:
