`timescale 1ns / 1ps

module testbench();
    reg clk;
    reg rst;
    reg button_2;
    reg button_3;
    reg en;
    
    wire [7:0] led_cx;
    wire [7:0] led_en;
    
    top u_top (
        .clk(clk),
        .rst(rst),
        .button_2(button_2),
        .button_3(button_3),
        .en(en),
        .led_cx(led_cx),
        .led_en(led_en)
    );

    always #5 clk = ~clk;
    
    // 初始化
    initial begin
        clk = 0;
        rst = 1;
        button_2 = 0;
        button_3 = 0;
        en = 0;
        
        #100
        rst = 0;
        en = 1;
        button_2 = 1;
        
        #300
        button_3 = 1;

        #100
        button_3 = 0;

        #200
        button_3 = 1;

        #100
        button_3 = 0;

        #200
        button_3 = 1;

        #100
        button_3 = 0;

        #200
        button_3 = 1;

        #10000000
        button_3 = 0;
        button_2 = 0;

        #10000000
        button_3 = 1;

        #100
        button_3 = 0;

        #200
        button_3 = 1;

        #100
        button_3 = 0;

        #200
        button_3 = 1;

        #100
        button_3 = 0;

        #200
        button_3 = 1;

        #10000000
        button_3 = 0;
 
        #30000
        $finish;
    end

endmodule