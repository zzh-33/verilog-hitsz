module btn_unstable (
    input clk,
    input rst,
    input btn,
    output wire flag_u
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

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            flag_u <= 0;
        end else if (signal_1 & ~signal_2) begin
            flag_u <= 1;
        end else begin
            flag_u <= 0;
        end
    end

endmodule