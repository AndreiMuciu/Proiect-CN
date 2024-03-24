module RCA(
  input[7:0] A,
  input[7:0] B,
  input cin,
  output[7:0] sum,
  output cout
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

endmodule

module FAC(
  input A,
  input B,
  input cin,
  output sum,
  output cout
);
assign sum = A ^ B ^ cin;
assign cout = (A & B) | (cin & (A ^ B));

endmodule

module RCA_Star(
  input[7:0] A,
  input[7:0] B,
  input ci,
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
FAC_Star FAS7 (.A(A[7]), .B(B[7]), .cin(carry[6]), .sum(sum[7]), .cout(cout), .pi(propafate[7]));

assign pi = propagate[0] & propagate[1] & propagate[2] & propagate[3] & propagate[4] & propagate[5] & propagate[6] & propagate[7];
endmodule

module FAC_Star(
  input A,
  input B,
  input ci,
  output sum,
  output cout,
  output pi
  );
  
  assign sum = A ^ B ^ ci;
  assign cout = (A & B) | (ci & (A ^ B));
  assign pi =A ^ B
  
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

//pt 32b
wire carry[2:0],Propagate1,Propagate2;
wire[31:0] Y_xor_cin;

// XOR between Y and cin
genvar i;
generate
  for (i = 0; i < 32; i = i + 1) begin
    assign Y_xor_cin[i] = Y[i] ^ cin;
  end
endgenerate

// Assign Y_xor_cin back to Y
genvar j;
generate
  for (j = 0; j < 32; j = j + 1) begin
    assign Y[j] = Y_xor_cin[j];
  end
endgenerate

RCA RCA0(.A(X[7:0]), .B(Y[7:0]), .cin(cin), .sum(sum[7:0]), .cout(carry[0]));
RCA_Star RCA1(.A(X[15:8]), .B(Y[15:8]), .cin(carry[0]), .sum(sum[15:8]), .cout(carry[1]), .pi(Propagate1));
RCA_Star RCA2(.A(X[16:23]), .B(Y[16:23]), .cin(carry[1]|(Propagate1 & carry[0])), .sum(sum[15:8]), .cout(carry[2]), .pi(Propagate2));
RCA RCA3(.A(X[24:31]), .B(Y[24:31]), .cin(carry[2]|(Propagate2 & carry[1])), .sum(sum[31:24]), .cout(cout));





   
//pt 33b
wire 2carry[2:0],2Propagate1,2Propagate2;
wire[32:0] Y2_xor_cin,auxcout;

// XOR between Y and cin
genvar i;
generate
  for (i = 0; i <33; i = i + 1) begin
    assign Y2_xor_cin[i] = Y2[i] ^ cin;
  end
endgenerate

// Assign Y_xor_cin back to Y
genvar j;
generate
  for (j = 0; j < 33; j = j + 1) begin
    assign Y2[j] = Y2_xor_cin[j];
  end
endgenerate

RCA RCA0(.A(X2[7:0]), .B(Y2[7:0]), .cin(cin), .sum(sum2[7:0]), .cout(2carry[0]));
RCA_Star RCA1(.A(X2[15:8]), .B(Y2[15:8]), .cin(2carry[0]), .sum(sum2[15:8]), .cout(2carry[1]), .pi(2Propagate1));
RCA_Star RCA2(.A(X2[16:23]), .B(Y2[16:23]), .cin(2carry[1]|(2Propagate1 & 2carry[0])), .sum(sum2[15:8]), .cout(2carry[2]), .pi(2Propagate2));
RCA RCA3(.A(X2[24:31]), .B(Y2[24:31]), .cin(2carry[2]|(2Propagate2 & 2carry[1])), .sum(sum2[31:24]), .cout(auxcout));
FAC FAC1(.A(X2[32]), .B(Y2[32]), .cin(auxcout), .sum(sum3[32]), .cout(cout2));




   
//pt 34b
wire 3carry[2:0],3Propagate1,3Propagate2;
wire[33:0] Y3_xor_cin,auxcout1,auxcout2;

// XOR between Y and cin
genvar i;
generate
  for (i = 0; i <34; i = i + 1) begin
    assign Y3_xor_cin[i] = Y3[i] ^ cin;
  end
endgenerate

// Assign Y_xor_cin back to Y
genvar j;
generate
  for (j = 0; j < 34; j = j + 1) begin
    assign Y3[j] = Y3_xor_cin[j];
  end
endgenerate

RCA RCA0(.A(X3[7:0]), .B(Y3[7:0]), .cin(cin), .sum(sum3[7:0]), .cout(3carry[0]));
RCA_Star RCA1(.A(X3[15:8]), .B(Y3[15:8]), .cin(3carry[0]), .sum(sum3[15:8]), .cout(3carry[1]), .pi(3Propagate1));
RCA_Star RCA2(.A(X3[16:23]), .B(Y3[16:23]), .cin(3carry[1]|(3Propagate1 & 3carry[0])), .sum(sum3[15:8]), .cout(3carry[2]), .pi(3Propagate2));
RCA RCA3(.A(X3[24:31]), .B(Y3[24:31]), .cin(3carry[2]|(3Propagate2 & 3carry[1])), .sum(sum3[31:24]), .cout(auxcout1));
FAC FAC1(.A(X3[32]), .B(Y3[32]), .cin(auxcout1), .sum(sum3[32]), .cout(auxcout2));
FAC FAC1(.A(X3[33]), .B(Y3[33]), .cin(auxcout2), .sum(sum3[33]), .cout(cout3));
   

 



   



   
//puneti restu de biti la sum [32:66] ,cu : duplicati ultimu bit din x(MSB) si ult bit din y(MSB) de inca 35 de ori si faceti suma cu utlimul carry(cout) si rezultatul punet il in sum[32:66] 
//in modu asta se va pastra semnul rezulatului ,verificati pe foaie sa vedeti ;)
//incercati sa o testati
endmodule
  
