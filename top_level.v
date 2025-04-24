module top_level (
    input clk,
    input rst,
    input [7:0] inbus,
    input [1:0] op,
    input start,
    output [15:0] outbus,
    output [3:0] state,// debug stuff
    output[7:0] A,
    output[7:0] Q,
    output[7:0] M
);

    wire c0, c1, c2, c3, c4, c5, c6, c7;

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
        .z(outbus),
        .cnt_done(cnt_done),
        .q0(q0),
        .qm1(qm1),
        .a7(a7),
        .AQM_debug({A, Q, M})
    );
endmodule
