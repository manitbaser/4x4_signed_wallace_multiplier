module HA(a,b,sum,carry);
input a,b;
output sum,carry;
assign sum=a^b;
assign carry=a&b;
endmodule



module FA(a,b,cin,sum,carry);
input a,b,cin;
output sum,carry;
wire T1,T2,T3;
xor(sum,a,b,cin);
and(T1,a,b);
and(T2,a,cin);
and(T3,b,cin);
or(carry,T3,T2,T1);
endmodule


`timescale 1ns / 1ps

module wallace1(output reg [7:0] product, input [7:0] x, y, input clock);

reg p [7:0][7:0];

wire [21:1] fs ,fc;

wire [10:1] hs, hc;

integer i,j;

always@(y, x)

begin

for ( i = 0; i <= 7; i = i + 1)

for ( j = 0; i + j <= 7; j = j + 1)

p[i][j] <= x[i] & y[j];

end
///////////////////////////////////////////////////////////////////////////////////
HA ha_1 ( .sum(hs[1]), .carry(hc[1]), .a(p[1][0]), .b( p[0][1]));

FA fa_1 ( .sum(fs[1]), .carry(fc[1]), .a(p[2][0]), .b( p[1][1]), .cin( p[0][2] ) );

FA fa_2 ( .sum(fs[2]), .carry(fc[2]), .a(p[2][1]), .b( p[0][3]), .cin( p[1][2] ) );

FA fa_3 ( .sum(fs[3]), .carry(fc[3]), .a(p[0][4]), .b( p[1][3]), .cin( p[2][2] ) );

HA ha_2 ( .sum(hs[2]), .carry(hc[2]), .a(p[3][1]), .b( p[4][0]));

FA fa_4 ( .sum(fs[4]), .carry(fc[4]), .a(p[0][5]), .b( p[1][4]), .cin( p[2][3] ) );

FA fa_5 ( .sum(fs[5]), .carry(fc[5]), .a(p[3][2]), .b( p[4][1]), .cin( p[5][0] ) );

FA fa_6 ( .sum(fs[6]), .carry(fc[6]), .a(p[0][6]), .b( p[1][5]), .cin( p[2][4] ) );

FA fa_7 ( .sum(fs[7]), .carry(fc[7]), .a(p[3][3]), .b( p[4][2]), .cin( p[5][1] ) );

FA fa_8 ( .sum(fs[8]), .carry(fc[8]), .a(p[0][7]), .b( p[1][6]), .cin( p[2][5] ) );

FA fa_9 ( .sum(fs[9]), .carry(fc[9]), .a(p[3][4]), .b( p[4][3]), .cin( p[5][2] ) );
///////////////////////////////////////////////////////////////////////////////////
HA ha_3 ( .sum(hs[3]), .carry(hc[3]), .a(hc[1]), .b( fs[1]));

FA fa_10 ( .sum(fs[10]), .carry(fc[10]), .a(fc[1]), .b( fs[2]), .cin( p[3][0] ) );

FA fa_11 ( .sum(fs[11]), .carry(fc[11]), .a(fc[2]), .b( fs[3]), .cin( hs[2] ) );

FA fa_12 ( .sum(fs[12]), .carry(fc[12]), .a(fc[3]), .b( hc[2]), .cin( fs[4] ) );

FA fa_13 ( .sum(fs[13]), .carry(fc[13]), .a(fc[4]), .b( fc[5]), .cin( fs[6] ) );

HA ha_4 ( .sum(hs[4]), .carry(hc[4]), .a(fs[7]), .b( p[6][0]));

FA fa_14 ( .sum(fs[14]), .carry(fc[14]), .a(fc[6]), .b( fc[7]), .cin( fs[8] ) );

FA fa_15 ( .sum(fs[15]), .carry(fc[15]), .a(fs[9]), .b( p[6][1]), .cin( p[7][0] ) );
///////////////////////////////////////////////////////////////////////////////////
HA ha_5 ( .sum(hs[5]), .carry(hc[5]), .a(hc[3]), .b( fs[10]));

HA ha_6 ( .sum(hs[6]), .carry(hc[6]), .a(fc[10]), .b( fs[11]));

FA fa_16 ( .sum(fs[16]), .carry(fc[16]), .a(fc[11]), .b( fs[12]), .cin( fs[5] ) );

FA fa_17 ( .sum(fs[17]), .carry(fc[17]), .a(fc[12]), .b( fs[13]), .cin( hs[4] ) );

FA fa_18 ( .sum(fs[18]), .carry(fc[18]), .a(fc[13]), .b( hc[4]), .cin( fs[14] ) );
///////////////////////////////////////////////////////////////////////////////////
HA ha_7 ( .sum(hs[7]), .carry(hc[7]), .a(hc[5]), .b( hs[6]));

HA ha_8 ( .sum(hs[8]), .carry(hc[8]), .a(hc[6]), .b( fs[16]));

HA ha_9 ( .sum(hs[9]), .carry(hc[9]), .a(fc[16]), .b( fs[17]));

FA fa_19 ( .sum(fs[19]), .carry(fc[19]), .a(fc[17]), .b( fs[18]), .cin( fs[15] ) );
///////////////////////////////////////////////////////////////////////////////////
HA ha_10 ( .sum(hs[10]), .carry(hc[10]), .a(hc[7]), .b( hs[8]));

FA fa_20 ( .sum(fs[20]), .carry(fc[20]), .a(hc[10]), .b( hc[8]), .cin( hs[9] ) );

FA fa_21 ( .sum(fs[21]), .carry(fc[21]), .a(fc[20]), .b( hc[9]), .cin( fs[19] ) );



always@(posedge clock)
begin

product <={fs[21],fs[20],hs[10],hs[7],hs[5],hs[3],hs[1],p[0][0]};
end

endmodule

module testbench;
 
 reg clock;
 reg [7:0]x;
 reg [7:0]y;
 wire [7:0]product;
 wallace1 wall(product,x,y,clock);

 initial 
    begin
        clock = 1'b0;
        x = 8'b11111110;
        y = 8'b00000110;
    end
always 
    #1 clock = ~clock;

initial
    begin
        #6 x = 8'b00000110;
        #0 y = 8'b00000110;
        #6 x = 8'b00000100;
        #6 x = 8'b00000101;
        #0 y = 8'b11111111;
        #6 x = 8'b00000000;
        #6 x = 8'b00000001;
        #0 y = 8'b00000010;
        #6 $finish;
    end
initial 
    begin
        $dumpfile("wallace.vcd");
        $dumpvars;
    end


endmodule