module bin_to_bcd (
    input [7:0]bcd,
    output reg[3:0] ones,tens
    
);
    reg[1:0] hundreds;
    integer i;
    always @(*) begin
        ones=4'd0;
        tens=4'd0;
        hundreds=2'd0;

        for (i=7;i>=0 ;i=i-1 ) begin
            if (ones >= 4'd5) 		ones = ones + 4'd3;
            if (tens >= 4'd5) 		tens = tens + 4'd3;
            if (hundreds >= 4'd5)	hundreds = hundreds + 4'd3;
            hundreds = {hundreds[0],tens[3]};
            tens	 = {tens[2:0],ones[3]};
            ones	 = {ones[2:0],bcd[i]};            
        end
    end
    
endmodule