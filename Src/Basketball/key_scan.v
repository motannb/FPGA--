module key_scan (
    input clk,
    output reg clk_100Hz
);
    integer clk_100Hz_cnt;
    always @(posedge clk)
        if(clk_100Hz_cnt==32'd25000000-1)
            begin
                clk_100Hz_cnt<=1'b0;
                clk_100Hz<=~clk_100Hz;
            end
        else
            clk_100Hz_cnt<=clk_100Hz_cnt+1'b1;
endmodule