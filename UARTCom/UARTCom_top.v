module UARTCom_top(
    input clk,
    input rst,
    output dout  
);

    wire valid;

    wire start_bit;
    wire finish_bit ;

    ctrled_clk_counter #(
        .CNT_MAX(100000),
        .INIT(1)
    ) u_ctrled_clk_counter_bit(
        .clk(clk),
        .rst(rst),
        .start(start_bit),
        .finish(finish_bit),
        .update(valid)
    );

    ctrled_clk_counter_str #(
        .CNT_MAX(100000),
        .INIT(0)
    ) u_ctrled_clk_counter_str(
        .clk(clk),
        .rst(rst),
        .start(finish_bit),
        .finish(start_bit)
    );

    wire [7:0] data;
    wire [3:0] data_index;

    data_select u_data_select(
        .clk(clk),
        .rst(rst),
        .valid(valid),
        .data_index(data_index),
        .finish(finish_bit),
        .data(data)
    );

    uart_send u_uart_send(
        .clk(clk),
        .rst(rst),
        .valid(valid),
        .data(data),
        .dout(dout)
    );

endmodule