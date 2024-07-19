module Decoder(
    input wire [2:0] seq1,  // First 3-bit sequence 
    input wire [2:0] seq2,  // Second 3-bit sequence 
    input wire [2:0] seq3,  // Third 3-bit sequence 
    input wire [2:0] seq4,  // Fourth 3-bit sequence
    input wire [7:0] M,     // Multiplicand input

    output reg [8:0] extended1,
    output reg [8:0] extended2,
    output reg [8:0] extended3,
    output reg [8:0] extended4,
    output reg [7:0] DEC1, 
    output reg [7:0] DEC2, // Decoded output for sequence 2
    output reg [7:0] DEC3, 
    output reg [7:0] DEC4, 
    output reg SGN1,      
    output reg SGN2,       
    output reg SGN3,       
    output reg SGN4,       
    output reg E1,         // E value for sequence 1
    output reg E2,       
    output reg E3,         
    output reg E4          
);

wire multiplicand_sign = M[7]; 

// Decoder logic applied to each sequence
always @(*) assign_operation(seq1, M, DEC1, SGN1, E1, extended1);
always @(*) assign_operation(seq2, M, DEC2, SGN2, E2, extended2);
always @(*) assign_operation(seq3, M, DEC3, SGN3, E3, extended3);
always @(*) assign_operation(seq4, M, DEC4, SGN4, E4, extended4);

task assign_operation(
    input [2:0] seq,
    input [7:0] multiplicand,
    output [7:0] dec,
    output sgn,
    output e,
    output [8:0] extended
);
    begin
        case (seq)
            3'b000: begin
                dec = 8'b0; sgn = 0; e = 1; // E is always 1 for 000
                extended = 9'b0; // Extended value for 000
            end
            3'b111: begin
                dec = 8'b0; sgn = 0; e = 1; // E is always 1 for 111
                extended = 9'b0; // Extended value for 111
            end
            default: begin
                case (seq)
                    3'b001, 3'b010: begin 
                        dec = multiplicand; sgn = 0;
                        if (multiplicand[7] == 0) 
                            extended = {1'b0, dec};
                        else 
                            extended = {1'b1, dec};
                    end         // +M
                    3'b011: begin 
                        dec = multiplicand << 1; sgn = 0;
                        if (multiplicand[7] == 0) 
                            extended = {1'b0, dec};
                        else 
                            extended = {1'b1, dec};
                    end                // +2M
                    3'b100: begin 
                        dec = (~multiplicand << 1) | 8'b1; sgn = 1;
                        if (multiplicand[7] == 0) 
                            extended = {1'b1, dec};
                        else 
                            extended = {1'b0, dec};
                    end               // -2M
                    3'b101, 3'b110: begin 
                        dec = ~multiplicand ; sgn = 1;
                        if (multiplicand[7] == 0) 
                            extended = {1'b1, dec};
                        else 
                            extended = {1'b0, dec};
                    end       // -M
                endcase
                // E = M_sign XNORing sgn 
                e = ~(multiplicand_sign ^ sgn);
            end
        endcase
    end
endtask
endmodule
