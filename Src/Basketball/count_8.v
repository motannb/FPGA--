module count_8 (
    input[7:0] reg_C,
    output reg[7:0] LED
);
    reg[7:0] count;
    always @(*) 
    begin
        count=reg_C-16;
        case (count)
            8'h8: LED=8'b11111111;
            8'h7: LED=8'b01111111;
            8'h6: LED=8'b00111111;
            8'h5: LED=8'b00011111;
            8'h4: LED=8'b00001111;
            8'h3: LED=8'b00000111;
            8'h2: LED=8'b00000011;
            8'h1: LED=8'b00000001;
            8'h0: LED=8'b00000000;
            default: LED=8'b00000000;
        endcase    
    end
endmodule