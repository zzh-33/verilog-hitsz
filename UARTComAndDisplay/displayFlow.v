module displayFlow (
    input clk,
    input rst,
    input valid,
    input [7:0] data_in,
    output reg [7:0] display_reg,
    output reg [47:0] display_flow
);

    always @(*) begin
        case (data_in)
            8'h30: display_reg[7:0] = 8'b00000011;
            8'h31: display_reg[7:0] = 8'b10011111;
            8'h32: display_reg[7:0] = 8'b00100101;
            8'h33: display_reg[7:0] = 8'b00001101;
            8'h34: display_reg[7:0] = 8'b10011001;
            8'h35: display_reg[7:0] = 8'b01001001;
            8'h36: display_reg[7:0] = 8'b01000001;
            8'h37: display_reg[7:0] = 8'b00011111;
            8'h38: display_reg[7:0] = 8'b00000001;
            8'h39: display_reg[7:0] = 8'b00011001;
            8'h41: display_reg[7:0] = 8'b00010001;
            8'h42: display_reg[7:0] = 8'b11000001;
            8'h43: display_reg[7:0] = 8'b11100101;
            8'h44: display_reg[7:0] = 8'b10000101;
            8'h45: display_reg[7:0] = 8'b01100001;
            8'h46: display_reg[7:0] = 8'b01110001;
            default: display_reg[7:0] = 8'b11111111;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            display_flow[47:0] = 48'b1;
        end else if (display_reg[7:0] != 8'b11111111 && valid) begin
            display_flow[47:0] = {display_flow[39:0], display_reg[7:0]};
        end else begin 
            display_flow[47:0] = display_flow[47:0];
        end
    end

endmodule