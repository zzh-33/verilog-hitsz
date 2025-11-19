module num_counter #(
    parameter MAX_0 = 9, 
    parameter MAX_1 = 9
)
(
    input clk,
    input rst,
    input flag,
    output reg [15:0] display
);

    reg [3:0] num_0;
    reg [3:0] num_1;

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

    always @(*) begin
        case (num_0)
            4'b0000: display[7:0] = 8'b00000011;
            4'b0001: display[7:0] = 8'b10011111;
            4'b0010: display[7:0] = 8'b00100101;
            4'b0011: display[7:0] = 8'b00001101;
            4'b0100: display[7:0] = 8'b10011001;
            4'b0101: display[7:0] = 8'b01001001;
            4'b0110: display[7:0] = 8'b01000001;
            4'b0111: display[7:0] = 8'b00011111;
            4'b1000: display[7:0] = 8'b00000001;
            4'b1001: display[7:0] = 8'b00011001;
            default: display[7:0] = 8'b11111111;
        endcase
    end

    always @(*) begin
        case (num_1)
            4'b0000: display[15:8] = 8'b00000011;
            4'b0001: display[15:8] = 8'b10011111;
            4'b0010: display[15:8] = 8'b00100101;
            4'b0011: display[15:8] = 8'b00001101;
            4'b0100: display[15:8] = 8'b10011001;
            4'b0101: display[15:8] = 8'b01001001;
            4'b0110: display[15:8] = 8'b01000001;
            4'b0111: display[15:8] = 8'b00011111;
            4'b1000: display[15:8] = 8'b00000001;
            4'b1001: display[15:8] = 8'b00011001;
            default: display[15:8] = 8'b11111111;
        endcase
    end

endmodule