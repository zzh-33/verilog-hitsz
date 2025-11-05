module data_select(
    input clk,
    input rst,
    input valid,
    input [3:0] data_index,
    output reg finish,
    output reg [7:0] data
);

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            data_index <= 0;
        end else if(data_index >= 4'b1110) begin
            data_index <= 0;
        end else if (valid) begin
            data_index <= data_index + 1;
        end else begin
            data_index <= data_index;
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            finish <= 0;
        end else if(data_index >= 4'b1110) begin
            finish <= 1;
        end else begin
            finish <= 0;
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            data <= 0;
        end else begin
            case (data_index)
                4'b0000: data <= 8'h68;
                4'b0001: data <= 8'h69;
                4'b0010: data <= 8'h74;
                4'b0011: data <= 8'h73;
                4'b0100: data <= 8'h7A;
                4'b0101: data <= 8'h32;
                4'b0110: data <= 8'h30;
                4'b0111: data <= 8'h32;
                4'b1000: data <= 8'h34;
                4'b1001: data <= 8'h33;
                4'b1010: data <= 8'h31;
                4'b1011: data <= 8'h31;
                4'b1100: data <= 8'h32;
                4'b1101: data <= 8'h35;
                4'b1110: data <= 8'h39;
                default: data <= 8'h00;   
            endcase
        end
    end

endmodule