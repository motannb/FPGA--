/*
 *数字小系统大作业
 *author：詹舒伟 杨奕 莫昙
 *顶层TOP模块
 *
 */
module basketball_top (
    input clk,Reset_24,Reset_Time,Reset_Score,reset,sys_rst,
    input three_point,two_point,one_point,key_show,
    input team,en,key_score,
    output wire txd,
    output wire[3:0] smg_wei1,
    output wire[7:0] smg_duan1,
    output wire[3:0] smg_wei2,
    output wire[7:0] smg_duan2,
    output wire cout,stop,Game_End,buzzer,
    output wire[7:0] LED,
    output wire bla,
    output wire blk,
    output wire lcd_rs,
    output wire lcd_rw,
    output wire lcd_en,
    output wire [7:0] lcd_data,
    output wire GND
);

wire [3:0]receive;
wire clk_1Hz;     //1Hz时钟信号
wire clk_100Hz;   //100Hz时钟信号
wire clk_9600;
wire key4;
wire key3;
wire key2;
wire key1;
wire [7:0] team1_score;
wire [7:0] team2_score;
wire [7:0] reg_N;   //计时24S
wire [7:0] reg_S;    //计时60S
wire [3:0] hex_out7; //数码管显示数据
wire [3:0] hex_out6;
wire [3:0] hex_out5;
wire [3:0] hex_out4;
wire [3:0] hex_out3;
wire [3:0] hex_out2;
wire [3:0] hex_out1;
wire [3:0] hex_out0;

parameter twenty_four=24;
parameter sixty=60;

div my_div(         //分频1Hz模块
    .clk(clk),
    .clk_1Hz(clk_1Hz)
);

counter #(          //计时24S模块
    .times(twenty_four))
count_24(
    .clk_1Hz(clk_1Hz),
    .en(en),
    .Reset_24(Reset_24),
    .Reset_Time(Reset_Time),
    .reg_N(reg_N),
    .reg_S(reg_S),
    .cout(cout),
    .stop(stop),
    .buzzer(buzzer)
);

counter #(          //计时60S模块
    .times(sixty))
count_60(
    .clk_1Hz(clk_1Hz),
    .en(en),
    .Reset_24(Reset_Time),
    .Reset_Time(Reset_24),
    .reg_N(reg_S),
    .reg_S(reg_N),
    .cout(Game_End),
    .stop(),
    .buzzer()
);

bin_to_bcd my_bcd1(
    .bcd(reg_N),
    .ones(hex_out6),
    .tens(hex_out7)
);

bin_to_bcd my_bcd2(
    .bcd(reg_S),
    .ones(hex_out4),
    .tens(hex_out5)
);

bin_to_bcd my_bcd3(
    .bcd(team1_score),
    .ones(hex_out0),
    .tens(hex_out1)
);

bin_to_bcd my_bcd4(
    .bcd(team2_score),
    .ones(hex_out2),
    .tens(hex_out3)
);


score my_score(
    .clk(clk_100Hz),
    .Reset_Score(Reset_Score),
    .three_point(key3),
    .two_point(key2),
    .one_point(key1),
    .team(team),
    .score1(team1_score),
    .score2(team2_score),
    .key_score(key_score)
);

key my_key1(
    .clk(clk),
    .reset(reset),
    .sw(one_point),
    .key_mark(key1)
);

key my_key2(
    .clk(clk),
    .reset(reset),
    .sw(two_point),
    .key_mark(key2)
);

key my_key3(
    .clk(clk),
    .reset(reset),
    .sw(three_point),
    .key_mark(key3)
);

key my_key4(
    .clk(clk),
    .reset(reset),
    .sw(key_show),
    .key_mark(key4)
);

Nixie_scan my_scan2(
    .data0(hex_out4),
    .data1(hex_out5),
    .data2(hex_out6),
    .data3(hex_out7),
    .clk(clk),
    .smg_wei(smg_wei2),
    .smg_duan(smg_duan2)
);

Nixie_scan my_scan1(
    .data0(hex_out0),
    .data1(hex_out1),
    .data2(hex_out2),
    .data3(hex_out3),
    .clk(clk),
    .smg_wei(smg_wei1),
    .smg_duan(smg_duan1)
);

key_scan my_key_scan(
    .clk(clk),
    .clk_100Hz(clk_100Hz)
);

count_8 my_count(
    .reg_C(reg_N),
    .LED(LED)
);

uart_tx uart_tx(
    .clk(clk_9600),
    .txd(txd),
    .rst(1),
    .data_1({hex_out7,hex_out6}),
    .data_2({hex_out5,hex_out4}),
    .data_3({hex_out3,hex_out2}),
    .data_4({hex_out1,hex_out0}),
    .receive_ack1(key1),
    .receive_ack2(key2),
    .receive_ack3(key3),
    .receive_ack4(key4)
);



clk_div clk_div(
    .clk(clk),
    .clk_out(clk_9600)
);

lcd1602 mylcd(
    .sys_clk(clk),
    .sys_rst(sys_rst),
    .hex_out7(hex_out7),  
    .hex_out6(hex_out6),
    .hex_out5(hex_out5),
    .hex_out4(hex_out4),
    .hex_out3(hex_out3),
    .hex_out2(hex_out2),
    .hex_out1(hex_out1),
    .hex_out0(hex_out0),
    .bla(bla),
    .blk(blk),
    .lcd_rs(lcd_rs),
    .lcd_rw(lcd_rw),
    .lcd_en(lcd_en),
    .lcd_data(lcd_data),
    .en(en),
    .GND(GND),
    .reg_N(reg_N)
);

endmodule