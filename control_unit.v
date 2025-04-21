module control_unit (
    input clk,
    input rst,
    input [1:0] op, // 00 = add, 01 = sub, 10 = mul, 11 = div
    input cnt_done,
    input q0, // info provided by the arithmetic unit
    input qm1,
    input a7,
    output c0,// load input to Q
    output c1,// load input to M
    output c2,// load result from adder to A
    output c3,// tell adder which operation to do 0=add 1=sub
    output c4,// = enable_shift = while this is on, A and Q will shift on every clock cycle, shift direction depends on operation 
    output c5,// = increment counter = while this is on, cnt will increment on every clock cycle
    output c6,// input bit for bit shift
    output c7 // load AQ to output
);

    wire[3:0] state_nxt, state_curr;
    wire c0_mul, c1_mul, c2_mul, c3_mul, c4_mul, c5_mul, c6_mul, c7_mul;
    wire c0_div, c1_div, c2_div, c3_div, c4_div, c5_div, c6_div, c7_div;


    assign c0 = (op[0] & c0_div) | (~op[0] & c0_mul);
    assign c1 = (op[0] & c1_div) | (~op[0] & c1_mul);
    assign c2 = (op[0] & c2_div) | (~op[0] & c2_mul);
    assign c3 = (op[0] & c3_div) | (~op[0] & c3_mul);
    assign c4 = (op[0] & c4_div) | (~op[0] & c4_mul);
    assign c5 = (op[0] & c5_div) | (~op[0] & c5_mul);
    assign c6 = (op[0] & c6_div) | (~op[0] & c6_mul);
    assign c7 = (op[0] & c7_div) | (~op[0] & c7_mul);


    reg_4 state_reg(
        .clk(clk),
        .rst(rst),
        .in(state_nxt),
        .load(op[1]), // states can be changed only when operation is mul/div
        .out(state_curr)
    );

    mul_logic mul_logic_inst(
        .state_curr(state_curr),
        .cnt_done(cnt_done),
        .q0(q0),
        .qm1(qm1),
        .state_nxt(state_nxt),
        .c0(c0_mul),
        .c1(c1_mul),
        .c2(c2_mul),
        .c3(c3_mul),
        .c4(c4_mul),
        .c5(c5_mul),
        .c6(c6_mul),
        .c7(c7_mul)
    );

    div_logic div_logic_inst(
        .state_curr(state_curr),
        .cnt_done(cnt_done),
        .q0(q0),
        .a7(a7),
        .state_nxt(state_nxt),
        .c0(c0_div),
        .c1(c1_div),
        .c2(c2_div),
        .c3(c3_div),
        .c4(c4_div),
        .c5(c5_div),
        .c6(c6_div),
        .c7(c7_div)
    );

endmodule