module real_Reg(
    input clk,
    input rst,
    input RegW,
    input [4:0] SR1,
    input [4:0] SR2,
    input [4:0] DR,
    input [31:0] data_write,
    output reg [31:0] SR1_out,
    output reg [31:0] SR2_out
);

    reg [31:0] Reg [0:31];

    integer i;
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            for(i=0; i<32 ; i=i+1) begin
                Reg[i] <= 0;
            end
        end
        else begin
            if(RegW) Reg[DR] <= data_write;
            else begin
                Reg[DR] <= Reg[DR];
                SR1_out <= Reg[SR1];
                SR2_out <= Reg[SR2];
            end
        end
    end

endmodule