module shift_left2(
    input [25:0] instruction,
    output [27:0] instruction_out
);

    assign instruction_out = instruction << 2;
endmodule