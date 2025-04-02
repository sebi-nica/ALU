`timescale 1ns / 1ps
module and_gate_tb;
  reg a, b;
  wire y;

  and_gate uut (
    .a(a),
    .b(b),
    .y(y)
  );

  initial begin
    // Test case 1
    a = 0; b = 0;
    #10;
    // Test case 2
    a = 0; b = 1;
    #10;
    // Test case 3
    a = 1; b = 0;
    #10;
    // Test case 4
    a = 1; b = 1;
    #10;
  end
endmodule

