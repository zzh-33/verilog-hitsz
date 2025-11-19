module ctrled_clk_counter #(
    parameter CNT_MAX = 10000000
    parameter INIT = 1
)
(
    input clk,
    input rst,
    input start,
    input finish,
    output reg update
);

    reg [18:0] count;
    wire [18:0] count_max = CNT_MAX;
    reg cnt_inc;

    always @ (posedge clk or posedge rst) begin
        if(rst)begin
            cnt_inc <= INIT;
        end else if(finish | start)begin
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