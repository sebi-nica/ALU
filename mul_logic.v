module mul_logic(
    input[3:0] state_curr,
    input cnt_done, q0, qm1, a7,
    output[3:0] state_nxt,
    output c0, c1, c2, c3, c4, c5, c6, c7
);
// logic
    assign state_nxt[0] =
    assign state_nxt[1] =
    assign state_nxt[2] =
    assign state_nxt[3] = 1'b0; // I made the state register too big
    assign c0 = ~state_curr[2] & ~state_curr[1] & state_curr[0];
    assign c1 = ~state_curr[2] & state_curr[1] & ~state_curr[0];
    assign c2 = ~state_curr[2] & state_curr[1] & state_curr[0];
    assign c3 = q0 & ~qm1;
    assign c4 = state_curr[2] & ~state_curr[1] & ~state_curr[0];
    assign c5 = state_curr[2] & ~state_curr[1] & state_curr[0];
    assign c6 = a7;
    assign c7 = state_curr[2] & state_curr[1] & ~state_curr[0];
endmodule