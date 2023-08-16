module Data_Memory(
    input clk,
    input rst,
    input WE_mem2, //write enable
    input RE_mem2, //read enable
    input [31:0] address,
    input [31:0] data,
    output reg [31:0] Mem_out
);

    reg [31:0] Mem [0:63];

    integer i;
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            for(i=0; i<63; i=i+1) begin
                Mem[i] <= 32'd0;
            end
        end 
        else begin
            if(WE_mem2) Mem[address] <= data;
            else if(RE_mem2) Mem_out <= Mem[address];
            else Mem[address] <= Mem[address];
        end
    end
endmodule