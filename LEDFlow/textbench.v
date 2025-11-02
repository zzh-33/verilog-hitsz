`timescale 1ns / 1ps

module testbench();
    reg clk;
    reg rst;
    reg button;
    reg [1:0] freq_set;
    reg dir_set;
    
    wire [7:0] led;
    
    LEDFlow #(
        .CNT_MAX(1),
        .WIDTH(0)
    ) u_LEDFlow (
        .clk(clk),
        .rst(rst),
        .button(button),
        .freq_set(freq_set),
        .dir_set(dir_set),
        .led(led)
    );

    always #5 clk = ~clk;
    
    // 初始化
    initial begin
        clk = 0;
        rst = 1;
        button = 0;
        freq_set = 2'b00;
        dir_set = 0;
        
        #100
        rst = 0;
        
        #300
        button = 1;

        #100
        button = 0;

        #10000
        freq_set = 2'b01;
        
        #50000
        dir_set = 1;
        
        #30000
        $finish;
    end

endmodule