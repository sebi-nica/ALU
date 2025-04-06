module reg_8b (
    input wire clk,         
    input wire rst, 
    input wire [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 0;
        end else begin
            q <= d;
        end
    end

endmodule

