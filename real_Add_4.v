module Add_4(
    input [31:0] from_pc,
    output [31:0] to_accum
);

    assign to_accum = from_pc + 32'd1;
endmodule