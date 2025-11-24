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
    
    reg noMatch;
    reg isMatched;
    reg cnt_inc;
    reg [17:0] cnt;
    wire [17:0] cnt_max = 104260;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            currentState <= NULL;
        end else begin
            currentState <= nextState;
        end
    end

    always @(*) begin
        case (currentState)
            NULL:   if (valid) begin
                        if(data_in == 8'h73) nextState = S;
                        else if (data_in == 8'h68) nextState = H;
                        else nextState = NULL;
                    end else nextState = currentState;
                    
            S:      if (valid) begin
                        if(data_in == 8'h74) nextState = ST;
                        else if(data_in == 8'h73) nextState = S;
                        else if (data_in == 8'h68) nextState = H;
                        else  nextState = NULL;
                    end else if (cnt > cnt_max) nextState = NULL;
                        else nextState = currentState;
                        
            ST:     if (valid) begin
                        if(data_in == 8'h61) nextState = STA;
                        else if (data_in == 8'h6f) nextState = STO;
                        else if (data_in == 8'h73) nextState = S;
                        else if (data_in == 8'h68) nextState = H;
                        else nextState = NULL;
                    end else if (cnt > cnt_max) nextState = NULL;
                        else nextState = currentState;
                        
            STA:    if (valid) begin
                        if(data_in == 8'h72) nextState = STAR;
                        else if (data_in == 8'h73) nextState = S;
                        else if (data_in == 8'h68) nextState = H;
                        else nextState = NULL;
                    end else if (cnt > cnt_max) nextState = NULL;
                        else nextState = currentState;
                        
            STO:    if (valid) begin
                        if (data_in == 8'h70) nextState = STOP;
                        else if (data_in == 8'h73) nextState = S;
                        else if (data_in == 8'h68) nextState = H;
                        else nextState = NULL;
                    end else if (cnt > cnt_max) nextState = NULL;
                        else nextState = currentState;
                        
            STAR:   if (valid) begin
                        if (data_in == 8'h74) nextState = START;
                        else if (data_in == 8'h73) nextState = S;
                        else if (data_in == 8'h68) nextState = H;
                        else nextState = NULL;
                    end else if (cnt > cnt_max) nextState = NULL;
                        else nextState = currentState;
                        
            START:  if (valid) begin
                        if(data_in == 8'h73) nextState = S;
                        else if (data_in == 8'h68) nextState = H;
                        else  nextState = NULL;
                    end else nextState = currentState;
                    
            STOP:   if (valid) begin
                        if(data_in == 8'h73) nextState = S;
                        else if (data_in == 8'h68) nextState = H;
                        else  nextState = NULL;
                    end else nextState = currentState;
                    
            H:      if (valid) begin
                        if (data_in == 8'h69) nextState = HI;
                        else if (data_in == 8'h73) nextState = S;
                        else if (data_in == 8'h68) nextState = H;
                        else nextState = NULL;
                    end else if (cnt > cnt_max) nextState = NULL;
                        else nextState = currentState;
                        
            HI:     if (valid) begin
                        if (data_in == 8'h74) nextState = HIT;
                        else if (data_in == 8'h73) nextState = S;
                        else if (data_in == 8'h68) nextState = H;
                        else nextState = NULL;
                    end else if (cnt > cnt_max) nextState = NULL;
                        else nextState = currentState;
                        
            HIT:    if (valid) begin
                        if (data_in == 8'h73) nextState = HITS;
                        else if (data_in == 8'h73) nextState = S;
                        else if (data_in == 8'h68) nextState = H;
                        else nextState = NULL;
                    end else if (cnt > cnt_max) nextState = NULL;
                        else nextState = currentState;
                        
            HITS:   if (valid) begin
                        if (data_in == 8'h7a) nextState = HITSZ;
                        else if (data_in == 8'h74) nextState = ST;
                        else if (data_in == 8'h73) nextState = S;
                        else if (data_in == 8'h68) nextState = H;
                        else nextState = NULL;                       
                    end else if (cnt > cnt_max) nextState = NULL;
                        else nextState = currentState;
                        
            HITSZ: if (valid) begin
                        if (data_in == 8'h73) nextState = S;
                        else if (data_in == 8'h68) nextState = H;
                        else nextState = NULL;
                    end else nextState = currentState;
                    
            default: nextState = currentState;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt_inc <= 0;
        end else if (cnt > cnt_max && isMatched) begin
            cnt_inc <= 0;
        end else if (valid) begin 
            cnt_inc <= 1;
        end else begin
            cnt_inc <= cnt_inc;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt <= 0;
        end else if (cnt > cnt_max || valid) begin
            cnt <= 0;
        end else if (cnt_inc) begin
            cnt <= cnt + 1;
        end else begin
            cnt <= cnt;
        end
     end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            isMatched <= 0;
        end else if (cnt > cnt_max) begin
            isMatched <= 0;
        end else if (match) begin
            isMatched <= 1;
        end else begin
            isMatched <= isMatched;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            noMatch <= 0;
        end else if (cnt > cnt_max 
        && currentState == NULL 
        && isMatched == 0) begin
            noMatch <= 1;
        end else begin
            noMatch <= 0;
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            match <= 0;
        end else if (cnt == 1 && 
        (currentState == START || 
        currentState == STOP || 
        currentState == HITSZ)) begin
            match <= 1;
        end else if (noMatch) begin
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