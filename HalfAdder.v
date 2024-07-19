module HalfAdder(
    input A,    // MSB input
    input B,    // LSB input
    output SUM, // Summation
    output CRY  // Carry output
);

// Logic for half adder
assign SUM = A ^ B; // XOR for sum
assign CRY = A & B; // AND for carry

endmodule
