module lcd1602 (
    input sys_clk,
    input sys_rst,
    input en,
    input [7:0] reg_N,
    input [3:0] hex_out7, hex_out6, hex_out5, hex_out4, hex_out3, hex_out2, hex_out1, hex_out0,
    output bla,
    output blk,
    output reg lcd_rs,
    output lcd_rw,
    output reg lcd_en,
    output reg[7:0] lcd_data,
    output GND
);
    parameter MODE_SET =8'h31,  //3.3V供电只能显示一行
              CUROSR_SET=8'h0c,
              ADDRESS_SET=8'h06,
              CLEAR_SET=8'h01;
    
    /*1Hz时钟信号分频*/
    wire clk_1hz;
    clk_self_clr #(50_000_000) u1(
        .clk(sys_clk),
        .clr(sys_rst),
        .clk_self(clk_1hz)
    );

    /*12分钟计时*/
    reg[7:0] sec;
    reg[7:0] min;
    always @(posedge clk_1hz,negedge sys_rst) 
    begin
        if(!sys_rst)    begin sec<=0; min<=8'h12; end    
        else begin 
            if(min==0&&sec==0)
            begin
                min<=8'h12;
                sec<=0;
            end
        else if(min[3:0]!=0&&sec==0&&en)
            begin
                min[3:0]<=min[3:0]-1;sec<=8'h59;
            end
        else if(min[3:0]==0&&sec==0&&en)
            begin
                min[7:4]<=min[7:4]-1; min[3:0]<=9; 
            end
        else if(sec[3:0]==0&&en)
            begin
                sec[7:4]<=sec[7:4]-1; sec[3:0]<=9;
            end
        else if(en&&reg_N!=0) sec[3:0]<=sec[3:0]-1;
        end
    end

    /*lcd1602使能*/
    reg[31:0] cnt;
    reg lcd_sys_clk_en;
    always @(posedge sys_clk ,negedge sys_rst) 
    begin
        if(!sys_rst)
        begin
            cnt<=1'b0;
            lcd_sys_clk_en<=1'b0;
        end    
        else if(cnt==32'h24999)
        begin
            cnt<=1'b0;
            lcd_sys_clk_en<=1'b1;
        end
        else
        begin
            cnt<=cnt+1'b1; lcd_sys_clk_en<=1'b0;
        end
    end

    /*lcd1602显示模块*/
    wire[7:0] sec0,sec1,min0,min1,hex7,hex6,hex5,hex4,hex3,hex2,hex1,hex0;
    wire[7:0] addr;
    reg[5:0] state;
    assign min0=8'h30+min[3:0];
    assign min1=8'h30+min[7:4];
    assign sec0=8'h30+sec[3:0];
    assign sec1=8'h30+sec[7:4];
    assign hex7=8'h30+hex_out7;
    assign hex6=8'h30+hex_out6;
    assign hex5=8'h30+hex_out5;
    assign hex4=8'h30+hex_out4;
    assign hex3=8'h30+hex_out3;
    assign hex2=8'h30+hex_out2;
    assign hex1=8'h30+hex_out1;
    assign hex0=8'h30+hex_out0;
    assign addr=8'h80;

    always @(posedge sys_clk,negedge sys_rst) 
    begin
        if(!sys_rst)
        begin
            state<=1'b0;    lcd_rs<=1'b0;
            lcd_en<=1'b0;   lcd_data<=1'b0;
        end    
        else if(lcd_sys_clk_en)
        begin
            case (state)
                6'd0:begin
                    lcd_rs<=1'b0;
                    lcd_en<=1'b1;
                    lcd_data<=MODE_SET;
                    state<=state+1'd1;
                end 

                6'd1:begin
                    lcd_en<=1'b0;   state<=state+1'd1;
                end

                6'd2:begin
                    lcd_rs<=1'b0;
                    lcd_en<=1'b1;
                    lcd_data<=CUROSR_SET;
                    state<=state+1'd1;
                end

                6'd3:begin
                    lcd_en<=1'b0;   state<=state+1'd1;
                end

                6'd4:begin
                    lcd_rs<=1'b0;
                    lcd_en<=1'b1;
                    lcd_data<=ADDRESS_SET;
                    state<=state+1'd1;
                end

                6'd5:begin
                    lcd_en<=1'b0;   state<=state+1'd1;
                end

                6'd6:begin
                    lcd_rs<=1'b0;
                    lcd_en<=1'b1;
                    lcd_data<=CLEAR_SET;
                    state<=state+1'd1;
                end

                6'd7:begin
                    lcd_en<=1'b0;   state<=state+1'd1;
                end

                6'd8:begin
                    lcd_rs<=1'b0;
                    lcd_en<=1'b1;
                    lcd_data<=addr;
                    state<=state+1'd1;
                end

                6'd9:begin
                    lcd_en<=1'b0;   state<=state+1'd1;
                end

                6'd10:begin
                    lcd_rs<=1'b1;
                    lcd_en<=1'b1;
                    lcd_data<=min1;
                    state<=state+1'd1;
                end

                6'd11:begin
                    lcd_en<=1'b0;   state<=state+1'd1;
                end

                6'd12:begin
                    lcd_rs<=1'b1;
                    lcd_en<=1'b1;
                    lcd_data<=min0;
                    state<=state+1'd1;
                end

                6'd13:begin
                    lcd_en<=1'b0;   state<=state+1'd1;
                end

                6'd14:begin
                    lcd_rs<=1'b1;
                    lcd_en<=1'b1;
                    lcd_data<="m";
                    state<=state+1'd1;
                end

                6'd15:begin
                    lcd_en<=1'b0;   state<=state+1'd1;
                end

                6'd16:begin
                    lcd_rs<=1'b1;
                    lcd_en<=1'b1;
                    lcd_data<=sec1;
                    state<=state+1'd1;
                end

                6'd17:begin
                    lcd_en<=1'b0;   state<=state+1'd1;
                end

                6'd18:begin
                    lcd_rs<=1'b1;
                    lcd_en<=1'b1;
                    lcd_data<=sec0;
                    state<=state+1'd1;
                end

                6'd19:begin
                    lcd_en<=1'b0;   state<=state+1'd1;
                end

                6'd20:begin
                    lcd_rs<=1'b1;
                    lcd_en<=1'b1;
                    lcd_data<="s";
                    state<=state+1'd1;
                end

                6'd21:begin
                    lcd_en<=1'b0;   state<=state+1'd1;
                end

                6'd22:begin
                    lcd_rs<=1'b1;
                    lcd_en<=1'b1;
                    lcd_data<=" ";
                    state<=state+1'd1;
                end

                6'd23:begin
                    lcd_en<=1'b0;   state<=state+1'd1;
                end

                6'd24:begin
                    lcd_rs<=1'b1;
                    lcd_en<=1'b1;
                    lcd_data<=hex7;
                    state<=state+1'd1;
                end

                6'd25:begin
                    lcd_en<=1'b0;   state<=state+1'd1;
                end

                6'd26:begin
                    lcd_rs<=1'b1;
                    lcd_en<=1'b1;
                    lcd_data<=hex6;
                    state<=state+1'd1;
                end

                6'd27:begin
                    lcd_en<=1'b0;   state<=state+1'd1;
                end

                6'd28:begin
                    lcd_rs<=1'b1;
                    lcd_en<=1'b1;
                    lcd_data<=" ";
                    state<=state+1'd1;
                end

                6'd29:begin
                    lcd_en<=1'b0;   state<=state+1'd1;
                end

                6'd30:begin
                    lcd_rs<=1'b1;
                    lcd_en<=1'b1;
                    lcd_data<=hex3;
                    state<=state+1'd1;
                end

                6'd31:begin
                    lcd_en<=1'b0;   state<=state+1'd1;
                end

                6'd32:begin
                    lcd_rs<=1'b1;
                    lcd_en<=1'b1;
                    lcd_data<=hex2;
                    state<=state+1'd1;
                end

                6'd33:begin
                    lcd_en<=1'b0;   state<=state+1'd1;
                end

                6'd34:begin
                    lcd_rs<=1'b1;
                    lcd_en<=1'b1;
                    lcd_data<=" ";
                    state<=state+1'd1;
                end

                6'd35:begin
                    lcd_en<=1'b0;   state<=state+1'd1;
                end

                6'd36:begin
                    lcd_rs<=1'b1;
                    lcd_en<=1'b1;
                    lcd_data<=hex1;
                    state<=state+1'd1;
                end

                6'd37:begin
                    lcd_en<=1'b0;   state<=state+1'd1;
                end

                6'd38:begin
                    lcd_rs<=1'b1;
                    lcd_en<=1'b1;
                    lcd_data<=hex0;
                    state<=state+1'd1;
                end
                
                6'd39:begin
                    lcd_en<=1'b0;   state<=state+1'd1;
                end


                6'd40:begin
                    lcd_en<=1'b0; state<=6'd8;  /*循环刷新*/
                end

                default: state<=6'bxxxxxx;

            endcase
        end
    end
    assign lcd_rw=1'b0;
    assign blk=1'b0;
    assign bla=1'b1;
    assign GND=1'b0;
endmodule