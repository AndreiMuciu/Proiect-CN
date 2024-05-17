//CACHE CONTROL UNIT
module controlUnit(
input clk,rst_b,
input EN,
input W_R,CacheHIT,CacheFULL,
output reg [5:0] cSig
);
localparam s0 = 1;
localparam s1 = 2;
localparam s2 = 4;
localparam s3 = 8;
localparam s4 = 16;
localparam s5 = 32;
localparam s6 = 64;
localparam s7 = 128;
localparam s8 = 256;
localparam s9 = 512;

reg [9:0] cst,nxst;

always @* begin
case(cst)
s0:begin
if(EN==1)
if(W_R==1)
nxst=s7;
else
nxst=s1;
else
nxst=s0;
end

s1:begin
if(CacheHIT==1)
nxst=s2;
else
nxst=s3;
end

s2:begin
nxst=s0;
end

s3:begin
if(CacheFULL==1)
nxst=s5;
else
nxst=s4;
end

s4:begin
nxst=s6;
end

s5:begin
nxst=s6;
end

s6:begin
if(W_R==1)
nxst=s7;
else
nxst=s1;
end

s7:begin
if(CacheHIT==1)
nxst=s9;
else
nxst=s8;
end

s8:begin
if(CacheFULL==1)
nxst=s5;
else
nxst=s4;
end

s9:begin
nxst=s0;
end
endcase
end

always @* begin
    case (cst)
        s1:cSig=6'd1;
        s2:cSig=6'd2;
        s4:cSig=6'd4;
        s5:cSig=6'd8;
        s6:cSig=6'd16;
        s7:cSig=6'd1;
        s9:cSig=6'd32;
        
        default: cSig=6'd0;
    endcase
end

always @(posedge clk,negedge rst_b) begin
//$display("q = %b", cst);
if(!rst_b)
cst<=s0;
else
cst<=nxst;       
end
endmodule

//CACHE CENTRAL UNIT
module centralUnit(
input [19:0] adressWord,
input [63:0] data_in,
input clk,
input EN,W_R,
output reg [63:0] wordSEL
);
reg CacheHIT,CacheFULL;
reg [523:0] cacheARRAY [127:0][3:0];//128 lines with 3 columns on each element being stored 524b(all fields from one bank)
reg [1:0] SET;
reg ENREG;

wire [6:0] cSig;
reg rst=0,sec=0;

always @(posedge clk) begin
    if(!rst) begin
     ENREG <= EN; 
    end
end

controlUnit fsm(.clk(clk), .rst_b(rst), .EN(ENREG), .W_R(W_R), .CacheHIT(CacheHIT), .CacheFULL(CacheFULL), .cSig(cSig));
//other functions

always @(posedge clk) begin
    if(cSig[6] | cSig[1])ENREG=0;
    rst=sec;
    sec=1;
end
endmodule





