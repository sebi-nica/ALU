module adder( 
    input [7:0] x, y, 
    input flag,
    output [8:0] z
);
    wire [8:0] x1, y1;
    wire [9:0] carry;
    assign carry[0] = flag;
    assign x1 = {x[7], x};
    assign y1 = {y[7], y} ^ {(9){flag}};

    genvar i;
    generate
        for (i = 0; i <= 8; i = i + 1) begin : fac_loop
            fac fac_inst (
                .x(x1[i]), 
                .y(y1[i]), 
                .c_in(carry[i]), 
                .z(z[i]), 
                .c_out(carry[i+1])
            );
        end
    endgenerate

endmodule
