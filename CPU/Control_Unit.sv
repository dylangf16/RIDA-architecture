module Control_Unit(
    input [1:0] cond,    // Condición
    input [1:0] tipo,    // Tipo (REG, IMM, MEM, CTRL)
    input [2:0] opcode,  // Opcode
    input [1:0] flag_mov_shift,  // Flags adicionales (MOV con Shift)
    output RegWrite, ALUSrc, MemWrite, ResultSrc, Branch,
    output [1:0] ImmSrc,
    output [2:0] ALUControl
);

	Main_Decoder Main_Decoder(
        .tipo(tipo),
        .opcode(opcode),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUOp)
    );
	 
	 ALU_Decoder ALU_Decoder(
        .ALUOp(ALUOp),
        .opcode(opcode),
        .flag_mov_shift(flag_mov_shift),
        .ALUControl(ALUControl)
    );
	 
endmodule