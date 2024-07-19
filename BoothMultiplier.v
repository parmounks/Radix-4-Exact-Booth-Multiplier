module BoothMultiplier(
    input wire clk,         
    input wire reset,       
    input wire [7:0] M,     // Multiplicand input
    input wire [7:0] Q,     // Multiplier input
    output wire [15:0] Product // 16-bit product output
);

// Intermediate signals
wire [2:0] seq1, seq2, seq3, seq4;
wire [7:0] dec1, dec2, dec3, dec4;
wire sgn1, sgn2, sgn3, sgn4;
wire e1, e2, e3, e4;
wire [8:0] extended1, extended2, extended3, extended4;

// Encoder and Decoder modules
Encoder enc(
    .Q(Q),
    .seq1(seq1),
    .seq2(seq2),
    .seq3(seq3),
    .seq4(seq4)
);

Decoder dec(
    .seq1(seq1),
    .seq2(seq2),
    .seq3(seq3),
    .seq4(seq4),
    .M(M),
    .extended1(extended1),
    .extended2(extended2),
    .extended3(extended3),
    .extended4(extended4),
    .DEC1(dec1),
    .DEC2(dec2),
    .DEC3(dec3),
    .DEC4(dec4),
    .SGN1(sgn1),
    .SGN2(sgn2),
    .SGN3(sgn3),
    .SGN4(sgn4),
    .E1(e1),
    .E2(e2),
    .E3(e3),
    .E4(e4)
);

// Layer signals
wire [15:0] layer1, layer2, layer3, layer4, layer5;
wire [15:0] sum1, sum2, sum3, sum4;
wire [15:0] carry1, carry2, carry3, carry4;

// Initialize layers
assign layer1 = {4'b0, e1, ~e1, ~e1, extended1};
assign layer2 = {3'b0, 1'b1, e2, extended2, 1'b0, sgn1};
assign layer3 = {1'b0, 1'b1, e3, extended3, 1'b0, sgn2, 2'b0};
assign layer4 = {e4, extended4, 1'b0, sgn3, 4'b0};
assign layer5 = {9'b0, sgn4, 6'b0};

// First addition (layer1 + layer2)
genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin : add1
        if (i == 0) begin
            HalfAdder ha1(.A(layer1[i]), .B(layer2[i]), .SUM(sum1[i]), .CRY(carry1[i]));
        end else begin
            FullAdder fa1(.A(layer1[i]), .B(layer2[i]), .C(carry1[i-1]), .SUM(sum1[i]), .CRY(carry1[i]));
        end
    end
endgenerate

// Second addition (sum1 + layer3)
generate
    for (i = 0; i < 16; i = i + 1) begin : add2
        if (i == 0) begin
            HalfAdder ha2(.A(sum1[i]), .B(layer3[i]), .SUM(sum2[i]), .CRY(carry2[i]));
        end else begin
            FullAdder fa2(.A(sum1[i]), .B(layer3[i]), .C(carry2[i-1]), .SUM(sum2[i]), .CRY(carry2[i]));
        end
    end
endgenerate

// Third addition (sum2 + layer4)
generate
    for (i = 0; i < 16; i = i + 1) begin : add3
        if (i == 0) begin
            HalfAdder ha3(.A(sum2[i]), .B(layer4[i]), .SUM(sum3[i]), .CRY(carry3[i]));
        end else begin
            FullAdder fa3(.A(sum2[i]), .B(layer4[i]), .C(carry3[i-1]), .SUM(sum3[i]), .CRY(carry3[i]));
        end
    end
endgenerate

// Fourth addition (sum3 + layer5)
generate
    for (i = 0; i < 16; i = i + 1) begin : add4
        if (i == 0) begin
            HalfAdder ha4(.A(sum3[i]), .B(layer5[i]), .SUM(sum4[i]), .CRY(carry4[i]));
        end else begin
            FullAdder fa4(.A(sum3[i]), .B(layer5[i]), .C(carry4[i-1]), .SUM(sum4[i]), .CRY(carry4[i]));
        end
    end
endgenerate

// Assign final product
assign Product = sum4;

endmodule


