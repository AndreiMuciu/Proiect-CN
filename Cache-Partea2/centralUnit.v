//CACHE CONTROL UNIT
module controlUnit(
input clk,rst_b,
input EN,
input W_R,CacheHIT,CacheFULL,
output reg [6:0] cSig
);
localparam s0 = 1;
localparam s1 = 2;
localparam sREADINT=4;
localparam s2 = 8;
localparam s3 = 16;
localparam s4 = 32;
localparam s5 = 64;
localparam s6 = 128;
localparam s7 = 256;
localparam sWRITEINT=512;
localparam s8 = 1024;
localparam s9 = 2048;

reg [11:0] cst,nxst;

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
nxst=sREADINT;
end

sREADINT:begin
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
nxst=sWRITEINT;
end
  
sWRITEINT:begin
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
output reg [3:0] set,
input [523:0] cacheBANK_A [127:0],
input [523:0] cacheBANK_B [127:0],
input [523:0] cacheBANK_C [127:0],
input [523:0] cacheBANK_D [127:0]
);
wire eq1,eq2,eq3,eq4;
comparator comp1( .a(cacheBANK_A[index][11:5]), .b(tag), .eq(eq1));
comparator comp2( .a(cacheBANK_B[index][11:5]), .b(tag), .eq(eq2));
comparator comp3( .a(cacheBANK_C[index][11:5]), .b(tag), .eq(eq3));
comparator comp4( .a(cacheBANK_D[index][11:5]), .b(tag), .eq(eq4));
always @* begin
set[0] <=eq1&cacheBANK_A[index][1];
set[1] <=eq2&cacheBANK_B[index][1];
set[2] <=eq3&cacheBANK_C[index][1];
set[3] <=eq4&cacheBANK_D[index][1];
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
  eqNFULL[0]<=s0&s1&s2&s3;
  eqNFULL[1]<=(~s0)&s1&s2&s3;
  eqNFULL[2]<=(~s0)&(~s1)&s2&s3;
  eqNFULL[3]<=(~s0)&(~s1)&(~s2)&s3;
end
endmodule

//=========================================================================>

module detectBlockInCache(
input clk,
input [523:0] cacheBANK_A [127:0],
input [523:0] cacheBANK_B [127:0],
input [523:0] cacheBANK_C [127:0],
input [523:0] cacheBANK_D [127:0],
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

selectWord inst(.tag(adressWord[19:13]), .index(adressWord[12:6]), .set(set),
                .cacheBANK_A(cacheBANK_A), .cacheBANK_B(cacheBANK_B), .cacheBANK_C(cacheBANK_C), .cacheBANK_D(cacheBANK_D));

mux4to1 blockSET(.data_in0(cacheBANK_A[adressWord[12:6]][523:12]), .data_in1(cacheBANK_B[adressWord[12:6]][523:12]),
                 .data_in2(cacheBANK_C[adressWord[12:6]][523:12]), .data_in3(cacheBANK_D[adressWord[12:6]][523:12]), 
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

assign CacheFULL=~(cacheBANK_A[adressWord[12:6]][0] | cacheBANK_B[adressWord[12:6]][0] | cacheBANK_C[adressWord[12:6]][0] | cacheBANK_D[adressWord[12:6]][0]);
assign CacheHIT=(set[0] | set[1] | set[2] | set[3]);
//pt CacheHIT CacheFULL

eqFULLM eqinst1(.age0(cacheBANK_A[adressWord[12:6]][4:3]), .age1(cacheBANK_B[adressWord[12:6]][4:3]),
                .age2(cacheBANK_C[adressWord[12:6]][4:3]), .age3(cacheBANK_D[adressWord[12:6]][4:3]), .eqFULL(eqFULL));
eqNFULLM eqinst2(.s0(cacheBANK_A[adressWord[12:6]][0]), .s1(cacheBANK_B[adressWord[12:6]][0]),
                .s2(cacheBANK_C[adressWord[12:6]][0]), .s3(cacheBANK_D[adressWord[12:6]][0]), .eqNFULL(eqNFULL));
                
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

//4 matrices of dimension:128 lines with 524 columns(all fields from one banks's cache index/line/no_set)
reg [523:0] cacheBANK_A [127:0];
reg [523:0] cacheBANK_B [127:0];
reg [523:0] cacheBANK_C [127:0];
reg [523:0] cacheBANK_D [127:0];

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
      cacheBANK_A[i]<=524'd0;cacheBANK_B[i]<=524'd0;cacheBANK_C[i]<=524'd0;cacheBANK_D[i]<=524'd0;
      cacheBANK_A[i][0]<=1'b1;cacheBANK_B[i][0]<=1'b1;cacheBANK_C[i][0]<=1'b1;cacheBANK_D[i][0]<=1'b1;
  end
      /*
      //cache test for line1 word8 wordOffB=0
      //cacheBANK_D[1][1]<=1'b1;cacheBANK_D[1][523:460]<=64'hFFFFFFFFFFFFFFFF;
      //cacheBANK_A[1][0]<=1'b0;cacheBANK_B[1][0]<=1'b0;cacheBANK_C[1][0]<=1'b0;cacheBANK_D[1][0]<=1'b0;
      //cacheBANK_D[1][4:3]<=3;
      */ 
    end
end

controlUnit fsm(.clk(clk), .rst_b(rst), .EN(EN), .W_R(W_R), .CacheHIT(CacheHIT), .CacheFULL(CacheFULL), .cSig(cSig));
detectBlockInCache detect(.clk(clk), .adressWord(adressWord), .signal(cSig[1]),
                          .cacheBANK_A(cacheBANK_A), .cacheBANK_B(cacheBANK_B), .cacheBANK_C(cacheBANK_C), .cacheBANK_D(cacheBANK_D),
                          .CacheHIT_IN(CacheHIT), .wordSEL_IN(wordSEL), .CacheFULL_IN(CacheFULL), .SET_IN(SET),
                          .CacheHIT_OUT(CacheHITaux), .wordSEL_OUT(wordSELaux), .CacheFULL_OUT(CacheFULLaux), .SET_OUT(SETaux));
//...other functions,to be written

always @(posedge clk) begin
  $monitor("rst=%b  cSig=%b  HIT=%b  wordSEL=%d  SET=%b  FULL=%b",rst,cSig,CacheHIT,wordSELOUT,SET,CacheFULL);
    if(cSig[6] | cSig[2] | cSig[0])begin
    wordSEL<=8'd0; CacheHIT<=0;CacheFULL<=0;SET<=2'd0;//nu reinit niciun bank de cache
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











module centralUnit_tb;
  reg [19:0] adressWord;
  reg [63:0] data_in;
  reg clk;
  reg EN,W_R;
  wire [7:0] wordSELOUT;
  
  centralUnit test(.adressWord(adressWord), .data_in(data_in),
                   .clk(clk), .EN(EN), .W_R(W_R), .wordSELOUT(wordSELOUT));
  initial begin
    //$monitor("%b\n",wordSELOUT);
    //minclocksRST_EN=2cc
    //avgclocksADDRESSHIT=5cc
    //avgclocksADRESSMISS=10cc
    //1cc=2*10ns
    
    //1request
    adressWord=20'b00000000000001111000;//linia/index=1 word=8 wordOffB=0
    EN=1'b1;
    W_R=1'b0;
    #50;//wait minclocksRST_EN cycles from start,for fsm to exit s0 state(independent on EN)     =2cc x 20ns +10buff
    EN=1'b0;//then we rest the en until the next request
    #210;//the cache will be quicker thatn this waitTime,causing it to wait for a next request  =(miss)10cc x 20ns +10 buff
    
    //another requests.....
    
    $finish;
  end
  
  localparam run_cycle=10,cycles=50;
initial begin
  clk=1'b0;
  repeat (cycles*2)
#run_cycle clk=~clk;
end
endmodule
