module btn_stable(
    input clk,
    input rst,
    input btn,
    output reg flag
);
    reg signal_0;
    reg signal_1;
    reg signal_2;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            signal_0 <= 0;
        end else begin
            signal_0 <= btn;
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            signal_1 <= 0;
        end else begin
            signal_1 <= signal_0;
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            signal_2 <= 0;
        end else begin
            signal_2 <= signal_1;
        end
    end

    reg start = 0;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            start <= 0;
        end else if (count >= count_max) begin
            start <= 0;
        end else if (signal_1 & ~signal_2 & ~start) begin
            start <= 1;
        end else begin
            start <= start;
        end
    end

    reg [21:0] count;
    wire [21:0] count_max = 1000000;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            count <= 0;
        end else if(count >= count_max) begin
            count <= 0;
        end else if (start) begin
            count <= count + 1;
        end else begin
            count <= count;
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            flag <= 0;
        end else if(count >= count_max & btn) begin
            flag <= 1;
        end else begin
            flag <= 0;
        end
    end

endmodule