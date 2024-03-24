`include "correctedAdunare.v"


module controlUnit(
input clk,rst_b,BEGIN,cnt[4:0],w,x,y,z
output cSig[7:0]
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
localparam s14=14

reg [14:0] cst;
wire [14:0] nxst;

assign nxst[s0]=(cst[s13])|(cst[s0]&(~BEGIN));
assign nxst[s1]=(cst[s0]&BEGIN);
assign nxst[s2]=(cst[s1]);
assign nxst[s3]=(cst[s2])|cst[s14];

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
assign nxst[s13]=cst[s12] & (cnt[0]&cnt[1]&cnt[2]&cnt[3]&cnt[4]);
                 
                 
assign nxst[s14]=(~nxst[s13]);

assign cSig={8{1'd0}};
assign cSig[7]= (cst[s4]) | (cst[s5]) | (cst[s6]) | (cst[s7]) | 
                 (cst[s8]) | (cst[s9]) | (cst[s10]) | (cst[s11]) ;
assign cSig[0]=cst[s1];
assign cSig[1]=cst[s2];

assign cSig[2]=cst[s5]|cst[s7]|cst[s9]|cst[s11];
assign cSig[3]=cst[s10]|cst[s8]|cst[s9]|cst[s11];
assign cSig[4]=cst[s6]|cst[s7]|cst[s10]|cst[s11];


assign cSig[5]=cst[s12];
assign cSig[6]=cst[s13];

always @(posedge clk,negedge rst_b)
if(!rst_b)begin
cst<=0;
cst[s0]<=1;
end
else
cst<=nxst;       
                 
endmodule

//===========================================================================================

module obatin(
  input originalM[33:0],
output 2mOUT[33:0],3mOUT[33:0],4mOUT[33:0]
);
wire cout,cout2,cout3;
reg sum[31:0],sum2[32:0];

assign 2mOUT=34'd0;
genvar i;
generate
  for (i = 1; i < 34; i = i + 1) begin
    assign 2mOUT[i] = originalM[i-1];
  end
endgenerate
CSkA CSkA_inst2 (
    .X(33'b0),          // Set X to zero, unused
    .Y(33'b0),          // Set Y to zero, unused
    .X2(32'b0),            // Connect X2
    .Y2(32'b0),            // Connect Y2
    .X3(2mOUT),         // Set X3 to zero, unused
    .Y3(originalM),         // Set Y3 to zero, unused
    .cin(1'b0),
    .cout(cout),
    .cout2(cout2),
    .cout3(cout3),
    .sum(sum),
    .sum2(sum2),
    .sum3(3mOUT)
);
assign 4mOUT=34'd0;
genvar i;
generate
  for (i = 1; i < 34; i = i + 1) begin
    assign 4mOUT[i] = 2mOUT[i-1];
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

//===========================================================================================

module operations(
    input [33:0] m,
    input clk,
    input [33:0] a,
    input [2:0] cSig,
    output reg [33:0] newa
);
    reg [33:0] 2m, 3m, 4m,aux;
    wire cout, cout2, cout3;
    reg [31:0] sum;
    reg [32:0] sum2;

    obtain inst (
        .originalM(m),
        .2mOUT(2m),
        .3mOUT(3m),
        .4mOUT(4m)
    );
    mux4to1 inst1(.data_in0(m), .data_in1(2m), .data_in2(3m), .data_in3(4m), .select({cSig[1],cSig[2]}), .data_out(aux));
         CSkA CSkA_inst1 (
                    .X(33'b0),
                    .Y(33'b0),
                    .X2(32'b0),
                    .Y2(32'b0),
                    .X3(a),
                    .Y3(aux),
                    .cin(cSig[0]),
                    .cout(cout),
                    .cout2(cout2),
                    .cout3(cout3),
                    .sum(sum),
                    .sum2(sum2),
                    .sum3(newa)
                );
endmodule

//===========================================================================================

module rshift(
input [33:0] a,
input [32:0] q,
input qNeg,
output [33:0] aOUT,
output [32:0] qOUT,
output qNegOUT,
);
reg in[2:0],out[2:0];

assign in={3{a[33]}};
assign out={a[2],a{1},a{0}};

genvar i;
generate
  for (i = 30; i >=0; i = i - 1) begin
    assign aOUT[i] = a[i+3];
  end
  assign aOUT[33:31]=in;
  for (i = 30; i >=0; i = i - 1) begin
    assign qOUT[i] = q[i+3];
  end
  assign qOUT[33:31]=out;
  assign qNegOUT=q[2];
endgenerate
endmodule

//===========================================================================================

module counter (
    input clk,      // Clock input
    input c_up,     // Count up enable
    input rst,      // Reset input (active low)
    input clr,
    input[4:0] count_reg,
    output reg [4:0] count  // 8-bit counter output
);
// Define counter behavior
always @(posedge clk,negedge rst) begin
    if (!rst) begin
        // Reset the counter to 0 when rst is asserted (active low)
        count_reg <= 5'b0;
    end else if (clr) begin
        // Clear the counter to 0 when clr is asserted
        count_reg <= 5'b0;
    end else if (c_up) begin
        // Increment the counter if count up is enabled
        count_reg <= count_reg + 1;
    end
end

// Output the counter value
assign count = count_reg;

endmodule

//===========================================================================================

module algorithm(
  input m[33:0],clk
  input a[33:0],q[32:0],qNeg
  input cnt[4:0],cSig[7:0],
  output newa[33:0],newq[32:0],newqNeg,newcnt[4:0] 
);
always @(posedge clk) begin
   if(cSig[7])begin
     operations op(.m(m), .clk(clk), .a(a), .cSig({cSig[2],cSig[3],cSig[4]}), .newa(newa));
   end
 else
     if(cSig[0])begin
       newa=34'b0;counter inst0(.clk(clk), .c_up(1'b0), .rst_b(1'b1), .clr(1'b1), .count_reg(cnt), .count(cnt));
     end
   else
     if(cSig[1])begin
       qNeg=1'b0;
     end
   else
     if(cSig[5])begin
       lshift inst(.a(a), .q(q), .qNeg(qNeg), .aOUT(newa), .qOUT(newq), .qNegOUT(newqNeg));
       counter inst0(.clk(clk), .c_up(1'b1), .rst_b(1'b1), .clr(1'b0), .count_reg(cnt), .count(cnt));
     end
end
endmodule

//===========================================================================================

module multiplier(
input X[31:0],Y[31:0],clk,rst_b
input active,//formula lui OP
output product[66:0]
);

reg a[33:0],q[32:0],qNeg,m[34:0]; 
reg cSig[7:0];
reg counter[4:0];

assign q={X[31],X};
assign m={2{Y[31]},Y};

always &(posedge clk) begin
controlUnit reff(.clk(clk), .rst_b(rst_b), .BEGIN(active) ,.cnt(counter) ,.w(q[2]), .x(q[1]), .y(q[0]), .z(qNeg), .cSig(cSig));
algorithm reff2(.m(m), .clk(clk), .a(a), .q(q), .qNeg(qNeg), .cnt(counter), .cSig(cSig), .newa(a), .newq(q), .newqNeg(qNeg), .newcnt(counter));
assign product={a,q};
if(cSig[6])
  assign active=1'b0;
end
endmodule








