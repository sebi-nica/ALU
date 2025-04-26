module div_logic(
    input enable, // needed for FSM to exit IDLE state
    input[3:0] state_curr,
    input cnt_done, a7, start,
    output[3:0] state_nxt,
    output c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10
);

    assign state_nxt[0] = enable &(~state_curr[3] & ~state_curr[2] & ~state_curr[1] &  ~state_curr[0] & start |
                        ~state_curr[3] & ~state_curr[2] & state_curr[1] &  ~state_curr[0] |
                        ~state_curr[3] & state_curr[2] & ~state_curr[1] &  ~state_curr[0] |
                        state_curr[2] & state_curr[1] & ~state_curr[0] & ~a7 |
                        state_curr[3] & ~state_curr[2] & ~state_curr[1] & ~state_curr[0] |
                        ~state_curr[3] & state_curr[2] & state_curr[1] &  state_curr[0] |
                        state_curr[3] & ~state_curr[2] & state_curr[1] &  ~state_curr[0]);
    assign state_nxt[1] = enable &(state_curr[3] & ~state_curr[2] & state_curr[1] &  ~state_curr[0] |
                        state_curr[3] & ~state_curr[2] & ~state_curr[1] &  state_curr[0] & cnt_done |
                        state_curr[2] & state_curr[1] & ~state_curr[0] & ~a7 |
                        ~state_curr[3] & state_curr[2] & ~state_curr[1] &  state_curr[0] |
                        ~state_curr[3] & ~state_curr[2] & (state_curr[1] ^ state_curr[0]));
    assign state_nxt[2] = enable &(state_curr[3] & ~state_curr[1] & state_curr[0] & ~cnt_done |
                        state_curr[2] & state_curr[1] & ~state_curr[0] & ~a7 |
                        state_curr[2] & ~state_curr[1] |
                        ~state_curr[3] & ~state_curr[2] & state_curr[1] & state_curr[0]);
    assign state_nxt[3] = enable &(state_curr[3] & state_curr[1] & ~state_curr[0] |
                        state_curr[3] & ~state_curr[1] & state_curr[0] & cnt_done |
                        state_curr[3] & ~state_curr[2] & ~state_curr[1] & ~state_curr[0] |
                        ~state_curr[3] & state_curr[2] & state_curr[1] &  state_curr[0] |
                        state_curr[2] & state_curr[1] & a7);

    assign c0 = ~state_curr[3] & ~state_curr[2] & state_curr[1] &  state_curr[0]; 
    assign c1 = ~state_curr[3] & ~state_curr[2] & state_curr[1] & ~state_curr[0]; 
    assign c2 = (~state_curr[3] & state_curr[2] & ~state_curr[1] & state_curr[0]) |
                (state_curr[3] & ~state_curr[2] & ~state_curr[1] & ~state_curr[0]);
    assign c3 = state_curr[0];
    assign c4 = ~state_curr[3] & state_curr[2] & ~state_curr[1] & ~state_curr[0];
    assign c5 = state_curr[3] & ~state_curr[2] & ~state_curr[1] & state_curr[0];
    assign c6 = ~a7;
    assign c7 = state_curr[3] & ~state_curr[2] & state_curr[1] & state_curr[0];
    assign c8 = state_curr[3] & ~state_curr[2] & state_curr[1] & ~state_curr[0];
    assign c9 = ~state_curr[3] & ~state_curr[2] & ~state_curr[1] & state_curr[0]; //
    assign c10 = state_curr[3] & ~state_curr[2] & ~state_curr[1] & ~state_curr[0] |
                ~state_curr[3] & state_curr[2] & state_curr[1] &  state_curr[0];

    /*
        STATES BREAKDOWN:
        0000 - idle (waiting for 'start')
        0001 - A = in
        0010 - Q = in
        0011 - M = in
        0100 - shift
        0101 - A=A-M
        0110 - intermediate state. waiting for A to receive the correct value
        0111 - Q[0] = 1              when a7 = 0
        1000 - A = A+M ; Q[0] = 0    when a7 = 1
        1001 - incr
        1010 - out = Q
        1011 - out = A 
    */

endmodule