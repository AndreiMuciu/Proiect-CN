//CACHE CONTROL UNIT
module controlUnit(
input clk,rst_b,
input EN,
input W_R,CacheHIT,CacheFULL,
output reg [6:0] cSig
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
        s0:cSig=7'd1;
        s1:cSig=7'd2;
        s2:cSig=7'd4;
        s4:cSig=7'd8;
        s5:cSig=7'd16;
        s6:cSig=7'd32;
        s7:cSig=7'd2;
        s9:cSig=7'd64;
        
        default: cSig=7'd0;
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

//=========================================================================>

module comparator(
  input [6:0] a,
  input [6:0] b,
  output reg eq
);
  always @* begin
    eq = (a == b) ? 1'b1 : 1'b0;
  end
endmodule

module selectWord(
input [6:0] tag,
input [6:0] index,
input [523:0] cacheARRAY [127:0][3:0],
output reg [3:0] set
);
wire eq1,eq2,eq3,eq4;
comparator comp1( .a(cacheARRAY[index][0][11:5]), .b(tag), .eq(eq1));
comparator comp2( .a(cacheARRAY[index][1][11:5]), .b(tag), .eq(eq2));
comparator comp3( .a(cacheARRAY[index][2][11:5]), .b(tag), .eq(eq3));
comparator comp4( .a(cacheARRAY[index][3][11:5]), .b(tag), .eq(eq4));
always @* begin
set[0] <=eq1&cacheARRAY[index][0][1];
set[1] <=eq2&cacheARRAY[index][1][1];
set[2] <=eq3&cacheARRAY[index][2][1];
set[3] <=eq4&cacheARRAY[index][3][1];
end
endmodule

//=========================================================================>

module mux4to1FULL(
    input [1:0] data_in0,
    input [1:0] data_in1,
    input [1:0] data_in2,
    input [1:0] data_in3,
    input [3:0] select,
    output reg [1:0] data_out
);
always @* begin
    case (select)
        4'd1: data_out = data_in0;
        4'd2: data_out = data_in1;
        4'd4: data_out = data_in2;
        4'd8: data_out = data_in3;
        default: data_out = 2'd0; 
    endcase
end
endmodule

module mux4to1(
    input [511:0] data_in0,
    input [511:0] data_in1,
    input [511:0] data_in2,
    input [511:0] data_in3,
    input [3:0] select,
    output reg [511:0] data_out
);
always @* begin
    case (select)
        4'd1: data_out = data_in0;
        4'd2: data_out = data_in1;
        4'd4: data_out = data_in2;
        4'd8: data_out = data_in3;
        default: data_out = 512'd0; 
    endcase
end
endmodule

module mux8to1A(
    input [63:0] data_in0,
    input [63:0] data_in1,
    input [63:0] data_in2,
    input [63:0] data_in3,
    input [63:0] data_in4,
    input [63:0] data_in5,
    input [63:0] data_in6,
    input [63:0] data_in7,
    input [2:0] select,
    output reg [63:0] data_out
);
always @* begin
    case (select)
        3'd0: data_out = data_in0;
        3'd1: data_out = data_in1;
        3'd2: data_out = data_in2;
        3'd3: data_out = data_in3;
        3'd4: data_out = data_in4;
        3'd5: data_out = data_in5;
        3'd6: data_out = data_in6;
        3'd7: data_out = data_in7;
        default: data_out = 64'd0; 
    endcase
end
endmodule

module mux8to1B(
    input [7:0] data_in0,
    input [7:0] data_in1,
    input [7:0] data_in2,
    input [7:0] data_in3,
    input [7:0] data_in4,
    input [7:0] data_in5,
    input [7:0] data_in6,
    input [7:0] data_in7,
    input [2:0] select,
    output reg [7:0] data_out
);
always @* begin
    case (select)
        3'd0: data_out = data_in0;
        3'd1: data_out = data_in1;
        3'd2: data_out = data_in2;
        3'd3: data_out = data_in3;
        3'd4: data_out = data_in4;
        3'd5: data_out = data_in5;
        3'd6: data_out = data_in6;
        3'd7: data_out = data_in7;
        default: data_out = 8'd0; 
    endcase
end
endmodule

module mux2to1(
    input [7:0] data_in0,
    input [7:0] data_in1,
    input select,
    output reg [7:0] data_out
);
always @* begin
    case (select)
        1'b0: data_out = data_in0;
        1'b1: data_out = data_in1;
        default: data_out = 8'd0; 
    endcase
end
endmodule

module mux2to1SET(
    input [1:0] data_in0,
    input [1:0] data_in1,
    input select,
    output reg [1:0] data_out
);
always @* begin
    case (select)
        1'b0: data_out = data_in0;
        1'b1: data_out = data_in1;
        default: data_out = 2'd0; 
    endcase
end
endmodule

//=========================================================================>

module eqFULLM(
input [1:0] age0,age1,age2,age3,
output reg [3:0] eqFULL
);
always @* begin
eqFULL[0]<=(age0==2'd3) ? 1'b1 : 1'b0;
eqFULL[1]<=(age1==2'd3) ? 1'b1 : 1'b0;
eqFULL[2]<=(age2==2'd3) ? 1'b1 : 1'b0;
eqFULL[3]<=(age3==2'd3) ? 1'b1 : 1'b0;
end
endmodule

module eqNFULLM(
input s0,s1,s2,s3,
output reg [3:0] eqNFULL
);
always @* begin
eqNFULL[0]<=eqNFULL[0]&eqNFULL[1]&eqNFULL[2]&eqNFULL[3];
eqNFULL[1]<=(~eqNFULL[0])&eqNFULL[1]&eqNFULL[2]&eqNFULL[3];
eqNFULL[2]<=(~eqNFULL[0])&(~eqNFULL[1])&eqNFULL[2]&eqNFULL[3];
eqNFULL[3]<=(~eqNFULL[0])&(~eqNFULL[1])&(~eqNFULL[2])&eqNFULL[3];
end
endmodule

//=========================================================================>

module detectBlockInCache(
input clk,
input [523:0] cacheARRAY [127:0][3:0],
input [19:0] adressWord,
input signal,
input CacheHIT_IN,CacheFULL_IN,
input [1:0] SET_IN,
input [7:0] wordSEL_IN,
output reg CacheHIT_OUT,CacheFULL_OUT,
output reg [7:0] wordSEL_OUT,
output reg [1:0] SET_OUT
);
wire [3:0] set;
wire [511:0] selblk;
wire [63:0] selword;
wire [7:0] selbyte;

wire [7:0] wordSEL;
wire CacheHIT,CacheFULL;
wire [1:0] SET;

wire [3:0] eqFULL,eqNFULL;
wire [1:0] setFULL,setNFULL;
wire [1:0] setHIT,setNHIT;

selectWord inst(.tag(adressWord[19:13]), .index(adressWord[12:6]), .cacheARRAY(cacheARRAY), .set(set));

mux4to1 blockSET(.data_in0(cacheARRAY[adressWord[12:6]][0][523:12]), .data_in1(cacheARRAY[adressWord[12:6]][1][523:12]),
                 .data_in2(cacheARRAY[adressWord[12:6]][2][523:12]), .data_in3(cacheARRAY[adressWord[12:6]][3][523:12]), 
                 .select(set[3:0]), .data_out(selblk));
mux8to1A wordSET(.data_in0(selblk[63:0]), .data_in1(selblk[127:64]), .data_in2(selblk[191:128]),
                 .data_in3(selblk[255:192]), .data_in4(selblk[319:256]), .data_in5(selblk[383:320]),
                 .data_in6(selblk[447:384]), .data_in7(selblk[511:448]), 
                 .select(adressWord[5:3]), .data_out(selword));
mux8to1B byteSET(.data_in0(selword[7:0]), .data_in1(selword[15:8]), .data_in2(selword[23:16]),
                 .data_in3(selword[31:24]), .data_in4(selword[39:32]), .data_in5(selword[47:40]),
                 .data_in6(selword[55:48]), .data_in7(selword[63:56]), 
                 .select(adressWord[2:0]), .data_out(selbyte));                 
mux2to1 byteSETFINAL(.data_in0(wordSEL_IN), .data_in1(selbyte), .select(signal), .data_out(wordSEL));
//pt wordSEL

assign CacheFULL=~(cacheARRAY[adressWord[12:6]][0][0] | cacheARRAY[adressWord[12:6]][1][0] | cacheARRAY[adressWord[12:6]][2][0] | cacheARRAY[adressWord[12:6]][3][0]);
assign CacheHIT=(set[0] | set[1] | set[2] | set[3]);
//pt CacheHIT CacheFULL

eqFULLM eqinst1(.age0(cacheARRAY[adressWord[12:6]][0][4:3]), .age1(cacheARRAY[adressWord[12:6]][1][4:3]),
                .age2(cacheARRAY[adressWord[12:6]][2][4:3]), .age3(cacheARRAY[adressWord[12:6]][3][4:3]), .eqFULL(eqFULL));
eqNFULLM eqinst2(.s0(cacheARRAY[adressWord[12:6]][0][0]), .s1(cacheARRAY[adressWord[12:6]][1][0]),
                .s2(cacheARRAY[adressWord[12:6]][2][0]), .s3(cacheARRAY[adressWord[12:6]][3][0]), .eqNFULL(eqNFULL));
                
mux4to1FULL fullMUX(.data_in0(2'd0), .data_in1(2'd1), .data_in2(2'd2), .data_in3(2'd3), .select(eqFULL[3:0]), .data_out(setFULL));
mux4to1FULL nfullMUX(.data_in0(2'd0), .data_in1(2'd1), .data_in2(2'd2), .data_in3(2'd3), .select(eqNFULL[3:0]), .data_out(setNFULL));
mux2to1SET FULLORNFULLMUX(.data_in0(setNFULL), .data_in1(setFULL), .select(CacheFULL), .data_out(setNHIT));

mux4to1FULL HITCASE(.data_in0(2'd0), .data_in1(2'd1), .data_in2(2'd2), .data_in3(2'd3), .select(set[3:0]), .data_out(setHIT));
mux2to1SET HITORNHIT(.data_in0(setHIT), .data_in1(setNHIT), .select(~CacheHIT), .data_out(SET));
//pt SET

always @* begin
CacheHIT_OUT<=(signal==1)? CacheHIT:CacheHIT_IN;
CacheFULL_OUT<=(signal==1)? CacheFULL:CacheFULL_IN;
wordSEL_OUT<=wordSEL;
SET_OUT<=(signal==1)? SET:SET_IN;
end
endmodule

//==========================================================================>
                   
//CACHE CENTRAL UNIT
module centralUnit(
input [19:0] adressWord,
input [63:0] data_in,
input clk,
input EN,W_R,
output reg [7:0] wordSELOUT
);

reg [523:0] cacheARRAY [127:0][3:0];//128 lines with 3 columns on each element being stored 524b(all fields from one bank)
reg CacheHIT,CacheFULL;
reg [1:0] SET;
reg [7:0] wordSEL;

wire [6:0] cSig;
wire CacheHITaux,CacheFULLaux;
wire [1:0] SETaux;
wire [7:0] wordSELaux;
reg rst=0,sec=0;

integer i, j;
always @(posedge clk) begin
    if(!rst) begin
     wordSEL<=8'd0;CacheHIT<=0;CacheFULL<=0;SET<=2'd0;
  for (i = 0; i < 128; i = i + 1) begin
    for (j = 0; j < 4; j = j + 1) begin
      cacheARRAY[i][j]<=524'd0;
      cacheARRAY[i][j][0]<=1'b1;
    end
  end
    end
end

controlUnit fsm(.clk(clk), .rst_b(rst), .EN(EN), .W_R(W_R), .CacheHIT(CacheHIT), .CacheFULL(CacheFULL), .cSig(cSig));
detectBlockInCache detect(.clk(clk), .cacheARRAY(cacheARRAY), .adressWord(adressWord), .signal(cSig[1]),
                   .CacheHIT_IN(CacheHIT), .wordSEL_IN(wordSEL), .CacheFULL_IN(CacheFULL), .SET_IN(SET),
                   .CacheHIT_OUT(CacheHITaux), .wordSEL_OUT(wordSELaux), .CacheFULL_OUT(CacheFULLaux), .SET_OUT(SETaux));
//other functions,to be wr

always @(posedge clk) begin
    if(cSig[6] | cSig[2] | cSig[0])begin 
    wordSEL<=8'd0; CacheHIT<=0;CacheFULL<=0;SET<=2'd0;//nu reinit cacheARRAY
    end
    else begin
    CacheHIT<=CacheHITaux;
    CacheFULL<=CacheFULLaux;
    SET<=SETaux;
    wordSEL<=wordSELaux;
    wordSELOUT<=wordSEL;
    end
    rst=sec;
    sec=1;
end
endmodule





