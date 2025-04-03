module adder #(parameter w = 8) ( 
    input [w-1:0] x, y, 
    input flag,
    output [w:0] z
);
    wire [w:0] x1, y1;
    wire [w+1:0] carry;
    assign carry[0] = flag;
    assign x1 = {x[w-1], x};
    assign y1 = {y[w-1], y} ^ {(w+1){flag}};

    genvar i;
    generate
        for (i = 0; i <= w; i = i + 1) begin : fac_loop
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
