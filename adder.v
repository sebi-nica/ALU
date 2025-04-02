module adder(
    input clk,
    input rst,
    input [7:0] A, B,      // 8-bit operands
    input c_in,            // Carry-in
    output reg [8:0] sum,  // 8-bit result
    output reg c_out,  // Carry-out
    output reg ovr // ovrflw
);

    reg [8:0] temp_sum;    // Temporary 9-bit sum (to store carry)

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            temp_sum <= 9'b0;
            c_out <= 1'b0;
            ovr <= 1'b0;
        end else begin
            temp_sum = A + B + c_in; // Add A, B, and carry-in
            sum <= temp_sum[7:0];    // Store lower 8 bits
            c_out <= temp_sum[8]; // Store carry-out
            ovr <= (A[7] == B[7]) && (A[7] != sum[7]);
        end
    end

endmodule
