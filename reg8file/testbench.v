`timescale 1ns/1ps

module testbench ();

reg clk;
reg clr;
reg en;
reg [7:0] d;
reg [2:0] wsel;
reg [2:0] rsel;
wire [7:0]q;

initial begin
    clr = 1'b1;
    en = 1'b0;
    clk = 0;
    d = 8'b0;
    wsel = 3'b0;
    rsel = 3'b0;

    #10;
    clr = 1'b0;
    en = 1'b1;
    for (integer i = 0; i < 8; i = i + 1) begin
        wsel = i;
        d = 8'hFF - i;
        #10;
    end

    en = 1'b0;
    for (integer i = 0; i < 8; i = i + 1) begin
        rsel = i;
        #10;
    end

    clr = 1'b1;
    #10;
    clr = 1'b0;
    #10;

    for (integer i = 0; i < 8; i = i + 1) begin
        rsel = i;
        #10;
    end

    $finish;
end

always #5 clk = ~clk;  

reg8file u_reg8file (   
    .clk(clk),
    .clr(clr),
    .en(en),
    .d(d),
    .wsel(wsel),
    .rsel(rsel),
    .q(q)
);

endmodule