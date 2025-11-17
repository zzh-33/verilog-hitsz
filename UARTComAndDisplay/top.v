module top (
    input clk,
    input rst,
    input btn,
    input din,
    output dout,
    output [7:0] led_cx,
    output [7:0] led_en
);

    wire [7:0] data_in;
    wire [7:0] data_out;

    wire valid_in;
    wire valid_out;

    wire send_flag;
    wire send_finish;

    wire [15:0] display_cnt;
    wire [47:0] display_flow;

    wire [63:0] display = {display_cnt, display_flow};

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

    displayFlow u_displayFlow(
        .clk(clk),
        .rst(rst),
        .valid(valid_in),
        .data_in(data_in),
        .display_flow(display_flow)
    );

    num_counter #(
        .MAX_0(9),
        .MAX_1(9)
    ) u_num_counter(
        .clk(clk),
        .rst(rst),
        .flag(valid_in),
        .display(display_cnt)
    );

    led_ctrl_unit u_led_ctrl_unit(
        .clk(clk),
        .rst(rst),
        .display(display),
        .led_cx(led_cx),
        .led_en(led_en)
    );

endmodule