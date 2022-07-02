module score (
    input clk,Reset_Score,key_score,
    input three_point,two_point,one_point,
    input team,
    output wire[7:0] score1,score2  //输出数码管段码
);
    reg[7:0] team_score1,team_score2;
    always @ (posedge clk)  //扫描时钟信号
    begin
        if(three_point&team&key_score)  //计分 3，2，1分
            team_score1<=team_score1+3;
        else if(two_point&team&key_score)
            team_score1<=team_score1+2;
        else if(one_point&team&key_score)
            team_score1<=team_score1+1;    
        else if(Reset_Score&team&key_score)
            team_score1<=0;
    end

    always @ (posedge clk)  //扫描时钟信号
    begin
        if(three_point&team==0&key_score) //计分 3，2，1分
            team_score2<=team_score2+3;
        else if(two_point&team==0&key_score)
            team_score2<=team_score2+2;
        else if(one_point&team==0&key_score)
            team_score2<=team_score2+1;    
        else if(Reset_Score&team==0&key_score)
            team_score2<=0;
    end
    
    assign score1=team_score1;  //两队分数
    assign score2=team_score2;
    
endmodule

