module Main_Decoder(
    input [1:0] tipo,        // Tipo de operación (REG, IMM, MEM, CTRL)
    input [2:0] opcode,      // Opcode (ADD, SUB, LDR, etc.)
    output RegWrite, ALUSrc, MemWrite, ResultSrc, Branch,
    output [1:0] ImmSrc, ALUOp
);

    // Decodificación basada en el tipo de operación
    assign RegWrite = (tipo == 2'b00 || tipo == 2'b01) ? 1'b1 : 1'b0;  // REG o IMM

    // Control de ALUSrc: Usar inmediato si es tipo IMM o MEM
    assign ALUSrc = (tipo == 2'b01 || tipo == 2'b10) ? 1'b1 : 1'b0;

    // Control de MemWrite: Solo operaciones de MEM (tipo MEM y opcode correspondiente)
    assign MemWrite = (tipo == 2'b10 && (opcode == 3'b010 || opcode == 3'b011)) ? 1'b1 : 1'b0;

    // Control de ResultSrc: Usar memoria para LDR
    assign ResultSrc = (tipo == 2'b10 && (opcode == 3'b000 || opcode == 3'b001)) ? 1'b1 : 1'b0;

    // Control de Branch: Solo para instrucciones de control de flujo (tipo CTRL)
    assign Branch = (tipo == 2'b11 && opcode == 3'b000) ? 1'b1 : 1'b0;

    // Control de ImmSrc basado en tipo
    assign ImmSrc = (tipo == 2'b10) ? 2'b01 :  // MEM
                    (tipo == 2'b11) ? 2'b10 :  // CTRL
                                     2'b00;    // Default

    // Asignación de ALUOp
    assign ALUOp = (tipo == 2'b00) ? 2'b10 :   // Operaciones REG
                   (tipo == 2'b11) ? 2'b01 :   // Instrucciones de Branch
                                    2'b00;    // Default

endmodule
