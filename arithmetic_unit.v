module arithmetic_unit (
    input clk,
    input rst,
    input [7:0] x, y,
    input [1:0] op, // 00 = add, 01 = sub, 10 = mul, 11 = div
    input [7:0]c, // control signals
    //c0 = load A with result from adder
    //c1 = tell adder which operation to do 0=add 1=sub
    //c2 = lshift
    //c3 = rshift
    //c4 = 
    //c5 = 
    //c6 = 
    //c7 = 
    //c8 = 
    //c9 = 
    output reg [15:0] z
);

wire[8:0] add_temp_result;
wire add_op;
wire[7:0] add_in1, add_in2;

wire[7:0]a_in, q_in, m_in, a_out, q_out, m_out;
wire a_rst, q_rst, m_rst, a_load, q_load, m_load;
wire a_b7, q_b7, a_b0, q_b0, a_sel, q_sel;
wire[2:0] cnt_out;
wire cnt_done;

assign cnt_done = cnt_out[0] & cnt_out[1] & cnt_out[2];

/*
this part allows the circuit to skip using any sequential logic
in case the operation required is simple (add / sub) (when op[0] is 0)
by passing the inputs straight to the adder and the adder's output straight to the output
    ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓
*/
assign z = ({{7{add_temp_result[8]}}, add_temp_result} & {16{~op[0]}}) | ({a_out, q_out} & {16{cnt_done}});
assign add_in1 = (x & {8{~op[0]}}) | a_out;
assign add_in2 = (y & {8{~op[0]}}) | m_out;
assign add_op = ~op[0] & op[1] | c[1];


    adder add_inst(
        .x(add_in1),
        .y(add_in2),
        .op(add_op),
        .z(add_temp_result)
    );

    shift_reg a(
        .clk(clk),
        .rst(a_rst),
        .in(a_in),
        .b7(a_b7),
        .b0(a_b0), 
        .sel(a_sel),
        .load(a_load),
        .out(q_out)
    );
    shift_reg q(
        .clk(clk),
        .rst(q_rst),
        .in(q_in),
        .b7(q_b7),
        .b0(q_b0),
        .sel(q_sel),
        .load(q_load),
        .out(q_out)
    );
    shift_reg m(
        .clk(clk),
        .rst(m_rst),
        .in(m_in),
        .b7(1'b0),
        .b0(1'b0),
        .sel(2'b00),
        .load(m_load),
        .out(m_out)
    );

    cnt counter(
        .clk(clk),
        .rst(rst),
        .incr(cnt_incr),
        .out(cnt_out)
    );


endmodule