module Mux4(
    input [31:0] PC_jump,
    input [31:0] PC_add_4,
    input [31:0] PC_branch,
    input [31:0] PC_JR,
    input [1:0] PC_select,
    output reg [31:0] Mux_out
);

    always @(*) begin
        case(PC_select) 
            0: Mux_out <= PC_jump;
            1: Mux_out <= PC_add_4;
            2: Mux_out <= PC_branch;
            3: Mux_out <= PC_JR;
        endcase    
    end

endmodule