module top_level (
    input clk,
    input rst,
    input [7:0] inbus,
    input [1:0] op,
    input start,
    output [7:0] outbus,
    output finish,
    output [3:0] state,// debug stuff
    output[7:0] A,// debug stuff
    output[7:0] Q,// debug stuff
    output[7:0] M// debug stuff
);

    wire c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, internal_rst;

    wire cnt_done, q0, qm1, a7;

    control_unit c_u (
        .clk(clk),
        .rst(rst),
        .op(op),
        .cnt_done(cnt_done),
        .q0(q0),
        .qm1(qm1),
        .a7(a7),
        .start(start),
        .c0(c0),
        .c1(c1),
        .c2(c2),
        .c3(c3),
        .c4(c4),
        .c5(c5),
        .c6(c6),
        .c7(c7),
        .c8(c8),
        .c9(c9),
        .c10(c10),
        .internal_rst(internal_rst),
        .finish(finish),
        .state(state)
    );

    arithmetic_unit a_u (
        .clk(clk),
        .rst(rst),
        .in(inbus),
        .op(op),
        .c0(c0),
        .c1(c1),
        .c2(c2),
        .c3(c3),
        .c4(c4),
        .c5(c5),
        .c6(c6),
        .c7(c7),
        .c8(c8),
        .c9(c9),
        .c10(c10),
        .internal_rst(internal_rst),
        .out(outbus),
        .cnt_done(cnt_done),
        .q0(q0),
        .qm1(qm1),
        .a7(a7),
        .AQM_debug({A, Q, M})
    );
endmodule
