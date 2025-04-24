module div_logic(
    input enable, // needed for FSM to exit IDLE state
    input[3:0] state_curr,
    input cnt_done, q0, a7, start,
    output[3:0] state_nxt,
    output c0, c1, c2, c3, c4, c5, c6, c7
);

    assign state_nxt[0] = 1'b0;
    assign state_nxt[1] = 1'b0;
    assign state_nxt[2] = 1'b0;
    assign state_nxt[3] = 1'b0;
    assign c0 = 1'b0;
    assign c1 = 1'b0;
    assign c2 = 1'b0;
    assign c3 = 1'b0;
    assign c4 = 1'b0;
    assign c5 = 1'b0;
    assign c6 = 1'b0;
    assign c7 = 1'b0;

    /*
        STATES BREAKDOWN:
        000 - idle (waiting for 'start')
        001 - M = inbus
        010 - Q = inbus
        
    */

endmodule