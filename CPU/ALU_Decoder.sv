module ALU_Decoder(
    input [1:0] ALUOp,             // Proviene del Main Decoder
    input [2:0] opcode,            // Opcode de la instrucción (ADD, SUB, etc.)
    input [1:0] flag_mov_shift,    // Flags MOV con Shift
    output reg [2:0] ALUControl    // Señal de control para la ALU
);

    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = 3'b000;  // Operación de carga o movimiento
            2'b01: ALUControl = 3'b001;  // Instrucciones de control de flujo (branch)
            2'b10: begin  // Operaciones REG
                case (opcode)
                    3'b000: ALUControl = 3'b010;  // ADD
                    3'b001: ALUControl = 3'b110;  // SUB
                    3'b010: ALUControl = 3'b000;  // AND
                    3'b011: ALUControl = (flag_mov_shift == 2'b00) ? 3'b011 :  // MOV normal
                                         (flag_mov_shift == 2'b01) ? 3'b100 :  // MOV con LSR
                                         (flag_mov_shift == 2'b10) ? 3'b101 :  // MOV con LSL
                                         3'b011;
                    3'b111: ALUControl = 3'b001;  // MUL
                    default: ALUControl = 3'b000; // Default
                endcase
            end
            default: ALUControl = 3'b000;  // Default
        endcase
    end

endmodule
