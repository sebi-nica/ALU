module arithmetic_unit (
    input clk,
    input rst,
    input [7:0] in,
    input [1:0] op, // 00 = add, 01 = sub, 10 = mul, 11 = div
    input c0,// load input to M and set all other regs to 0
    input c1,// load input to Q
    input c2,// load result from adder to A
    input c3,// tell adder which operation to do 0=add 1=sub
    input c4,// = enable_shift = while this is on, A and Q will shift on every clock cycle, shift direction depends on operation 
    input c5,// = increment counter = while this is on, cnt will increment on every clock cycle
    input c6,// input bit for bit shift
    input c7,// load AQ to output
    output reg [15:0] z,// this goes straight to the output when ready
    output cnt_done, // when cnt = 111
    output q0, // q[0]
    output qm1, // q[-1]
    output a7 // a[7]
);

wire[7:0]aq_in;
wire[15:0]aq_out;
wire aq_bit_in, aq_bit_out;
assign aq_in = in;
assign aq_bit_in = c6;

wire[7:0]m_in, m_out;
assign m_in = in;

wire[7:0] add_in1, add_in2;
wire add_op;
wire[8:0] add_temp_result;
assign add_in2 = m_out;

wire[2:0] cnt_out;

assign cnt_done = cnt_out[0] & cnt_out[1] & cnt_out[2];
assign q0 = aq_out[0];
assign a7 = aq_out[15];


/*
this part allows the circuit to skip using any sequential logic
in case the operation required is simple (add / sub) (when op[0] is 0)
by passing the inputs straight to the adder and the adder's output straight to the output
    ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓
*/
assign z = ({{7{add_temp_result[8]}}, add_temp_result} & {16{~op[1]}}) | (aq_out & {16{c7}});
assign add_in1 = (aq_out[7:0] & {8{~op[1]}}) | (aq_out[15:8] & {8{op[1]}});
assign add_op = ~op[1] & op[0] | c3;

    shift_reg_16 AQ(
        .clk(clk),
        .rst(rst | c0),
        .in(aq_in),
        .load({c2, c1}), // c1 - load in Q c2 - load in A
        .bit_in(aq_bit_in), 
        .sel({c4, ~op[0]}),
        .out(aq_out),
        .bit_out(aq_bit_out)
    );

    reg_1 extraQ(
        .in(aq_bit_out),
        .load(c4),
        .clk(clk),
        .rst(rst | c0),
        .out(qm1)
    );

    reg_8 M(
        .clk(clk),
        .rst(rst),
        .in(m_in),
        .load(c0), // c0 - load in M
        .out(m_out)
    );

    adder add_inst(
        .x(add_in1),
        .y(add_in2),
        .op(add_op),
        .z(add_temp_result)
    );

    cnt counter(
        .clk(clk),
        .rst(rst | c0),
        .incr(c5), // c5 - increment
        .out(cnt_out)
    );


endmodule