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

//==========================================================================

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

//==========================================================================

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

//==========================================================================

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

//==========================================================================

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
  output [33:0] sum3,
  output reg suff
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

suff=1;
endmodule

  



module CSkA_tb;
  
  // Inputs
  reg [31:0] X,Y;
  reg [32:0] X2,Y2;
  reg [33:0] X3,Y3;
  reg cin;
  
  // Outputs
  wire cout,cout2,cout3;
  wire [66:0] sum;
  wire [32:0] sum2;
  wire [33:0] sum3;

  // Instantiate the CSkA module
  CSkA CSkA_inst (
    .X(X),
    .Y(Y),
    .X2(X2),
    .Y2(Y2),
    .X3(X3),
    .Y3(Y3),
    .cin(cin),
    .cout(cout),
    .cout2(cout2),
    .cout3(cout3),
    .sum(sum),
    .sum2(sum2),
    .sum3(sum3)
  );

  // Stimulus
  initial begin
    // Initialize inputs
    $monitor("sum1 = %b, sum2 = %b,sum3 = %b", sum,sum2,sum3);
    X = 32'd578; // Example input value
    Y = 32'd678; // Example input value
    X2 = 33'd10; // Example input value
    Y2 = 33'd15; // Example input value
    X3 = 34'd10; // Example input value
    Y3 = 34'd15; // Example input value
    cin = 1'b1; // Example initial carry-in

    // Wait some time
    #10;

    // Print sum

    // End simulation
    $finish;
  end

endmodule
