module clk_counter #(parameter CNT_MAX = 100000)
(
    input clk,
    input rst,
    output reg update
);

    reg [24:0] count;
    wire [24:0] count_max = CNT_MAX;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            count <= 0;
        end else if(count >= count_max) begin
            count <= 0;
        end else begin
            count <= count + 1;
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