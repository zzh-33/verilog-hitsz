module num_counter #(
    parameter MAX_0 = 9, 
    parameter MAX_1 = 9
)
(
    input clk,
    input rst,
    input flag,
    output reg [3:0] num_0,
    output reg [3:0] num_1
);

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            num_0 <= 0;
        end else if (num_0 >= MAX_0 && flag) begin
            num_0 <= 0;
        end else if (flag) begin
            num_0 <= num_0 + 1;
        end else begin
            num_0 <= num_0;
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            num_1 <= 0;
        end else if (num_1 >=MAX_1 && num_0 >= MAX_0 && flag) begin
            num_1 <= 0;
        end else if (num_0 >= MAX_0 && flag) begin
            num_1 <= num_1 + 1;
        end else begin
            num_1 <= num_1;
        end
    end

endmodule