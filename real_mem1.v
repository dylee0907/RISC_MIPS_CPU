module Instruction_Memory(
    input clk,
    input rst,
    input RE_mem1, //read enable
    input [31:0] address,
    output reg [31:0] Mem_out
);

    reg [31:0] Mem [0:63];

    integer i;
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            /*for(i=0; i<63; i=i+1) begin
                Mem[i] <= 32'd0;
            end*/
            $readmemh("MIPS_Instructions2.txt", Mem);
        end 
        else begin
            if(RE_mem1) Mem_out <= Mem[address];
            else Mem[address] <= Mem[address];
         end
    end   
endmodule