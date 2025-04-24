`timescale 1ns / 1ps

module top_level_tb;

    reg clk;
    reg rst;
    reg [7:0] inbus;
    reg [1:0] op;
    reg start;

    wire [15:0] outbus;
    wire [3:0] state;
    wire [7:0] A;
    wire [7:0] Q;
    wire [7:0] M;

    top_level uut (
        .clk(clk),
        .rst(rst),
        .inbus(inbus),
        .op(op),
        .start(start),
        .outbus(outbus),
        .state(state),
        .A(A),
        .Q(Q),
        .M(M)
    );

    initial clk = 0;
    always begin
        #5;
        clk = ~clk;
    end

    initial begin
        start = 0; op = 2'b00; inbus = 8'h00;


        rst = 1; #20; rst = 0;
        // ADD: 5 + 3
        op = 2'b10;
        start = 1;
        inbus = 8'd5;
        #20;
        inbus = 8'd3;
        start = 0;

        #480;
        

        rst = 1; #20; rst = 0;
        // SUB: 9 - 4
        op = 2'b10;
        start = 1;
        inbus = 8'd14;
        #20;
        inbus = 8'd52;
        start = 0;

        #480;

        $stop;
    end

endmodule
