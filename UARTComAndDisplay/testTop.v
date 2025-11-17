module testTop (
    input clk,
    input rst,
    input btn,
    input din,
    output dout
);

    wire [7:0] data_in;
    wire [7:0] data_out;

    wire valid_in;
    wire valid_out;

    wire send_flag;
    wire send_finish;

    wire match;
    wire [7:0] matchResult;

    btn_stable u_btn_stable(
        .clk(clk),
        .rst(rst),
        .btn(btn),
        .flag(send_flag)
    );

    ctrled_clk_counter #(
        .CNT_MAX(104260)
    ) u_ctrled_clk_counter(
        .clk(clk),
        .rst(rst),
        .ctrl_flag(send_flag),
        .ctrl_flag_2(send_finish),
        .update(valid_out)
    );

    data_select u_data_select(
        .clk(clk),
        .rst(rst),
        .valid(valid_out),
        .finish(send_finish),
        .data(data_out)
    );

    uart_recv u_uart_recv(
        .clk(clk),
        .rst(rst),
        .din(din),
        .valid(valid_in),
        .data(data_in)
    );

    strMatch u_strMatch(
        .clk(clk),
        .rst(rst),
        .valid(valid_in),
        .data_in(data_in),
        .match(match),
        .matchResult(matchResult)
    );

    uart_send u_uart_send(
        .clk(clk),
        .rst(rst),
        .valid(valid_out),
        .match(match),
        .matchResult(matchResult),
        .data(data_out),
        .dout(dout)
    );

endmodule