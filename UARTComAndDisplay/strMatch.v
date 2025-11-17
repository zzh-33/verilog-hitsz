module strMatch (
    input clk,
    input rst,
    input valid,
    input [7:0] data_in,
    output reg match,
    output reg [7:0] matchResult
);

    localparam NULL = 4'b0000;
    localparam S = 4'b0001;
    localparam ST = 4'b0010;
    localparam STA = 4'b0011;
    localparam STAR = 4'b0100;
    localparam START = 4'b0101;
    localparam STO = 4'b0110;
    localparam STOP = 4'b0111;
    localparam H = 4'b1000;
    localparam HI = 4'b1001;
    localparam HIT = 4'b1010;
    localparam HITS = 4'b1011;
    localparam HITSZ = 4'b1100;

    reg [3:0] currentState;
    reg [3:0] nextState;

    reg [7:0] valid_data;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            valid_data <= 8'h00;
        end else if(valid) begin
            valid_data <= data_in;
        end else begin
            valid_data <= valid_data;
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            currentState <= NULL;
        end else begin
            currentState <= nextState;
        end
    end

    always @(*) begin
        case (currentState)
            NULL: if(valid_data == 8'h53) nextState = S;
                  else if (valid_data == 8'h48) nextState = H;
                  else  nextState = NULL;
            S: if(valid_data == 8'h54) nextState = ST;
               else  nextState = NULL;
            ST: if(valid_data == 8'h41) nextState = STA;
                else if (valid_data == 8'h4f) nextState = STO;
                else nextState = NULL;
            STA: if(valid_data == 8'h52) nextState = STAR;
                 else nextState = NULL;
            STO: if (valid_data == 8'h50) nextState = STOP;
                 else nextState = NULL;
            STAR: if (valid_data == 8'h54) nextState = START;
                  else nextState = NULL;
            START: if(valid_data == 8'h53) nextState = S;
                   else if (valid_data == 8'h48) nextState = H;
                   else  nextState = NULL;
            STOP: if(valid_data == 8'h53) nextState = S;
                  else if (valid_data == 8'h48) nextState = H;
                  else  nextState = NULL;
            H: if (valid_data == 8'h49) nextState = HI;
               else nextState = NULL;
            HI: if (valid_data == 8'h54) nextState = HIT;
                else nextState = NULL;
            HIT: if (valid_data == 8'h53) nextState = HITS;
                 else nextState = NULL;
            HITS: if (valid_data == 8'h5a) nextState = HITSZ;
                  else nextState = NULL;
            HITSZ: if (valid_data == 8'h53) nextState = S;
                   else if (valid_data == 8'h48) nextState = H;
                   else nextState = NULL;
            default: nextState = NULL;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            match <= 0;
        end else if ((currentState == HITSZ || currentState == START || currentState == STOP || currentState == NULL) && valid) begin
            match <= 1;
        end else begin
            match <= 0;
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            matchResult <= 8'h30;
        end else begin
            case (currentState)
                START: matchResult <= 8'h31;
                STOP: matchResult <= 8'h32;
                HITSZ: matchResult <= 8'h33;
                default: matchResult <= 8'h30;
            endcase
        end
    end

endmodule