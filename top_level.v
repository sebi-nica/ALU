module top_level(
    input clk,
    input rst,
    input [7:0] inbus,
    input [1:0] op, // 00 = add, 01 = sub, 10 = mul, 11 = div
    input start,
    output [15:0] outbus
);
    arithmetic_unit arithmetic_unit_inst(
        
    );  

    control_unit control_unit_inst(

    );

endmodule