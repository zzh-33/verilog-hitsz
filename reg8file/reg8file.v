module reg8file (
    input  wire clk,  
    input  wire clr,    
    input  wire en,
    input  wire [7:0] d,
    input  wire [2:0] wsel,
    input  wire [2:0] rsel,
    output reg  [7:0] q    
);

    reg [7:0] reg_file [0:7];

    always @(posedge clk) begin
        if (clr) begin
            integer i;
            for (i = 0; i < 8; i = i + 1)
                reg_file[i] <= 8'b0;
        end else if (en) begin
            reg_file[wsel] <= d;
        end else begin
            reg_file[wsel] <= reg_file[wsel];
        end
    end

    always @(*) begin
        q = reg_file[rsel];
    end

endmodule