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
![image](https://github.com/dylee0907/RISC_MIPS_CPU/assets/79738681/66d52631-37b4-41a4-ae17-830a4b23c92c)
