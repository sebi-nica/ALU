module add_sub_logic(
    input enable, // needed for FSM to exit IDLE state
    input[3:0] state_curr,
    input start,
    input op,
    output[3:0] state_nxt,
    output c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10
);
// logic
    assign state_nxt[0] = ((state_curr[1] & ~state_curr[0]) | (start & ~state_curr[2] & ~state_curr[0])) & enable;
    assign state_nxt[1] = (state_curr[1] ^ state_curr[0]) & enable;
    assign state_nxt[2] = (state_curr[1] & state_curr[0]) & enable;
    assign state_nxt[3] = 1'b0;
    assign c0 = state_curr[1] & ~state_curr[0]; // load M
    assign c1 = ~state_curr[1] & state_curr[0]; // load Q
    assign c2 = 1'b0;
    assign c3 = op;
    assign c4 = 1'b0; // all these are unused with add/sub
    assign c5 = 1'b0;
    assign c6 = 1'b0;
    assign c7 = state_curr[1] & state_curr[0]; // done
    assign c8 = state_curr[2];
    assign c9 = 1'b0;
    assign c10 = 1'b0;

    /*
        STATES BREAKDOWN:
        000 - idle (waiting for 'start')
        001 - M = inbus
        010 - Q = inbus
        011 - outbus = result1
        100 - outbus = result0
    */
endmodule