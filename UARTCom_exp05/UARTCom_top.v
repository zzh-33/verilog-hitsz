module UARTCom_top(
    input clk,
    input rst,
    output dout  
);

    wire valid;

    wire start_bit;
    wire finish_bit ;

    ctrled_clk_counter #(
        .CNT_MAX(204160),
        .INIT(1)
    ) u_ctrled_clk_counter_bit(
        .clk(clk),
        .rst(rst),
        .start(start_bit),
        .finish(finish_bit),
        .update(valid)
    );

    ctrled_clk_counter_str #(
        .CNT_MAX(20000000),
        .INIT(0)
    ) u_ctrled_clk_counter_str(
        .clk(clk),
        .rst(rst),
        .start(finish_bit),
        .finish(start_bit)
    );

    wire [7:0] data;

    data_select u_data_select(
        .clk(clk),
        .rst(rst),
        .valid(valid),
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