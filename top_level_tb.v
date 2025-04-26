`timescale 1ns / 1ps

module top_level_tb;

    reg clk;
    reg rst;
    reg [7:0] inbus;
    reg [1:0] op;
    reg start;

    wire [7:0] outbus;
    wire [3:0] state;
    wire [7:0] A;
    wire [7:0] Q;
    wire [7:0] M;
    wire finish;

    top_level uut (
        .clk(clk),
        .rst(rst),
        .inbus(inbus),
        .op(op),
        .start(start),
        .outbus(outbus),
        .finish(finish),
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

    task add;
        input signed[7:0] in1, in2;
        reg signed[15:0] out, expected_out;

        begin
            out = 0;
            expected_out = in1 + in2;

            op = 2'b00;
            start = 1;
            #10;
            start = 0;
            inbus = in1;
            #10;
            inbus = in2;
            
            wait(finish); #5;
            out[15:8] = outbus; #10;
            out[7:0] = outbus;
            
            if (out !== expected_out)
                    $display("FAIL: %d + %d = %d, expected %d", in1, in2, out, expected_out);
                else
                    $display("PASS: %d + %d = %d", in1, in2, out);
            #10;
        end
    endtask

    task subtract;
        input signed[7:0] in1, in2;
        reg signed[15:0] out, expected_out;

        begin
            out = 0;
            expected_out = in1 - in2;

            op = 2'b01;
            start = 1;
            #10;
            start = 0;
            inbus = in1;
            #10;
            inbus = in2;
            
            wait(finish); #5;
            out[15:8] = outbus; #10;
            out[7:0] = outbus;
            
            if (out !== expected_out)
                    $display("FAIL: %d - %d = %d, expected %d", in1, in2, out, expected_out);
                else
                    $display("PASS: %d - %d = %d", in1, in2, out);
            #10;
        end
    endtask

    task multiply;
        input[7:0] in1, in2;
        reg signed [15:0] out, expected_out;

        begin
            out = 0;
            expected_out = in1 * in2;

            op = 2'b10;
            start = 1;
            #10;
            start = 0;
            inbus = in1;
            #10;
            inbus = in2;
            
            wait(finish); #5;
            out[15:8] = outbus; #10;
            out[7:0] = outbus;
            
            if (out !== expected_out)
                    $display("FAIL: %d * %d = %d, expected %d", in1, in2, out, expected_out);
                else
                    $display("PASS: %d * %d = %d", in1, in2, out);
        end
    endtask

    task divide;
        input[15:0] in1;
        input[7:0] in2;
        reg signed[7:0] out1, out2, expected_out1, expected_out2;

        begin
            out1 = 0; out2 = 0;
            expected_out1 = in1 / in2;
            expected_out2 = in1 % in2;

            op = 2'b11;
            start = 1;
            #10;
            start = 0;
            inbus = in1[15:8];
            #10;
            inbus = in1[7:0];
            #10;
            inbus = in2;
            
            wait(finish); #5;
            out1 = outbus; #10;
            out2 = outbus;
            
            if (out1 !== expected_out1 | out2 !== expected_out2)
                    $display("FAIL: %d / %d = %d | R: %d, expected %d | R: %d", in1, in2, out1, out2, expected_out1, expected_out2);
                else
                    $display("PASS: %d / %d = %d | R: %d", in1, in2, out1, out2);
        end
    endtask

    task randomAdd;
    input integer n;
    integer i;
    reg signed[7:0] a, b;
    begin
        for (i = 0; i < n; i = i + 1) begin
            a = $random;
            b = $random;
            add(a, b);
        end
    end
    endtask

    task randomSubtract;
    input integer n;
    integer i;
    reg signed[7:0] a, b;
    begin
        for (i = 0; i < n; i = i + 1) begin
            a = $random;
            b = $random;
            subtract(a, b);
        end
    end
    endtask


    initial begin

        start = 0; op = 2'b00; inbus = 8'h00;
        rst = 1; #20; rst = 0;
        
        randomAdd(8);

        randomSubtract(8);

        $stop;
    end

endmodule
