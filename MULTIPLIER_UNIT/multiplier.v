module RCA(
  input[7:0] A,
  input[7:0] B,
  input cin,
  output[7:0] sum,
  output cout,
  output overflw
);
wire [7:0] carry;

FAC FA0 (.A(A[0]), .B(B[0]), .cin(cin), .sum(sum[0]), .cout(carry[0]));
FAC FA1 (.A(A[1]), .B(B[1]), .cin(carry[0]), .sum(sum[1]), .cout(carry[1]));
FAC FA2 (.A(A[2]), .B(B[2]), .cin(carry[1]), .sum(sum[2]), .cout(carry[2]));
FAC FA3 (.A(A[3]), .B(B[3]), .cin(carry[2]), .sum(sum[3]), .cout(carry[3]));
FAC FA4 (.A(A[4]), .B(B[4]), .cin(carry[3]), .sum(sum[4]), .cout(carry[4]));
FAC FA5 (.A(A[5]), .B(B[5]), .cin(carry[4]), .sum(sum[5]), .cout(carry[5]));
FAC FA6 (.A(A[6]), .B(B[6]), .cin(carry[5]), .sum(sum[6]), .cout(carry[6]));
FAC FA7 (.A(A[7]), .B(B[7]), .cin(carry[6]), .sum(sum[7]), .cout(cout));
assign overflw=cout | carry[6];
endmodule
module FAC(
  input A,
  input B,
  input cin,
  output sum,
  output cout
);
assign sum = A ^ B ^ cin;
assign cout = (A & B) | (A & cin) | (B & cin);
endmodule
module RCA_Star(
  input[7:0] A,
  input[7:0] B,
  input cin,
  output[7:0] sum,
  output cout,
  output pi
);
wire[7:0] propagate;
wire[7:0] carry;

FAC_Star FAS0 (.A(A[0]), .B(B[0]), .cin(cin), .sum(sum[0]), .cout(carry[0]), .pi(propagate[0]));
FAC_Star FAS1 (.A(A[1]), .B(B[1]), .cin(carry[0]), .sum(sum[1]), .cout(carry[1]), .pi(propagate[1]));
FAC_Star FAS2 (.A(A[2]), .B(B[2]), .cin(carry[1]), .sum(sum[2]), .cout(carry[2]), .pi(propagate[2]));
FAC_Star FAS3 (.A(A[3]), .B(B[3]), .cin(carry[2]), .sum(sum[3]), .cout(carry[3]), .pi(propagate[3]));
FAC_Star FAS4 (.A(A[4]), .B(B[4]), .cin(carry[3]), .sum(sum[4]), .cout(carry[4]), .pi(propagate[4]));
FAC_Star FAS5 (.A(A[5]), .B(B[5]), .cin(carry[4]), .sum(sum[5]), .cout(carry[5]), .pi(propagate[5]));
FAC_Star FAS6 (.A(A[6]), .B(B[6]), .cin(carry[5]), .sum(sum[6]), .cout(carry[6]), .pi(propagate[6]));
FAC_Star FAS7 (.A(A[7]), .B(B[7]), .cin(carry[6]), .sum(sum[7]), .cout(cout), .pi(propagate[7]));

assign pi = propagate[0] & propagate[1] & propagate[2] & propagate[3] & propagate[4] & propagate[5] & propagate[6] & propagate[7];
endmodule
module FAC_Star(
  input A,
  input B,
  input cin,
  output sum,
  output cout,
  output pi
  );
  
  assign sum = A ^ B ^ cin;
  assign cout = (A & B) | (A & cin) | (B & cin);
  assign pi =A | B;
endmodule
module makeXor #(
    parameter WIDTH = 32 
)(
    input [WIDTH-1:0] a,
    input b,
    output [WIDTH-1:0] aXor
);

// Internal wire for the result of the XOR operation
wire [WIDTH-1:0] temp_aXor;
//assign aXor={WIDTH{1'd0}};

// Perform XOR operation between each bit of 'a' and 'b'
genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin : XOR_loop
        assign temp_aXor[i] = a[i] ^ b;
    end
endgenerate

// Assign the result to the output
assign aXor = temp_aXor;
endmodule
module CSkA(
    //va trebui 1.x[32],y[32]-->sum[67](adunare)  2.x[33],y[33]-->sum[33](impartire)  3.x[34],y[34]-->sum[34](inmultire)
    input [31:0] 	X,
    input [31:0] 	Y,
    input [32:0] 	X2,
    input [32:0] 	Y2,
    input [33:0] 	X3,
    input [33:0] 	Y3, 
    input 	cin,
    output 	cout,
    output 	cout2,
    output 	cout3,
    output [66:0] sum,
    output [32:0] sum2,
    output [33:0] sum3
);
// Declaration of wires
wire [31:0] Y_xor_cin;
wire [32:0] Y2_xor_cin;
wire [33:0] Y3_xor_cin;
wire ovrflw;

makeXor #(.WIDTH(32)) xor1 (.a(Y), .b(cin), .aXor(Y_xor_cin));
makeXor #(.WIDTH(33)) xor2 (.a(Y2), .b(cin), .aXor(Y2_xor_cin));
makeXor #(.WIDTH(34)) xor3 (.a(Y3), .b(cin), .aXor(Y3_xor_cin));


//pt 32b
wire [2:0] carry;
wire Propagate1,Propagate2;

RCA RCA0(.A(X[7:0]), .B(Y_xor_cin[7:0]), .cin(cin), .sum(sum[7:0]), .cout(carry[0]), .overflw(overflw));
RCA_Star RCA1(.A(X[15:8]), .B(Y_xor_cin[15:8]), .cin(carry[0]), .sum(sum[15:8]), .cout(carry[1]), .pi(Propagate1));
RCA_Star RCA2(.A(X[23:16]), .B(Y_xor_cin[23:16]), .cin(carry[1]|(Propagate1&carry[0])), .sum(sum[23:16]), .cout(carry[2]), .pi(Propagate2));
RCA RCA3(.A(X[31:24]), .B(Y_xor_cin[31:24]), .cin(carry[2]|(Propagate2&carry[1])), .sum(sum[31:24]), .cout(cout), .overflw(overflw));

genvar i;
generate
    for (i = 32; i <67; i = i + 1) begin :loop
        assign sum[i]=sum[31];
    end
endgenerate

//pt 33b
wire [2:0] carry2;
wire Propagate21,Propagate22;
wire auxcout;

RCA RCA10(.A(X2[7:0]), .B(Y2_xor_cin[7:0]), .cin(cin), .sum(sum2[7:0]), .cout(carry2[0]), .overflw(overflw));
RCA_Star RCA11(.A(X2[15:8]), .B(Y2_xor_cin[15:8]), .cin(carry2[0]), .sum(sum2[15:8]), .cout(carry2[1]), .pi(Propagate21));
RCA_Star RCA12(.A(X2[23:16]), .B(Y2_xor_cin[23:16]), .cin(carry2[1]|(Propagate21 & carry2[0])), .sum(sum2[23:16]), .cout(carry2[2]), .pi(Propagate22));
RCA RCA13(.A(X2[31:24]), .B(Y2_xor_cin[31:24]), .cin(carry2[2]|(Propagate22 & carry2[1])), .sum(sum2[31:24]), .cout(auxcout), .overflw(overflw));
FAC FAC11(.A(X2[32]), .B(Y2_xor_cin[32]), .cin(auxcout), .sum(sum2[32]), .cout(cout2)); // Connect carry-out of RCA13 to cin of FAC11

//pt 34b
wire [2:0] carry3;
wire Propagate31,Propagate32;
wire auxcout1,auxcout2;

RCA RCA20(.A(X3[7:0]), .B(Y3_xor_cin[7:0]), .cin(cin), .sum(sum3[7:0]), .cout(carry3[0]), .overflw(overflw));
RCA_Star RCA21(.A(X3[15:8]), .B(Y3_xor_cin[15:8]), .cin(carry3[0]), .sum(sum3[15:8]), .cout(carry3[1]), .pi(Propagate31));
RCA_Star RCA22(.A(X3[23:16]), .B(Y3_xor_cin[23:16]), .cin(carry3[1]|(Propagate31 & carry3[0])), .sum(sum3[23:16]), .cout(carry3[2]), .pi(Propagate32));
RCA RCA23(.A(X3[31:24]), .B(Y3_xor_cin[31:24]), .cin(carry3[2]|(Propagate32 & carry3[1])), .sum(sum3[31:24]), .cout(auxcout1), .overflw(overflw));
FAC FAC21(.A(X3[32]), .B(Y3_xor_cin[32]), .cin(auxcout1), .sum(sum3[32]), .cout(auxcout2)); // Connect carry-out of RCA23 to cin of FAC21
FAC FAC22(.A(X3[33]), .B(Y3_xor_cin[33]), .cin(auxcout2), .sum(sum3[33]), .cout(cout3)); // Connect carry-out of FAC21 to cin of FAC2   
endmodule

  
  








module controlUnit(
input clk,rst_b,
input START,
input [3:0] cnt,
input w,x,y,z,
output [7:0] cSig
);
localparam s0=0;
localparam s1=1;
localparam s2=2;
localparam s3=3;
localparam s4=4;
localparam s5=5;
localparam s6=6;
localparam s7=7;
localparam s8=8;
localparam s9=9;
localparam s10=10;
localparam s11=11;
localparam s12=12;
localparam s13=13;
localparam s14=14;

reg [14:0] cst;
wire [14:0] nxst=15'd0;

assign nxst[s0]=(cst[s13])|(cst[s0]&(~START));
assign nxst[s1]=(cst[s0]&START);
assign nxst[s2]=(cst[s1]);
assign nxst[s3]=cst[s2]|cst[s14];

assign nxst[s4]=(cst[s3]&( ((~w)&(~x)&(~y)&(z)) | ((~w)&(~x)&(y)&(~z)) ));
assign nxst[s5]=(cst[s3]&( ((w)&(x)&(~y)&(z)) | ((w)&(x)&(y)&(~z)) ));

assign nxst[s6]=(cst[s3]&( ((~w)&(~x)&(y)&(z)) | ((~w)&(x)&(~y)&(~z)) ));
assign nxst[s7]=(cst[s3]&( ((w)&(x)&(~y)&(~z)) | ((w)&(~x)&(y)&(z)) ));

assign nxst[s8]=(cst[s3]&( ((~w)&(x)&(~y)&(z)) | ((~w)&(x)&(y)&(~z)) ));
assign nxst[s9]=(cst[s3]&( ((w)&(~x)&(~y)&(z)) | ((w)&(~x)&(y)&(~z)) ));

assign nxst[s10]=(cst[s3]&( ((~w)&(x)&(y)&(z))));
assign nxst[s11]=(cst[s3]&( ((w)&(~x)&(~y)&(~z))));


assign nxst[s12]= (cst[s3] & ( ((w)&(x)&(y)&(z)) | ((~w)&(~x)&(~y)&(~z)) )) |
                 (cst[s4]) | (cst[s5]) | (cst[s6]) | (cst[s7]) | 
                 (cst[s8]) | (cst[s9]) | (cst[s10]) | (cst[s11]) ;
                 
assign nxst[s13]=cst[s12] & (cnt[0]&cnt[1]&cnt[2]&cnt[3]);
assign nxst[s14]=(~nxst[s13]);


assign cSig=8'd0;

assign cSig[7]= (cst[s4]) | (cst[s5]) | (cst[s6]) | (cst[s7]) | 
                 (cst[s8]) | (cst[s9]) | (cst[s10]) | (cst[s11]);
assign cSig[0]=cst[s1];
assign cSig[1]=cst[s2];

assign cSig[2]=cst[s5]|cst[s7]|cst[s9]|cst[s11];
assign cSig[3]=cst[s10]|cst[s8]|cst[s9]|cst[s11];
assign cSig[4]=cst[s6]|cst[s7]|cst[s10]|cst[s11];

assign cSig[5]=cst[s4]|cst[s5]|cst[s6]|cst[s7]|cst[s8]|cst[s9]|cst[s11]|
               (cst[s3] & ( ((w)&(x)&(y)&(z)) | ((~w)&(~x)&(~y)&(~z)) ));
assign cSig[6]=cst[s13];

always @(posedge clk,negedge rst_b) begin
//$display("q = %b", cst);
if(!rst_b)begin
cst<=0;
cst[s0]<=1;
end
else
cst<=nxst;       
end
endmodule

//===========================================================================================

module obtain(
  input [33:0] originalM,
  output [33:0] twoM,fourM,threeM
);
wire cout,cout2,cout3;
wire [66:0] sum;
wire [32:0] sum2;

genvar i;
generate
  for (i = 1; i < 34; i = i + 1) begin : shift_twoM
      assign twoM[i] = originalM[i-1];
  end
endgenerate
CSkA CSkA_inst2 (
    .X(32'b0),          // Set X to zero, unused
    .Y(32'b0),          // Set Y to zero, unused
    .X2(33'b0),            // Connect X2
    .Y2(33'b0),            // Connect Y2
    .X3(twoM),         // Set X3 to zero, unused
    .Y3(originalM),         // Set Y3 to zero, unused
    .cin(1'b0),
    .cout(cout),
    .cout2(cout2),
    .cout3(cout3),
    .sum(sum),
    .sum2(sum2),
    .sum3(threeM)
);
genvar j;
generate
  for (j = 1; j < 34; j = j + 1) begin : shift_fourM
    assign fourM[j] = twoM[j-1];
  end
endgenerate
endmodule

//===========================================================================================

module mux4to1(
    input [33:0] data_in0,
    input [33:0] data_in1,
    input [33:0] data_in2,
    input [33:0] data_in3,
    input [1:0] select,
    output reg [33:0] data_out
);

always @* begin
    case (select)
        2'b00: data_out = data_in0;
        2'b01: data_out = data_in1;
        2'b10: data_out = data_in2;
        2'b11: data_out = data_in3;
        default: data_out = 34'bx; // Handle invalid select values
    endcase
end
endmodule
module mux2to1A(
    input [33:0] data_in0,
    input [33:0] data_in1,
    input select,
    output reg [33:0] data_out
);
always @* begin
    case (select)
        1'b0: data_out = data_in0;
        1'b1: data_out = data_in1;
        default: data_out = 34'bX; 
    endcase
end
endmodule
module mux2to1B(
    input [32:0] data_in0,
    input [32:0] data_in1,
    input select,
    output reg [32:0] data_out
);
always @* begin
    case (select)
        1'b0: data_out = data_in0;
        1'b1: data_out = data_in1;
        default: data_out = 33'bX; 
    endcase
end
endmodule
//===========================================================================================

module operations(
    input c7,
    input [33:0] m,
    input clk,
    input [33:0] a,
    input [2:0] cSig,
    output reg [33:0] newa
);
    wire [33:0] twoM, threeM, fourM,aux,sum3;
    wire cout, cout2, cout3;
    wire [66:0] sum;
    wire [32:0] sum2;

    obtain inst (
        .originalM(m),
        .twoM(twoM),
        .threeM(threeM),
        .fourM(fourM)
    );
    mux4to1 inst1(.data_in0(m), .data_in1(twoM), .data_in2(threeM), .data_in3(fourM), .select({cSig[1],cSig[2]}), .data_out(aux));
         CSkA CSkA_inst1 (
                    .X(32'b0),
                    .Y(32'b0),
                    .X2(33'b0),
                    .Y2(33'b0),
                    .X3(a),
                    .Y3(aux),
                    .cin(cSig[0]),
                    .cout(cout),
                    .cout2(cout2),
                    .cout3(cout3),
                    .sum(sum),
                    .sum2(sum2),
                    .sum3(sum3)
                );
             
                
mux2to1A selectFinal(.data_in0(a), .data_in1(sum3), .select(c7), .data_out(sum3));
always @(posedge clk) begin
    newa <= sum3;
end   
endmodule

//===========================================================================================

module lshift(
input c5,
input [33:0] a,
input [32:0] q,
input qNeg,
output [33:0] aOUT,
output [32:0] qOUT,
output qNegOUT
);

assign aOUT[33:31]={3{a[33]}};
assign qOUT[32:30]={a[2],a[1],a[0]};

genvar i;
generate
  for (i = 30; i >=0; i = i - 1) begin  : shift_aOUT
    assign aOUT[i] = a[i+3];
  end
  
  for (i = 29; i >=0; i = i - 1) begin : shift_qOUT
    assign qOUT[i] = q[i+3];
  end
endgenerate
mux2to1A inst1(.data_in0(a), .data_in1(aOUT), .select(c5), .data_out(aOUT));
mux2to1B inst2(.data_in0(q), .data_in1(qOUT), .select(c5), .data_out(qOUT));
assign qNegOUT=(c5&q[2])|(~c5&qNeg);
endmodule

//===========================================================================================

module counter (
    input clk,      // Clock input
    input c_up,     // Count up enable
    input rst,      // Reset input (active low)
    input clr,
    input[3:0] count_reg,
    output reg [3:0] count  // 8-bit counter output
);
// Define counter behavior
always @(posedge clk,negedge rst) begin
    if (!rst) begin
        // Reset the counter to 0 when rst is asserted (active low)
        count <= 4'd0;
    end else if (clr) begin
        // Clear the counter to 0 when clr is asserted
        count <= 4'd0;
    end else if (c_up) begin
        // Increment the counter if count up is enabled
        count <= count_reg + 1;
    end
end
endmodule

//===========================================================================================

module algorithm(
  input [33:0] m,a,
  input clk,
  input [32:0] q,
  input qNeg,
  input [3:0] cnt,
  input [8:0] cSig,
  output [33:0] newa,
  output [32:0] newq,
  output newqNeg,
  output [3:0] newcnt 
);
     operations op(.m(m), .clk(clk), .a(a), .cSig({cSig[2],cSig[3],cSig[4]}), .newa(newa), .c7(cSig[7]));
     lshift inst(.a(a), .q(q), .qNeg(qNeg), .aOUT(newa), .qOUT(newq), .qNegOUT(newqNeg), .c5(cSig[5]));
     counter inst0(.clk(clk), .c_up(cSig[5]), .rst(1'b1), .clr(cSig[0]), .count_reg(cnt), .count(newcnt));
endmodule

//===========================================================================================

module multiplier(
input [31:0] X,Y,
input clk,
input active,//formula lui OP
output reg [66:0] product
);

reg [33:0] a;
reg [32:0] q;
reg [33:0] m;
reg [3:0] counter;
reg activeREG;

wire qNeg;
wire [7:0] cSig;
wire [33:0] aAux;
wire [32:0] qAux;
wire [33:0] mAux;
wire [3:0] counterAux;
wire activeAux;

reg rst=0,sec=0;

always @(posedge clk) begin
    if(!rst) begin
    a <= 34'd0;
    counter <= 4'd0;
    q <= {X[31], X};
    m <= {{2{Y[31]}}, Y};
    activeREG <= active; 
    end
    //$display("q = %b %b" , q,rst);
end
assign activeAux=activeREG;
assign aAux=a;
assign qAux=q;
assign mAux=m;
assign counterAux=counter;

controlUnit reff1(.clk(clk), .rst_b(sec), .START(activeAux), .cnt(counterAux), .w(qAux[2]), .x(qAux[1]), .y(qAux[0]), .z(qNeg), .cSig(cSig));
//algorithm reff2(.m(mAux), .clk(clk), .a(aAux), .q(qAux), .qNeg(qNeg), .cnt(counterAux), .cSig(cSig), .newa(aAux), .newq(qAux), .newqNeg(qNeg), .newcnt(counterAux));


always @(posedge clk) begin
    a <= aAux;
    q <= qAux;
    counter <= counterAux;
    if(cSig[6])activeREG=1'b0;
    product <= {a,q};
    rst <=sec;$display("cSig=%b rst=%b %b",cSig,rst,q);
    sec=1;
end
endmodule





module multiplier_tb;
  
  reg [31:0] X,Y;
  reg clk,enable;
  wire [66:0] product;
  
  multiplier multiplier_inst (
   .X(X),.Y(Y),.clk(clk),.active(enable),.product(product)
  );

  // Stimulus
  initial begin
    // Initialize inputs
    $monitor("product = %b", product);
    X = 32'd2; // Example input value
    Y = 32'd3; // Example input value
    enable=1'b1;
    // Wait some time
    #1310;

    // End simulation
    $finish;
  end
  
localparam run_cycle=10,cycles=65;
initial begin
  clk=1'b0;
  repeat (cycles*2)
#run_cycle clk=~clk;
end
  
endmodule
