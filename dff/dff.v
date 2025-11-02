module dff (
    input      clk,
    input      clr,
    input      en ,
    input      d  ,
    output reg q
);

always @(posedge clk or posedge clr) begin
    if (clr) begin
        q <= 1'b0;
    end else if (en) begin
        q <= d;
    end else begin
        q <= q;
    end
end

endmodule