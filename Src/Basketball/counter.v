module counter 
    #(parameter N=8,
      parameter times=24)   //times模块例化可调
(
    input clk_1Hz,en,Reset_24,Reset_Time,
    input [N-1:0] reg_S,
    output reg[N-1:0] reg_N,    //计分寄存器
    output cout,buzzer,
    output stop
);
    always @(posedge clk_1Hz)   //1Hz时钟
        if(Reset_24)            //同步复位信号
            reg_N<=times;
        else if((reg_N>0)&en&reg_S!=0&Reset_Time!=1)
            reg_N<=reg_N-1;
    assign cout=(reg_N==0)? 1'b1:1'b0;  //计时结束信号
    assign stop=(en==1)? 1'b0:1'b1;     //停止信号
    assign buzzer=(reg_N==0)? 1'b1:1'b0;    //外接蜂鸣器

endmodule

