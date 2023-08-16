module real_alu(
    input [5:0] f_code,
    input [1:0] format,
    input [31:0] data1,
    input [31:0] data2,
    output reg [31:0] alu_out
);  

    wire signed [31:0] s_data1;
    wire signed [31:0] s_data2;

    assign s_data1 = data1;
    assign s_data2 = data2;

    always @(*) begin
        case(f_code)
            6'd32: alu_out = s_data1 + s_data2;
            6'd34: alu_out = s_data1 - s_data2;
            6'd8:  if(format == 2'd1) alu_out = s_data1 + s_data2;
                   else if(format == 2'd0) alu_out = s_data1;
            6'd33: alu_out = data1 + data2;
            6'd35: if(format == 2'd0) alu_out = data1 - data2;
                   else if(format == 2'd1) alu_out = data1 + data2; 
            6'd9:  alu_out = data1 + data2;                 
            6'd0:  alu_out = data2 << 10;
            6'd24: alu_out = s_data1 * s_data2;
            6'd25: alu_out = data1 * data2;
            6'd26: if(data1 > data2) alu_out = s_data1 / s_data2;
                   else alu_out = s_data2 / s_data1;
            6'd27: if(data1 > data2) alu_out = data1 / data2;
                   else alu_out = data2 / data1;
            6'd36: alu_out = (s_data1 & s_data2);
            6'd37: alu_out = (s_data1 | s_data2);
            6'd12: alu_out = (s_data1 & s_data2);
            6'd13: alu_out = (s_data1 | s_data2);
            6'd2:  alu_out = data2;
            6'd43: if(format == 2'd1) alu_out = data1 + data2;
                   else if(format == 2'd0) begin
                        if(data1 < data2) alu_out = 32'd1;
                        else alu_out = 32'd0;
                   end
            6'd15: alu_out = s_data2 >> 16;
            6'd42: if(s_data1 < s_data2) alu_out = 32'd1;
                   else alu_out = 32'd0;
            6'd10: if(s_data1 < s_data2) alu_out = 32'd1;
                   else alu_out = 32'd0;
            6'd11: if(data1 < data2) alu_out = 32'd1;
                   else alu_out = 32'd0;
            default: alu_out = 0;
        endcase
    end

endmodule