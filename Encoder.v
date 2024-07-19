module Encoder(
    input wire [7:0] Q,      // 8-bit input multiplier
    output wire [2:0] seq1,  
    output wire [2:0] seq2,  
    output wire [2:0] seq3,  
    output wire [2:0] seq4   // Fourth 3-bit sequence
);

// Extended Q to 9 bits
wire [8:0] extended_Q = {Q, 1'b0};

// Extract sequences
assign seq1 = extended_Q[2:0];   
assign seq2 = extended_Q[4:2];   
assign seq3 = extended_Q[6:4];   
assign seq4 = extended_Q[8:6];  

endmodule