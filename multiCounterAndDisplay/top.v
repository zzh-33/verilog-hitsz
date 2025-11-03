module top(
    input clk,
    input rst,
    input button_2,
    input button_3,
    input en,
    output [7:0] led_cx,
    output [7:0] led_en
);

    wire [15:0] display_0 = 8'b01001001_00011001;

    wire flag_u;

    btn_unstable u_btn_u (
        .clk(clk),
        .rst(rst),
        .btn(button_3),
        .flag_u(flag_u)
    );

    wire [3:0] display_1_num_0;
    wire [3:0] display_1_num_1;

    num_counter #(
        .MAX_0(9),
        .MAX_1(9)
    ) u_num_counter_1 (
        .clk(clk),
        .rst(rst),
        .flag(flag_u),
        .num_0(display_1_num_0),
        .num_1(display_1_num_1)
    );

    wire [15:0] display_1;

    display_num_encoder u_display_num_encoder_1 (
        .num_0(display_1_num_0),
        .num_1(display_1_num_1),
        .display(display_1)
    );

    wire flag;

    btn_stable u_btn_s (
        .clk(clk),
        .rst(rst),
        .btn(button_3),
        .flag(flag)
    );

    wire [3:0] display_2_num_0;
    wire [3:0] display_2_num_1;

    num_counter #(
        .MAX_0(9),
        .MAX_1(9)
    ) u_num_counter_2 (
        .clk(clk),
        .rst(rst),
        .flag(flag),
        .num_0(display_2_num_0),
        .num_1(display_2_num_1)
    );

    wire [15:0] display_2;

    display_num_encoder u_display_num_encoder_2 (
        .num_0(display_2_num_0),
        .num_1(display_2_num_1),
        .display(display_2)
    );


    wire ctrl_flag;

    btn_stable u_btn_s_ctrl (
        .clk(clk),
        .rst(rst),
        .btn(button_2),
        .flag(ctrl_flag)
    );

    wire flag_clk;

    ctrled_clk_counter #(
        .CNT_MAX(10000000)
    ) u_clk_counter_num (
        .clk(clk),
        .rst(rst),
        .ctrl_flag(ctrl_flag),
        .update(flag_clk)
    );

    wire [3:0] display_3_num_0;
    wire [3:0] display_3_num_1;

    num_counter #(
        .MAX_0(9),
        .MAX_1(2)
    ) u_num_counter_3 (
        .clk(clk),
        .rst(rst),
        .flag(flag_clk),
        .num_0(display_3_num_0),
        .num_1(display_3_num_1)
    );

    wire [15:0] display_3;

    display_num_encoder u_display_num_encoder_3 (
        .num_0(display_3_num_0),
        .num_1(display_3_num_1),
        .display(display_3)
    );

    wire [63:0] display = {display_0, display_1, display_2, display_3};

    led_ctrl_unit u_led_ctrl_unit (
        .rst(rst),
        .clk(clk),
        .en(en),
        .display(display),
        .led_en(led_en),
        .led_cx(led_cx)
    );

endmodule
