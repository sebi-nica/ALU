module mul_logic(
    input enable, // needed for FSM to exit IDLE state
    input[3:0] state_curr,
    input cnt_done, q0, qm1, a7, start,
    output[3:0] state_nxt,
    output c0, c1, c2, c3, c4, c5, c6, c7
);
// logic


    assign state_nxt[0] = ((state_curr[2] & ~state_curr[0]) |
                      (state_curr[1] & ~state_curr[0]) |
                      (~state_curr[0] & start) |
                      (state_curr[2] & ~state_curr[1] & cnt_done) |
                      (~state_curr[2] & state_curr[1] & q0 & qm1) |
                      (~state_curr[2] & state_curr[1] & ~q0 & ~qm1)) & enable;
    assign state_nxt[1] = (state_curr[1] ^ state_curr[0]) & enable;
    assign state_nxt[2] = ((state_curr[2] & ~state_curr[1]) | 
                      (~state_curr[2] & state_curr[1] & state_curr[0])) & enable;
    assign state_nxt[3] = 1'b0; // I made the state register too big
    assign c0 = ~state_curr[2] & ~state_curr[1] & state_curr[0]; // 001 - load M
    assign c1 = ~state_curr[2] & state_curr[1] & ~state_curr[0]; // 010 - load Q
    assign c2 = state_curr[2] & ~state_curr[1] & ~state_curr[0]; // 100 - load A with adder result
    assign c3 = q0 & ~qm1; 
    assign c4 = state_curr[2] & ~state_curr[1] & state_curr[0]; // 101 - shift
    assign c5 = state_curr[2] & state_curr[1] & ~state_curr[0]; // 110 - incr
    assign c6 = a7;
    assign c7 = state_curr[2] & state_curr[1] & state_curr[0]; 

    /*
        STATES BREAKDOWN:
        000 - idle (waiting for 'start')
        001 - M = inbus
        010 - Q = inbus
        011 - idle2 (decision based on Q[0:-1] is being made)
        100 - A = A+-M
        101 - SHIFT
        110 - increment counter
        111 - output = AQ
    */

endmodule