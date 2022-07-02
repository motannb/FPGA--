module Nixie_scan (
    input [3:0] data3,data2,data1,data0,
    input clk,
    output reg[3:0] smg_wei,
    output reg[7:0] smg_duan
);
    reg[3:0] hex3,hex2,hex1,hex0;
    reg[3:0] hex_in;
    localparam C=19;
    reg[C-1:0] reg_C;
    always @(posedge clk) //2**19次方分频扫描
    begin
            reg_C<=reg_C+1;
    end

    always @ * 
    begin
        hex0=data0;
        hex1=data1;
        hex2=data2;
        hex3=data3;
        hex_in=0;
        case(reg_C[C-1:C-2])
            2'b00:
                begin
                    smg_wei=4'b0001;
                    hex_in=hex0;
                end    
            2'b01:
                begin
                    smg_wei=4'b0010;
                    hex_in=hex1;
                end
            2'b10:
                begin
                    smg_wei=4'b0100;
                    hex_in=hex2;
                end
            2'b11:
                begin
                    smg_wei=4'b1000;
                    hex_in=hex3;
                end
        endcase
    end

    always @ *      //数码管译码
    begin
        case (hex_in)
            4'h0:smg_duan=8'b0011_1111;//0
            4'h1:smg_duan=8'b0000_0110;//1
            4'h2:smg_duan=8'b0101_1011;//2
            4'h3:smg_duan=8'b0100_1111;//3
            4'h4:smg_duan=8'b0110_0110;//4
            4'h5:smg_duan=8'b0110_1101;//5
            4'h6:smg_duan=8'b0111_1101;//6
            4'h7:smg_duan=8'b0000_0111;//7
            4'h8:smg_duan=8'b0111_1111;//8
            4'h9:smg_duan=8'b0110_1111;//9 
            4'ha:smg_duan=8'b0111_0111;//a 
            4'hb:smg_duan=8'b0111_1100;//b 
            4'hc:smg_duan=8'b0011_1001;//c 
            4'hd:smg_duan=8'b0101_1110;//d 
            4'he:smg_duan=8'b0111_1001;//e 
            4'hf:smg_duan=8'b0111_0001;//f
        endcase    
    end
endmodule