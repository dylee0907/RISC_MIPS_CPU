module accumulate (
    input [31:0] accum1,
    input [31:0] accum2,
    output reg [31:0] accum_out
);

    always @(accum2 != 0) begin
        accum_out = accum1 + accum2;
    end
endmodule