module led_ctrl_unit (
    input wire rst,
    input wire clk,
    input wire en,
    input wire [63:0] display,
    output reg [7:0]  led_en,
    output reg [7:0]  led_cx
);

    reg update;

    reg [24:0] count;
    wire [24:0] count_max = 100000;

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

    reg [2:0] location;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            location <= 3'b0;
        end else if(update) begin
            location <= location + 1;
        end else begin
            location <= location;
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            led_en <= 8'b1111_1111;
        end else if (~en) begin
            led_en <= 8'b1111_1111;
        end else begin
            case (location)
                3'b000: led_en <= 8'b0111_1111;
                3'b001: led_en <= 8'b1011_1111;
                3'b010: led_en <= 8'b1101_1111;
                3'b011: led_en <= 8'b1110_1111;
                3'b100: led_en <= 8'b1111_0111;
                3'b101: led_en <= 8'b1111_1011;
                3'b110: led_en <= 8'b1111_1101;
                3'b111: led_en <= 8'b1111_1110;
                default: led_en <= 8'b1111_1111;
            endcase
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            led_cx <= 8'hff;
        end else begin
            case (location)
                3'b000: led_cx <= display[63:56];
                3'b001: led_cx <= display[55:48];
                3'b010: led_cx <= display[47:40];
                3'b011: led_cx <= display[39:32];
                3'b100: led_cx <= display[31:24];
                3'b101: led_cx <= display[23:16];
                3'b110: led_cx <= display[15:8];
                3'b111: led_cx <= display[7:0];
                default: led_cx <= 8'hff;
            endcase
        end
    end

endmodule