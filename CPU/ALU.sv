module ALU(
    input [31:0] A, B,
    input [3:0] ALUControl,
    input [1:0] ShiftType,
    input [1:0] Type,
    input [4:0] ShiftAmount,
    output reg [31:0] Result,
    output reg [3:0] Flags
);
    wire [31:0] shifted_B;
    
    // Shift logic
    assign shifted_B = (ShiftType == 2'b01) ? B >> ShiftAmount :
                       (ShiftType == 2'b10) ? B << ShiftAmount : B;
    always @(*) begin
        // Default values
        Result = 32'b0;
        Flags = 4'b0000;
        case(Type)
            2'b00: begin // REG type
                case(ALUControl)
                    4'b0000: Result = A + B;
                    4'b0001: Result = A - B;
                    4'b0010: Result = A & B;
                    4'b0011: Result = shifted_B; // MOV with shift
                    4'b0100: begin // CMP
                        {Flags[3], Flags[2], Flags[1], Flags[0]} = {(A > B), (A == B), 1'b0, 1'b0};
                        Result = A - B; // For flag calculation
                    end
                    4'b0101: Result = (B != 0) ? A / B : 32'hFFFFFFFF; // UDIV
                    4'b0110: begin // SUBS
                        {Result, Flags} = A - B;
                        Flags[3] = (A > B);
                        Flags[2] = (A == B);
                    end
                    4'b0111: Result = A * B; // MUL
                    4'b1000: Result = B >> A[4:0]; // LSR
                    4'b1001: Result = B << A[4:0]; // LSL
                endcase
            end
            2'b01: begin // IMM type
                case(ALUControl)
                    4'b0000: Result = A + B;
                    4'b0001: Result = A - B;
                    4'b0010: Result = A & B;
                    4'b0011: Result = B; // MOV
                    4'b0100: begin // CMP
                        {Flags[3], Flags[2], Flags[1], Flags[0]} = {(A > B), (A == B), 1'b0, 1'b0};
                        Result = A - B; // For flag calculation
                    end
                    4'b1001: Result = A << B[4:0]; // LSL
                endcase
            end
            2'b10: begin // MEM type
                Result = A + B; // Address calculation for LDR, LDRB, STR, STRB
            end
            2'b11: begin // CTRL type
                Result = A + B; // For branch target calculation
            end
        endcase
        // Update flags for arithmetic operations
        if (ALUControl == 4'b0000 || ALUControl == 4'b0001 || ALUControl == 4'b0110 || ALUControl == 4'b0111) begin
            Flags[3] = (Result > A);
            Flags[2] = (Result == 0);
            Flags[1] = Result[31];
            // Carry flag logic would go here if needed
        end
    end
endmodule