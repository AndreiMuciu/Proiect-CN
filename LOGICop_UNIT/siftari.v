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
            assign aux[i] = 0; // Această linie setează explicit biții superiori pe zero. Poate dorești o funcționalitate diferită?
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

module lshift(
  input wire clk,
  input wire[31:0] data,
  output reg[66:0] o
);
initial o = 67'b0;
always@(posedge clk) begin
    o<=data<<1;
end
endmodule

module rshift(
  input wire clk,
  input wire[31:0] data,
  output reg[66:0] o
);
initial o = 67'b0;
always@(posedge clk) begin
    o<=data>>1;
end
endmodule

module op_tb;

    // Declarațiile pentru intrări și ieșiri
    reg [31:0] x1, y1, x2, y2, x3, y3;
    wire [66:0] rez1, rez2, rez3;

    // Instantierea modulelor
    and_op inst1 (.a(x1), .b(y1), .c(rez1));
    or_op inst2 (.a(x2), .b(y2), .c(rez2));
    xor_op inst3 (.a(x3), .b(y3), .c(rez3));

    // Bloc initial pentru setarea intrărilor și afișarea ieșirilor
    initial begin
        // Inițializarea valorilor pentru x1, y1, x2, y2, x3 și y3
        x1 = 32'b00000000000000001111111111111111;
        y1 = 32'b11111111111111110000000000000000;
        x2 = 32'b00000000000000001111111111111111;
        y2 = 32'b11111111111111110000000000000000;
        x3 = 32'b00000000000000001111111111111111;
        y3 = 32'b11111111111111111000000000000000;

        // Afișează valorile rezultate după o perioadă de așteptare
        #10;  // Așteaptă 10 ns pentru a permite propagarea semnalelor
        $display("AND: rez1 = %b", rez1);
        $display("OR: rez2 = %b", rez2);
        $display("XOR: rez3 = %b", rez3);

        // Terminarea simulării
        #10;  // Așteaptă încă 10 ns înainte de a termina simularea
        $finish;
    end

endmodule

`timescale 1ns / 1ps

module testbench;

    reg clk;
    reg [31:0] data;
    wire [66:0] out_lshift;
    wire [66:0] out_rshift;

    // Instanțierea modulelor
    lshift shift_left(.clk(clk), .data(data), .o(out_lshift));
    rshift shift_right(.clk(clk), .data(data), .o(out_rshift));

    // Generarea semnalului de ceas
    initial clk = 0;
    
    always #10 clk = !clk;  // Ceas cu periodă de 20ns

    // Blocul initial pentru testare
    initial begin
        data = 32'hA5A5A5A5;  // Valoare inițială de test
        #5;  // Așteaptă 5ns pentru a sincroniza cu frontul pozitiv al ceasului
        #100;  // Așteaptă 100ns pentru a permite mai multe cicluri de ceas

        data = 32'hFFFFFFFF;  // Schimbă valoarea datelor
        #50;  // Mai multe cicluri de ceas

        $finish;  // Termină simularea
    end

    // Monitorizează ieșirile
    initial begin
        $monitor("Time = %t, Data = %b, LShift Out = %b, RShift Out = %b",
                 $time, data, out_lshift, out_rshift);
    end

endmodule
