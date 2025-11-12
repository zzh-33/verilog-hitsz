module uart_recv(
    input                   clk,   
    input                   rst,   
    input                   din,   // 串口数据输入

    output reg              valid, // 为1表明输出的数据data有效，只维持一个时钟周期
    output reg [7:0]        data   
);

    localparam    IDLE  = 3'b000;
    localparam    START = 3'b001;
    localparam    DATA  = 3'b010;
    localparam    STOP  = 3'b011;

    reg [2:0] current_state;
    reg [2:0] next_state;

    reg [14:0] baud_cnt;
    reg [14:0] baud_cnt_max = 10416;
    reg [14:0] baud_cnt_max_half = 5208;

    reg baud_cnt_inc;

    reg [2:0] data_cnt;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            baud_cnt_inc <= 0;
        end else if (current_state == IDLE && !din) begin
            baud_cnt_inc <= 1;
        end else if (current_state == STOP && baud_cnt >= baud_cnt_max) begin
            baud_cnt_inc <= 0;
        end else begin
            baud_cnt_inc <= baud_cnt_inc;
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            current_state <= IDLE;
        end else if (current_state == IDLE) begin
            current_state <= next_state;
        end else if (current_state == START && baud_cnt >= baud_cnt_max_half) begin
            current_state <= next_state;
        end else if (baud_cnt >= baud_cnt_max) begin
            current_state <= next_state;
        end else begin
            current_state <= current_state;
        end
    end

    always @(*) begin
        case (current_state)
            IDLE: if(baud_cnt_inc) next_state = START;
                  else      next_state = IDLE;
            START: next_state = DATA;
            DATA:  if (data_cnt == 3'b111) next_state = STOP;
                   else next_state = DATA;
            STOP:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            baud_cnt <= 0;
        end else if (current_state == START && baud_cnt >= baud_cnt_max_half) begin
            baud_cnt <= 0;
        end else if(baud_cnt >= baud_cnt_max) begin
            baud_cnt <= 0;
        end else if (baud_cnt_inc && current_state != IDLE) begin
            baud_cnt <= baud_cnt + 1;
        end else begin
            baud_cnt <= baud_cnt;
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            data_cnt <= 0;
        end else if (current_state == STOP) begin
            data_cnt <= 0;
        end else if(current_state == DATA && baud_cnt >= baud_cnt_max) begin
            data_cnt <= data_cnt + 1;
        end else begin
            data_cnt <= data_cnt;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data <= 8'hff;
        end else if (current_state == DATA && baud_cnt >= baud_cnt_max) begin
            case (data_cnt)
                3'b000: data[0] <= din;
                3'b001: data[1] <= din;
                3'b010: data[2] <= din;
                3'b011: data[3] <= din;
                3'b100: data[4] <= din;
                3'b101: data[5] <= din;
                3'b110: data[6] <= din;
                3'b111: data[7] <= din;
                default: data <= 8'hff;
            endcase
        end else begin
            data <= data;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            valid <= 0;
        end else if (current_state == STOP && baud_cnt >= baud_cnt_max) begin
            valid <= 1;
        end else begin
            valid <= 0;
        end
    end

endmodule