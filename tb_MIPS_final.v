module tb_MIPS();
    reg clk;
    reg rst;
    wire [31:0] mux3_out;

    MIPS mips(
        .clk(clk),
        .rst(rst),
        .mux3_out(mux3_out)
    );

    always #10 clk = ~clk;

    initial begin
        $dumpfile("tb_MIPS.vcd");
        $dumpvars(0,tb_MIPS);
        $monitor("$time: %0d, mux3_out: %d", $time, mux3_out);
    
        clk = 0;
        rst = 1;

        #20
        rst = 0;

        #10000
        $finish;
    end
endmodule