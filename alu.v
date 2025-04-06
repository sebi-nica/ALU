module alu #(parameter w = 8)(
    input clk,
    input rst,
    input [w-1:0] x, y,
    input [1:0] op, // 00 = add, 01 = sub, 10 = mul, 11 = div
    input start,
    output reg [2*w-1:0] z,
    output reg done
);
    wire done0, done10, done11;
    assign done = done0;
    always @(*) begin
        if(start) begin
            case (op)
                2'b00: begin // add

                end
                2'b01: begin // sub

                end
                2'b10: begin // mul

                end
                2'b11: begin // div

                end
            endcase
        end
    end

endmodule