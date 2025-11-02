module LEDFlow #(
    parameter CNT_MAX = 1000,
    parameter WIDTH = 9
)
(
    input wire clk,
    input wire rst,
    input wire button,
    input wire [1:0] freq_set,
    input wire dir_set,
    output reg [7:0] led
);

    reg [15 + WIDTH:0] counter;
    reg [15 + WIDTH:0] max_count;
    reg button_0 = 0;
    reg button_1 = 0;
    reg button_2 = 0;

    always @(posedge clk or posedge rst) begin
        if (rst)
            max_count <= 100 * CNT_MAX;
        else begin
            case (freq_set)
                2'b00: max_count <= 100*CNT_MAX;
                2'b01: max_count <= 1000*CNT_MAX;
                2'b10: max_count <= 5000*CNT_MAX;
                2'b11: max_count <= 20000*CNT_MAX;
                default: max_count <= 100*CNT_MAX;
            endcase
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            button_0 <= 1'b0;
        end else begin
            button_0 <= button;
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            button_1 <= 1'b0;
        end else begin
            button_1 <= button_0;
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            button_2 <= 1'b0;
        end else begin
            button_2 <= button_1;
        end
    end

    reg cnt_inc = 0;

    always @ (posedge clk or posedge rst) begin
        if(rst)begin
            cnt_inc <= 1'b0;
        end else if(button_1 & ~button_2)begin
            cnt_inc <= ~cnt_inc;
        end else begin
            cnt_inc <= cnt_inc;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if(rst) begin
            counter <= 0;
        end else if (cnt_inc) begin
            if (counter >= max_count) begin
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end else begin
            counter <= counter;
        end
    end

    always @ (posedge clk or posedge rst ) begin
        if(rst) begin
            led <= 8'b0000_0001;
        end else if(counter >= max_count) begin
            if (dir_set) begin
                led <= {led[6:0], led[7]};
            end else begin
                led <= {led[0], led[7:1]};
            end
        end else begin
            led <= led;
        end
    end
endmodule