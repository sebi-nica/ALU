module adder_tb;

    reg clk;
    reg rst;
    reg [7:0] A, B;
    reg c_in;
    wire [8:0] sum;
    wire c_out;

    // Instantiate the adder module
    adder uut (
        .clk(clk),
        .rst(rst),
        .A(A),
        .B(B),
        .c_in(c_in),
        .sum(sum),
        .c_out(c_out)
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
        c_in = 0;

        // Apply reset
        rst = 1;
        #10;
        rst = 0;

        // Test case 1: 8 + (-5)
        A = 8'b00001000;  // 8
        B = 8'b11111011;  // -5 in C2
        c_in = 0;
        #10;

        // Test case 2: -1 + -1 (Overflow check)
        A = 8'b11111111;  // -1 in C2
        B = 8'b11111111;  // -1 in C2
        c_in = 0;
        #10;

        // Test case 3: -128 + -1 (Overflow check)
        A = 8'b10000000;  // -128 in C2
        B = 8'b11111111;  // -1 in C2
        c_in = 0;
        #10;

        // Test case 4: 127 + 1 (No overflow, normal case)
        A = 8'b01111111;  // 127
        B = 8'b00000001;  // 1
        c_in = 0;
        #10;

        // Test case 5: -64 + 32
        A = 8'b11000000;  // -64 in C2
        B = 8'b00100000;  // 32 in C2
        c_in = 0;
        #10;

        // End simulation
        $stop;
    end


    // Monitor outputs
    initial begin
        $monitor("Time=%0t A=%b B=%b c_in=%b sum=%b carry_out=%b", 
                  $time, A, B, c_in, sum, c_out);
    end

endmodule

