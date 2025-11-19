module display_num_encoder(
    input [3:0] num_0,
    input [3:0] num_1,
    output [15:0] display
);

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