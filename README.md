# RISC_MIPS_CPU
This project is to verify the architecture of RISC MIPS CPU.
Only input of this MIPS module is clock and reset as it can be seen from testbench code(tb_MIPS_final.v)
Rather than reducing clk frequency, I found it more effective to divide the sequence of CPU activation using FSM.


Architecture consist of program counter, instruction memory, data register, data memory, bit extension, byte address adder, left shifter, accumulator and several Muxs'
Controller which is basically FSM format for the activation of this code, it gives signals to DR_select, RegW, Reg_or_Imm, OP and ALU_or_Mem thereby controling the timing of
the architecture activation.
![image](https://github.com/dylee0907/RISC_MIPS_CPU/assets/79738681/c6bc25b9-5c5f-4d29-825e-4e8a02e55de7)



Format of instructions are divided to three types(R, I, J) and depending on each format.
Format R takes maximum of 4 clock cycles and minimum of 3 clock cycles(JR) until the output comes out. 
Format I takes maximum of 5 clock cycles(lw) and minimum of 4 clock cycles.
Format J takes only 2 clock cycles(Jump) for calculation of next PC input.
![image](https://github.com/dylee0907/RISC_MIPS_CPU/assets/79738681/2157a23b-e2bd-479b-983f-2e22ccdf6e40)


Combination of 32 instructions are verifiable on this CPU verilog code.
31 bits are consisted of 6bit opcode, 5bit rs code, 5bit rt code, 5bit rd code, 5bit shamt code and 6bit for f_code for R types.
For I types, 6bit opcode, 5bit rs code, 5bit rt code and 16bits are used as address bits for address data in ALU or used for bit extension to 32 bits.
For J types, first 6bits are used for opcode and rest are used for branch destination.
이름	형식	필드	명령어
(Operation destination, src1, src2)
Add	R	0	2	3	1	0	32	Add $1, $2, $s3
Sub	R	0	2	3	1	0	34	Sub $1, $2, $3
Addi	I	8	2	1	100	Addi $1, $2, 100
Addu	R	0	2	3	1	0	33	Addu $1, $2, $3
Subu	R	0	2	3	1	0	35	Subu $1, $2, $3
Addiu	I	9	2	1	100	Addiu $1, $2, 100
Mfc0	R	16	0	1	14	0	0	Mfc0 $1, $epc
Mult	R	0	2	3	0	0	24	Mult $2, $3
Multu	R	0	2	3	0	0	25	Multu $2, $3
Div	R	0	2	3	0	0	26	Div $2, $3
Divu	R	0	2	3	0	0	27	Divu $2, $3
Mfhi	R	0	0	0	1	0	16	Mfhi $1
Mflo	R	0	0	0	1	0	18	Mflo $1
And	R	0	2	3	1	0	36	And $1, $2, $3
Or	R	0	22	3	1	0	37	Or $1, $2, $3
Andi	I	12	2	1	100	Andi $1, $2, 100
Ori	I	13	2	1	100	Ori $1, $2, 100
Sll	R	0	0	2	1	10	0	Sll $1, $2, 10
Srl	R	0	0	2	1	10	2	Srl $1, $2, 10
Lw	I	35	2	1	100	Lw $1, 100($12)
Sw	I	43	2	1	100	Sw $1, 100($2)
Lui	I	15	0	1	100	Lui $1, 100
BeIq	I	4	1	2	25	Beq $1, $2, 100
BnIIe	I	5	1	2	25	Bne $1, $2, 100
SIltI	R	0	2	3	1	0	42	Slt $1, $2, $3
SIltIi	I	10	2	1	100	Slti $1, $2, 100
Sltu	R	0	22	3	1	0	43	Sltu $1, $2, $3
Sltiu	I	11	2	1	100	Sltiu $1, $2, 100
J	J	2	2500	J 10000
Jr	R	0	31	0	0	0	8	Jr #31
Jal	J	3	2500	Jal 10000
