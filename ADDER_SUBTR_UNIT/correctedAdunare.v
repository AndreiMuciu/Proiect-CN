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
  input[31:0] X,
  input[31:0] Y,
  input cin,
  output cout,
  output[66:0] sum
);

wire carry[2:0],Propagate1,Propagate2;

RCA RCA0(.A(X[7:0]), .B(Y[7:0]), .cin(cin), .sum(sum[7:0]), .cout(carry[0]));
RCA_Star RCA1(.A(X[15:8]), .B(Y[15:8]), .cin(carry[0]), .sum(sum[15:8]), .cout(carry[1]), .pi(Propagate1));
RCA_Star RCA2(.A(X[16:23]), .B(Y[16:23]), .cin(carry[1]|(Propagate1 & carry[0])), .sum(sum[15:8]), .cout(carry[2]), .pi(Propagate2));
RCA RCA3(.A(X[24:31]), .B(Y[24:31]), .cin(carry[2]|(Propagate2 & carry[1])), .sum(sum[31:24]), .cout(cout));
//puneti restu de biti la sum [32:66] ,cu : duplicati ultimu bit din x(MSB) si ult bit din y(MSB) de inca 35 de ori si faceti suma cu utlimul carry(cout) si rezultatul punet il in sum[32:66] 
//in modu asta se va pastra semnul rezulatului ,verificati pe foaie sa vedeti ;)
//incercati sa o testati

endmodule
  
