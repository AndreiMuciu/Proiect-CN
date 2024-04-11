module mux9to1(
    input [66:0] data_in0,
    input [66:0] data_in1,
    input [66:0] data_in2,
    input [66:0] data_in3,
    input [66:0] data_in4,
    input [66:0] data_in5,
    input [66:0] data_in6,
    input [66:0] data_in7,
    input [66:0] data_in8,
    input [4:0] select,
    input [3:0] suff,
    output reg [66:0] data_out
);
always @* begin
    case (select)
        5'd1: if(suff[0])
        data_out = data_in0;
        else data_out = 34'd0
        
        5'd2: if(suff[0])
        data_out = data_in1;
        else data_out = 34'd0
        
        5'd3: if(suff[1])
        data_out = data_in2;
        else data_out = 34'd0
        
        5'd4: if(suff[2])
        data_out = data_in3;
        else data_out = 34'd0
        
        5'd5: if(suff[3])
        data_out = data_in4;
        else data_out = 34'd0
        
        5'd6: if(suff[3])
        data_out = data_in5;
        else data_out = 34'd0
        
        5'd7: if(suff[3])
        data_out = data_in6;
        else data_out = 34'd0
        
        5'd8: if(suff[3])
        data_out = data_in7;
        else data_out = 34'd0
        
        5'd9: if(suff[3])
        data_out = data_in8;
        else data_out = 34'd0
        
        default: data_out = 67'd0; // Handle invalid select values
    endcase
end
endmodule

module ArithmeticLogicUnit(
input clk,
input [4:0] op,
input [31:0] X,Y
output reg [66:0] result,
output reg [32:0] remainder 
);

wire [66:0] resultAux;
wire [32:0] remainder;
wire [32:0] sum2;
wire [33:0] sum3;
wire suff1,suff2,suff3,suff4;

wire cout,cout2,cout3;
wire [66:0] adderSubtrUNIT,productUNIT,dividerUNIT;
wire [66:0] shiftedR,shiftedL,andOp,orOp,xorOp;

CSkA CSkA_inst (
    .X(X), 
    .Y(Y),
    .X2(33'd0),
    .Y2(33'd0),
    .X3(34'd0),
    .Y3(34'd0),
    .cin(~op[4]&~op[3]&~op[2]&op[1]&~op[0]),
    .cout(cout),
    .cout2(cout2),
    .cout3(cout3),
    .sum(adderSubtrUNIT),
    .sum2(sum2),
    .sum3(sum3),
    .suff(suff1)
  );
  
  multiplier multiplier_inst(
   .X(X),.Y(Y),.clk(clk),.active(~op[4]&~op[3]&~op[2]&op[1]&op[0]),.product(productUNIT),.suff(suff2)
  );
  
  divider divider_inst(
   .X(X),.Y(Y),.clk(clk),.active(~op[4]&~op[3]&op[2]&~op[1]&~op[0]),.quatient(dividerUNIT),.remainder(remainder),.suff(suff3)
  );

  logicOp logic_inst(
     .X(X),.Y(Y), .shiftedR(shiftedR), .shiftedL(shiftedL), .andOp(andOp), .orOp(orOp), .xorOp(xorOp), .suff(suff4)
  );
  
  

always @(posedge clk) begin

end


endmodule
