/*100MHz??1Hz*/
module div (
    input clk,
    output reg clk_1Hz
);
    integer clk_1Hz_cnt;
    always @(posedge clk)
        if(clk_1Hz_cnt==32'd50000000-1)
            begin
                clk_1Hz_cnt<=1'b0;
                clk_1Hz<=~clk_1Hz;
            end
        else
            clk_1Hz_cnt<=clk_1Hz_cnt+1'b1;
endmodule