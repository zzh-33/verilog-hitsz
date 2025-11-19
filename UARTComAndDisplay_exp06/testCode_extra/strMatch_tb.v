`timescale 1ns/1ns

module strMatch_tb;

    reg clk;
    reg rst;
    reg btn;
    reg uart_rx;        // 驱动 uart_recv 的输入
    wire uart_tx;       // uart_send 输出

    // ===== 时钟：100MHz =====
    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // 10ns period = 100MHz
    end

    // ===== DUT =====
    testTop u_testTop(
        .clk(clk),
        .rst(rst),
        .btn(btn),
        .din(uart_rx),
        .dout(uart_tx)
    );

    // ============== 仿真串口发送任务 ==============
    task uart_send_byte;
        input [7:0] byte;

        integer i;
        begin
            // 起始位
            uart_rx = 0;
            #(104160);   // 9600 baud → 104166 ns

            // 数据位 8bit，LSB first
            for (i = 0; i < 8; i = i + 1) begin
                uart_rx = byte[i];
                #(104160);
            end

            // 停止位
            uart_rx = 1;
            #(104160);
        end
    endtask

    // ===== 发送字符串任务 =====
    task uart_send_string;
        input [8*32-1:0] str;   // 最长 32 字符
        integer idx;
        begin
            idx = 0;
            while (str[8*idx +: 8] != 0) begin
                uart_send_byte(str[8*idx +: 8]);
                idx = idx + 1;
            end
        end
    endtask

    // ============== 主测试流程 ==============
    initial begin
        rst = 1;
        uart_rx = 1;  // 空闲状态
        #200;
        rst = 0;

        // 1. 测试 "start"
        #100000;
        $display("\n=== SEND \"start\" ===");
        uart_send_string("trats");

        #2_000_000;

        // 2. 测试 "stop"
        $display("\n=== SEND \"stop\" ===");
        uart_send_string("pots");

        #2_000_000;

        // 3. 测试 "hitsz"
        $display("\n=== SEND \"hitsz\" ===");
        uart_send_string("zstih");

        #2_000_000;

        // 4. 测试错误字符串
        $display("\n=== SEND \"abc\" ===");
        uart_send_string("abc");

        #2_000_000;

        $display("\nSimulation Finished.");
        $finish;
    end

endmodule
