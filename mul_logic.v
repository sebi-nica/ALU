module mul_logic(
    input enable, // needed for FSM to exit IDLE state
    input[3:0] state_curr,
    input cnt_done, q0, qm1, a7, start,
    output[3:0] state_nxt,
    output c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10
);
// logic


    assign state_nxt[0] = enable & (
    (state_curr[2] & state_curr[1] & ~state_curr[0]) |
    (state_curr[2] & ~state_curr[0] & ~cnt_done) |
    (~state_curr[2] & ~state_curr[1] & ~state_curr[0] & start) |
    (state_curr[1] & ~state_curr[0] & (q0 ^ qm1)) |
    (state_curr[2] & ~state_curr[1] & state_curr[0] & (q0 ^ qm1))
    );

    assign state_nxt[1] = enable & (
    (~state_curr[2] & ~state_curr[1] & state_curr[0]) |
    (state_curr[2] & state_curr[1] & ~state_curr[0]) |
    (state_curr[2] & ~state_curr[0] & cnt_done) |
    ((state_curr[1] ^ state_curr[0]) & (q0 ^ qm1))
    );

    assign state_nxt[2] = enable & (
    (state_curr[2] & ~state_curr[0]) |
    (~state_curr[2] & state_curr[1] & state_curr[0]) |
    (state_curr[2] & ~state_curr[1] & q0 & qm1) |
    (state_curr[2] & ~state_curr[1] & ~q0 & ~qm1) |
    (state_curr[1] & ~state_curr[0] & q0 & qm1) |
    (state_curr[1] & ~state_curr[0] & ~q0 & ~qm1)
    );


    assign state_nxt[3] = 1'b0; 
    assign c0 = ~state_curr[2] & state_curr[1] & ~state_curr[0]; // 001 - load M
    assign c1 = ~state_curr[2] & ~state_curr[1] & state_curr[0]; // 010 - load Q
    assign c2 = ~state_curr[2] & state_curr[1] & state_curr[0]; // 011 - load A with adder result
    assign c3 = q0 & ~qm1; 
    assign c4 = state_curr[2] & ~state_curr[1] & ~state_curr[0]; // 100 - shift
    assign c5 = state_curr[2] & ~state_curr[1] & state_curr[0]; // 101 - incr
    assign c6 = a7;
    assign c7 = state_curr[2] & state_curr[1] & ~state_curr[0];// 110 - load output with A
    assign c8 = state_curr[2] & state_curr[1] & state_curr[0];// 111 - load output with Q
    assign c9 = 1'b0;
    assign c10 = 1'b0;


    /*
        STATES BREAKDOWN:
        000 - idle (waiting for 'start')
        001 - M = inbus c0
        010 - Q = inbus c1
        011 - A = A+-M c2
        100 - SHIFT c4
        101 - increment counter c5
        110 - output = A 
        111 - output = Q
    */

endmodule