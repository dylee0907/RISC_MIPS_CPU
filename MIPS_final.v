module MIPS(
    input clk,
    input rst,
    output [31:0] mux3_out
);
    reg [31:0] pc_in;
    reg [31:0] pc_out;
    reg [2:0] state;
    reg [2:0] next_state;
    wire [31:0] from_add4;
    wire [31:0] from_accum;
    reg RE_mem1;
    reg RegW;
    reg DR_select;
    reg Reg_or_Imm;
    wire [31:0] instruction;
    wire [31:0] instruction_out;
    wire [4:0] mux1_out;
    wire [31:0] mux2_out;
    wire [31:0] mux3_out;
    wire [31:0] mux4_out;
    wire [31:0] SR1_out;
    wire [31:0] SR2_out;
    wire [5:0] format;
    wire [31:0] instruction_shifted;
    reg ALU_or_Mem;
    wire [27:0] shift_instruction;
    wire [31:0] PC_Jump_in;
    reg [5:0] OP;
    reg WE_mem2;
    reg RE_mem2;
    wire [31:0] alu_out;
    wire [31:0] data_mem_out;
    reg [1:0] PC_select;

    parameter pc_start = 3'd0, Instruction_Mem = 3'd1, ALU = 3'd2, data_memory_write = 3'd3, Register_write = 3'd4;
    parameter R = 2'd0, I = 2'd1, J= 2'd2;
    Add_4 add_address(
        .from_pc(pc_out),
        .to_accum(from_add4)
    );

    accumulate accum(
        .accum1(from_add4),
        .accum2(instruction_shifted),
        .accum_out(from_accum)
    );

    shift_left2_accum shift_accum(
        .bit_extend(instruction_out),
        .bit_extend_shift(instruction_shifted)
    );

    shift_left2 shift(
        .instruction(instruction[25:0]),
        .instruction_out(shift_instruction)
    );

    Instruction_Memory Mem1(
        .clk(clk),
        .rst(rst),
        .RE_mem1(RE_mem1),
        .address(pc_out),
        .Mem_out(instruction)
    );

    Data_Memory Mem2(
        .clk(clk),
        .rst(rst),
        .WE_mem2(WE_mem2),
        .RE_mem2(RE_mem2),
        .address(alu_out),
        .data(SR2_out),
        .Mem_out(data_mem_out)
    );

    real_Reg Reg(
        .clk(clk),
        .rst(rst),
        .RegW(RegW),
        .SR1(instruction[25:21]),
        .SR2(instruction[20:16]),
        .DR(mux1_out),
        .data_write(mux3_out),
        .SR1_out(SR1_out),
        .SR2_out(SR2_out)
    );

    Mux1 mux1(
        .data1(instruction[25:21]),
        .data2(instruction[20:16]),
        .sel(DR_select),
        .data_out(mux1_out)
    );

    Mux2 mux2(
        .data1(SR2_out),
        .data2(instruction_out),
        .sel(Reg_or_Imm),
        .data_out(mux2_out)
    );

    Mux2 mux3(
        .data1(data_mem_out),
        .data2(alu_out),
        .sel(ALU_or_Mem),
        .data_out(mux3_out)
    );
    
    Mux4 mux4(
        .PC_jump(PC_Jump_in),
        .PC_add_4(from_add4),
        .PC_branch(from_accum),
        .PC_JR(SR1_out),
        .PC_select(PC_select),
        .Mux_out(mux4_out)
    );

    real_alu alu(
        .f_code(OP),
        .format(format),
        .data1(SR1_out),
        .data2(mux2_out),
        .alu_out(alu_out)
    );

    assign instruction_out = (instruction[15]==1) ? {16'hFFFF, instruction[15:0]} : {16'h0000, instruction[15:0]};
    assign format = (instruction[31:26] == 6'd0) ? R : (((instruction[31:26] == 6'd2)|(instruction[31:26] == 6'd3)) ? J : I);
    assign PC_Jump_in = {from_add4[31:28], shift_instruction};

    always @(*) begin
            case(state)
                pc_start: begin
                    pc_out = pc_in + 1;
                    next_state = Instruction_Mem;
                end

                Instruction_Mem: begin
                    RE_mem1 = 1;
                    RegW = 0;
                    if(format == R)begin
                        DR_select = 0;
                        Reg_or_Imm = 1;
                        ALU_or_Mem = 0;
                        if(instruction[5:0] == 6'd8) begin //jr
                            PC_select = 2'd3;
                            next_state = pc_start; 
                        end
                        else begin
                            PC_select = 2'd1;
                            next_state = ALU;
                        end
                    end
                    else if(format == I) begin
                        DR_select = 1;
                        Reg_or_Imm = 0;
                        if(instruction[31:26] == 6'd35) begin //lw
                            //ALU_or_Mem = 1;
                            PC_select = 2'd1;
                            next_state = ALU;
                        end
                        else if(instruction[31:26] == 6'd43) begin //sw
                            PC_select = 2'd1;
                            next_state = ALU;
                        end
                        else if(instruction[31:26] == 6'd4) begin //beq
                            PC_select = 2'd2;
                            next_state = pc_start;
                        end
                        else if(instruction[31:26] == 6'd5) begin //bne
                            PC_select = 2'd2;
                            next_state = pc_start;
                        end
                        else begin
                            ALU_or_Mem = 0;
                            PC_select = 2'd1;
                            next_state = ALU;
                        end
                    end
                    else if(format == J) begin
                        //ALU_or_Mem = 1;
                        PC_select = 2'd0;
                        next_state = pc_start;
                    end
                end

                ALU: begin
                    RE_mem1 = 0;
                    if(format == R) begin
                        OP = instruction[5:0];
                        ALU_or_Mem = 0;
                        next_state = Register_write;
                    end
                    else if(format == I) begin
                        OP = instruction[31:26];
                        if(instruction[31:26] == 6'd35) begin
                            next_state = Register_write;
                        end
                        else if(instruction[31:26] == 6'd43) begin
                            next_state = data_memory_write;
                        end
                        else begin
                            next_state = Register_write;
                            ALU_or_Mem = 0;
                        end
                    end
                end

                data_memory_write: begin
                    WE_mem2 = 1;
                    RE_mem2 = 0;
                    next_state = Register_write;
                end

                Register_write: begin
                    WE_mem2 = 0;
                    RE_mem2 = 1;
                    if(format == R) ALU_or_Mem = 1;
                    else if(format == I) begin
                        if(instruction[31:26] == 6'd35) begin
                            ALU_or_Mem = 1;
                            RegW = 1;
                        end
                        else if(instruction[31:26] == 6'd43) begin
                            RegW = 0;
                        end
                        else begin
                            ALU_or_Mem = 0;
                            RegW = 1;
                        end
                    end
                    next_state = pc_start;
                end
            endcase
        end

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            state = 2'd0;
            pc_in = 0;
        end
        else begin
            state <= next_state;
            pc_in <= pc_out;
        end
    end

endmodule
