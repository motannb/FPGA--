module counter 
    #(parameter N=8,
      parameter times=24)   //timesģ�������ɵ�
(
    input clk_1Hz,en,Reset_24,Reset_Time,
    input [N-1:0] reg_S,
    output reg[N-1:0] reg_N,    //�ƷּĴ���
    output cout,buzzer,
    output stop
);
    always @(posedge clk_1Hz)   //1Hzʱ��
        if(Reset_24)            //ͬ����λ�ź�
            reg_N<=times;
        else if((reg_N>0)&en&reg_S!=0&Reset_Time!=1)
            reg_N<=reg_N-1;
    assign cout=(reg_N==0)? 1'b1:1'b0;  //��ʱ�����ź�
    assign stop=(en==1)? 1'b0:1'b1;     //ֹͣ�ź�
    assign buzzer=(reg_N==0)? 1'b1:1'b0;    //��ӷ�����

endmodule

