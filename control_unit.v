module control_unit (
    input clk,
    input rst,
    input [1:0] op, // 00 = add, 01 = sub, 10 = mul, 11 = div
    input cnt_done,
    input q0, // info provided by the arithmetic unit
    input qm1,
    input a7,
    input start,
    output c0,// load input to M
    output c1,// load input to Q
    output c2,// load result from adder to A
    output c3,// tell adder which operation to do 0=add 1=sub
    output c4,// = enable_shift = while this is on, A and Q will shift on every clock cycle, shift direction depends on operation 
    output c5,// = increment counter = while this is on, cnt will increment on every clock cycle
    output c6,// input bit for bit shift
    output c7,// load first part of out
    output c8,// load second part of out
    output c9,// (division only) load input to A
    output c10,// (division only) only load Q[0] with value from c6
    output internal_rst,
    output finish,
    output [3:0] state // debug
);

    wire[3:0] state_nxt, state_curr;
    wire[3:0] state_nxt_add_sub, state_nxt_mul, state_nxt_div;

    assign state = state_curr;

    assign state_nxt = ({4{~op[1]}} & state_nxt_add_sub) |
                       ({4{op[1] & ~op[0]}} & state_nxt_mul) |
                       ({4{op[1] & op[0]}} & state_nxt_div); // choose the next state based on operation
    wire c0_add_sub, c1_add_sub, c2_add_sub, c3_add_sub, c4_add_sub, c5_add_sub, c6_add_sub, c7_add_sub, c8_add_sub, c9_add_sub, c10_add_sub;
    wire c0_mul, c1_mul, c2_mul, c3_mul, c4_mul, c5_mul, c6_mul, c7_mul, c8_mul, c9_mul, c10_mul;
    wire c0_div, c1_div, c2_div, c3_div, c4_div, c5_div, c6_div, c7_div, c8_div, c9_div, c10_div;

    
    assign c0 = (~op[1] & c0_add_sub) | (op[1] & ((~op[0] & c0_mul) | (op[0] & c0_div)));
    assign c1 = (~op[1] & c1_add_sub) | (op[1] & ((~op[0] & c1_mul) | (op[0] & c1_div)));
    assign c2 = (~op[1] & c2_add_sub) | (op[1] & ((~op[0] & c2_mul) | (op[0] & c2_div)));
    assign c3 = (~op[1] & c3_add_sub) | (op[1] & ((~op[0] & c3_mul) | (op[0] & c3_div)));
    assign c4 = (~op[1] & c4_add_sub) | (op[1] & ((~op[0] & c4_mul) | (op[0] & c4_div)));
    assign c5 = (~op[1] & c5_add_sub) | (op[1] & ((~op[0] & c5_mul) | (op[0] & c5_div)));
    assign c6 = (~op[1] & c6_add_sub) | (op[1] & ((~op[0] & c6_mul) | (op[0] & c6_div)));
    assign c7 = (~op[1] & c7_add_sub) | (op[1] & ((~op[0] & c7_mul) | (op[0] & c7_div)));
    assign c8 = (~op[1] & c8_add_sub) | (op[1] & ((~op[0] & c8_mul) | (op[0] & c8_div)));
    assign c9 = (~op[1] & c9_add_sub) | (op[1] & ((~op[0] & c9_mul) | (op[0] & c9_div)));
    assign c10 = (~op[1] & c10_add_sub) | (op[1] & ((~op[0] & c10_mul) | (op[0] & c10_div)));

    assign internal_rst = ~(state_curr[3] | state_curr[2] | state_curr[1] | state_curr[0]);
    assign finish = (~op[1] & state_curr[1] & state_curr[0]) |
                    (op[1] & ((~op[0] & state_curr[2] & state_curr[1] & ~state_curr[0]) |
                    (op[0] & state_curr[3] & ~state_curr[2] & state_curr[1] & ~state_curr[0])));

    reg_4 state_reg(
        .clk(clk),
        .rst(rst),
        .in(state_nxt),
        .load(1'b1),
        .out(state_curr)
    );

    add_sub_logic add_sub_logic_inst(
        .enable(1'b1),
        .state_curr(state_curr),
        .start(start),
        .op(op[0]),
        .state_nxt(state_nxt_add_sub),
        .c0(c0_add_sub),
        .c1(c1_add_sub),
        .c2(c2_add_sub),
        .c3(c3_add_sub),
        .c4(c4_add_sub),
        .c5(c5_add_sub),
        .c6(c6_add_sub),
        .c7(c7_add_sub),
        .c8(c8_add_sub),
        .c9(c9_add_sub),
        .c10(c10_add_sub)
    );

    mul_logic mul_logic_inst(
        .enable(op[1] & ~op[0]),
        .state_curr(state_curr),
        .cnt_done(cnt_done),
        .q0(q0),
        .qm1(qm1),
        .a7(a7),
        .start(start),
        .state_nxt(state_nxt_mul),
        .c0(c0_mul),
        .c1(c1_mul),
        .c2(c2_mul),
        .c3(c3_mul),
        .c4(c4_mul),
        .c5(c5_mul),
        .c6(c6_mul),
        .c7(c7_mul),
        .c8(c8_mul),
        .c9(c9_mul),
        .c10(c10_mul)
    );

    div_logic div_logic_inst(
        .enable(op[1] & op[0]),
        .state_curr(state_curr),
        .cnt_done(cnt_done),
        .a7(a7),
        .start(start),
        .state_nxt(state_nxt_div),
        .c0(c0_div),
        .c1(c1_div),
        .c2(c2_div),
        .c3(c3_div),
        .c4(c4_div),
        .c5(c5_div),
        .c6(c6_div),
        .c7(c7_div),
        .c8(c8_div),
        .c9(c9_div),
        .c10(c10_div)
    );

    


endmodule