module adder_tb;

    reg clk;
    reg rst;
    reg [7:0] A, B;
    reg flag;
    wire [8:0] sum;

    // Instantiate the adder module
    adder add_sub (
        .x(A),
        .y(B),
        .flag(flag),
        .z(sum)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Test procedure
        initial begin
        // Initial values
        clk = 0;
        rst = 0;
        A = 8'b00000000;
        B = 8'b00000000;
        flag = 0;

        // Apply reset
        rst = 1;
        #10;
        rst = 0;

        // Test case 1: 8 + (-5)
        A = 8'b00001000;  // 8
        B = 8'b11111011;  // -5 in C2
        #5;
        flag = 1;
        #5;
        flag = 0;

        // Test case 2: -1 + -1 (Overflow check)
        A = 8'b11111111;  // -1 in C2
        B = 8'b11111111;  // -1 in C2
        #5;
        flag = 1;
        #5;
        flag = 0;

        // Test case 3: -128 + -1 (Overflow check)
        A = 8'b10000000;  // -128 in C2
        B = 8'b11111111;  // -1 in C2
        #5;
        flag = 1;
        #5;
        flag = 0;

        // Test case 4: 127 + 1 (No overflow, normal case)
        A = 8'b01111111;  // 127
        B = 8'b00000001;  // 1
        #5;
        flag = 1;
        #5;
        flag = 0;

        // Test case 5: -64 + 32
        A = 8'b11000000;  // -64 in C2
        B = 8'b00100000;  // 32 in C2
        #5;
        flag = 1;
        #5;
        flag = 0;

        // End simulation
        $stop;
    end

endmodule

