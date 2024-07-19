module FullAdder(
    input A,    // MSB input
    input B,    // LSB input
    input C,    // Carry input
    output SUM, // Summation
    output CRY  // Carry output
);

// Logic for full adder
assign SUM = A ^ B ^ C; // XOR for sum including the carry in
assign CRY = (A & B) | (A & C) | (B & C); // OR of all AND combinations for carry out

endmodule
