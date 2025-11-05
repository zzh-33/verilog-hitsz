module uart_send(
    input        clk,        
    input        rst,        
    input        valid,       // 为1表明接下来的8位data有效，只维持一个时钟周期
    input [7:0]  data,        // 待发送的8位数据
    output reg   dout         // 发送信号
);

    localparam IDLE  = 2'b00;   // 空闲态，发送高电平
    localparam START = 2'b01;   // 起始态，发送起始位
    localparam DATA  = 2'b10;   // 数据态，将8位数据位发送出去
    localparam STOP  = 2'b11;   // 停止态，发送停止位

    reg [1:0] current_state;
    reg [1:0] next_state;

    reg [2:0] data_cnt;

    // 第1个always块，描述次态迁移到现态
    always @(posedge clk or posedge rst) begin
        if(rst)  current_state <= IDLE;
        else     current_state <= next_state;
    end

    // 第2个always块，描述状态转移条件判断
    always @(*) begin
        case (current_state)
            IDLE: if(valid) next_state = START;
                  else      next_state = IDLE;
            START: next_state = DATA;
            DATA:  if (data_cnt == 3'b111) next_state = STOP;
            STOP:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // 第3个always块，描述输出逻辑，也可以用next_state作判断，对时序不敏感的电路两者都可以。
    always @(posedge clk or posedge rst) begin
        if(rst) out <= 2'b00;
        else begin
            case(current_state)
                IDLE:   dout <= 1;
                START:  dout <= 0;
                DATA:
                    case (data_cnt)
                        3'b000: dout <= data[0];
                        3'b001: dout <= data[1];
                        3'b010: dout <= data[2];
                        3'b011: dout <= data[3];
                        3'b100: dout <= data[4];
                        3'b101: dout <= data[5];
                        3'b110: dout <= data[6];
                        3'b111: dout <= data[7];
                        default: dout <= 2'b00;
                    endcase
                STOP:   dout <= 1;
                default : dout <=2'b00;
            endcase
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            data_cnt <= 0;
        end else if(current_state == DATA) begin
            data_cnt <= data_cnt + 1;
        end else begin
            data_cnt <= data_cnt;
        end
    end

endmodule