module Mux1(
    input [4:0] data1,
    input [4:0] data2,
    input sel,
    output [4:0] data_out
);

    assign data_out = (sel) ? data1 : data2;

endmodule