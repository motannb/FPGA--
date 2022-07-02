module clk_self_clr (
    input clk,
    input clr,
    output reg clk_self
);
    parameter NUM =10000;
    reg[29:0] count;
    always @(posedge clk ,negedge clr) 
    begin
        if(~clr)
        begin
            clk_self<=0;
            count<=0;
        end    
        else if(count==NUM-1)
        begin
            clk_self<=~clk_self;
            count<=0;
        end
        else count<=count+1;
    end
endmodule
