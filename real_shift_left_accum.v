module shift_left2_accum(
    input [31:0] bit_extend,
    output [31:0] bit_extend_shift
);

    assign bit_extend_shift = bit_extend << 2;

endmodule