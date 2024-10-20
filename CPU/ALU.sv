module ALU(
    input [31:0] A, B,
    input [2:0] ALUControl,
    input [1:0] ShiftType,
    input [4:0] ShiftAmount,
    output reg [31:0] Result,
    output reg [3:0] Flags // N, Z, C, V
);

    wire [32:0] sum;
    wire [63:0] product;

    assign sum = (ALUControl[0]) ? (A - B) : (A + B);
    assign product = A * B;

    always @(*) begin
        case (ALUControl)
            3'b000: Result = sum[31:0]; // ADD or SUB
            3'b010: Result = A & B;     // AND
            3'b011: begin               // MOV with optional shift
                case (ShiftType)
                    2'b00: Result = B;                          // Normal MOV
                    2'b01: Result = B >> ShiftAmount;           // LSR
                    2'b10: Result = B << ShiftAmount;           // LSL
                    default: Result = B;
                endcase
            end
            3'b100: Result = A - B;     // CMP (result not used, but calculated for flags)
            3'b101: Result = (A / B);   // UDIV
            3'b111: Result = product[31:0]; // MUL
            default: Result = 32'b0;
        endcase

        // Set flags
        Flags[3] = Result[31];                          // N flag
        Flags[2] = (Result == 32'b0);                   // Z flag
        Flags[1] = sum[32];                             // C flag (from addition/subtraction)
        Flags[0] = (A[31] ^ B[31] ^ Result[31] ^ sum[32]); // V flag (overflow)
    end

endmodule