module ctrled_clk_counter #(parameter CNT_MAX = 10000000)
(
    input clk,
    input rst,
    input ctrl_flag,
    output reg update
);

    reg [24:0] count;
    wire [24:0] count_max = CNT_MAX;
    reg cnt_inc = 0;

    always @ (posedge clk or posedge rst) begin
        if(rst)begin
            cnt_inc <= 1'b0;
        end else if(ctrl_flag)begin
            cnt_inc <= ~cnt_inc;
        end else begin
            cnt_inc <= cnt_inc;
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            count <= 0;
        end else if (cnt_inc) begin
            if(count >= count_max) begin
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end else begin
            count <= count;
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            update <= 0;
        end else if(count >= count_max) begin
            update <= 1;
        end else begin
            update <= 0;
        end
    end

endmodule