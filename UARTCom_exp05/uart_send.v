module uart_send(
    input        clk,        
    input        rst,        
    input        valid,       // 为1表明接下来的8位data有效，只维持一个时钟周期
    input [7:0]  data,        // 待发送的8位数据
    output reg   dout         // 发送信号
);

    reg [7:0] valid_data;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            valid_data <= 8'h00;
        end else if(valid) begin
            valid_data <= data;
        end else begin
            valid_data <= valid_data;
        end
    end

    localparam IDLE  = 2'b00;   // 空闲态，发送高电平
    localparam START = 2'b01;   // 起始态，发送起始位
    localparam DATA  = 2'b10;   // 数据态，将8位数据位发送出去
    localparam STOP  = 2'b11;   // 停止态，发送停止位

    reg [1:0] current_state;
    reg [1:0] next_state;

    reg [2:0] data_cnt;
    
    reg [14:0] baud_cnt;
    reg [14:0] baud_cnt_max = 10416;

    reg baud_cnt_inc;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            baud_cnt_inc <= 0;
        end else if(valid) begin
            baud_cnt_inc <= 1;
        end else if(current_state == STOP && baud_cnt >= baud_cnt_max) begin
            baud_cnt_inc <= 0;
        end else begin
            baud_cnt_inc <= baud_cnt_inc;
        end
    end

    // 第1个always块，描述次态迁移到现态
    always @(posedge clk or posedge rst) begin
        if(rst)  current_state <= IDLE;
        else current_state <= next_state;
    end

    // 第2个always块，描述状态转移条件判断
    always @(*) begin
        case (current_state)
            IDLE:   if(baud_cnt_inc) next_state = START;
                    else next_state = current_state;
            START:  if (baud_cnt >= baud_cnt_max) next_state = DATA;
                    else next_state = current_state;
            DATA:   if (baud_cnt >= baud_cnt_max && data_cnt == 3'b111) next_state = STOP;
                    else next_state = current_state;
            STOP:   if (baud_cnt >= baud_cnt_max) next_state = IDLE;
                    else next_state = current_state;
            default: next_state = current_state;
        endcase
    end

    // 第3个always块，描述输出逻辑，也可以用next_state作判断，对时序不敏感的电路两者都可以。
    always @(posedge clk or posedge rst) begin
        if(rst) dout <= 2'b00;
        else begin
            case(current_state)
                IDLE:   dout <= 1;
                START:  dout <= 0;
                DATA:
                    case (data_cnt)
                        3'b000: dout <= valid_data[0];
                        3'b001: dout <= valid_data[1];
                        3'b010: dout <= valid_data[2];
                        3'b011: dout <= valid_data[3];
                        3'b100: dout <= valid_data[4];
                        3'b101: dout <= valid_data[5];
                        3'b110: dout <= valid_data[6];
                        3'b111: dout <= valid_data[7];
                        default: dout <= 2'b00;
                    endcase
                STOP:   dout <= 1;
                default : dout <=2'b00;
            endcase
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
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

endmodule