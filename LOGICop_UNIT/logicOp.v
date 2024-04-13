module and_op(
    input [31:0] a,
    input [31:0] b,
    output [66:0] c
);
wire [66:0] aux;
genvar i;
generate 
    for(i = 0; i < 32; i = i + 1) begin
        assign aux[i] = a[i] & b[i];
    end
    for(i = 32; i < 67; i = i + 1) begin
        assign aux[i] = 0;
    end
endgenerate
assign c = aux;
endmodule

module xor_op(
    input [31:0] a,
    input [31:0] b,
    output [66:0] c
);
wire [66:0] aux;
genvar i;
generate 
    for(i = 0; i < 32; i = i + 1) begin
        assign aux[i] = a[i] ^ b[i];
    end
    for(i = 32; i < 67; i = i + 1) begin
        assign aux[i] = 0;
    end
endgenerate
assign c = aux;
endmodule

module or_op(
    input [31:0] a,
    input [31:0] b,
    output [66:0] c
);
wire [66:0] aux;
genvar i;
generate 
    for(i = 0; i < 32; i = i + 1) begin
        assign aux[i] = a[i] | b[i];
    end
    for(i = 32; i < 67; i = i + 1) begin
        assign aux[i] = 0;
    end
endgenerate
assign c = aux;
endmodule


module op_tb;
reg [31:0] x1, y1, x2, y2, x3, y3;
wire [66:0] rez1, rez2, rez3;

and_op inst1(.a(x1), .b(y1), .c(rez1));
or_op inst2(.a(x2), .b(y2), .c(rez2));
xor_op inst3(.a(x3), .b(y3), .c(rez3));

initial begin
    // Seteaz? valorile pentru x1, y1, x2, y2, x3 ?i y3
    x1 = 32'b00000000000000001111111111111111;
    y1 = 32'b11111111111111110000000000000000;
    x2 = 32'b00000000000000001111111111111111;
    y2 = 32'b11111111111111110000000000000000;
    x3 = 32'b00000000000000001111111111111111;
    y3 = 32'b11111111111111110000000000000000;

    // Afi?eaz? valorile rezultate
    $display("AND: rez1 = %b", rez1);
    $display("OR: rez2 = %b", rez2);
    $display("XOR: rez3 = %b", rez3);
end
endmodule