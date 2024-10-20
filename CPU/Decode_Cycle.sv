module Decode_Cycle (
    input clk, rst, RegWriteW,
    input [4:0] RDW,
    input [31:0] InstrD, PCD, PCPlus4D, ResultW,

    output RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE,
    output [2:0] ALUControlE,
    output [31:0] RD1_E, RD2_E, Imm_Ext_E,
    output [4:0] RS1_E, RS2_E, RD_E,
    output [31:0] PCE, PCPlus4E
);

    // Declaración de señales internas
    wire RegWriteD, ALUSrcD, MemWriteD, ResultSrcD, BranchD;
    wire [1:0] ImmSrcD;
    wire [2:0] ALUControlD;
    wire [31:0] RD1_D, RD2_D, Imm_Ext_D;

    // Registro de señales intermedias
    reg RegWriteD_r, ALUSrcD_r, MemWriteD_r, ResultSrcD_r, BranchD_r;
    reg [2:0] ALUControlD_r;
    reg [31:0] RD1_D_r, RD2_D_r, Imm_Ext_D_r;
    reg [4:0] RD_D_r, RS1_D_r, RS2_D_r;
    reg [31:0] PCD_r, PCPlus4D_r;

    // Declarar nuevas señales según el formato del ISA
    wire [1:0] cond;          // 2 bits: Condición
    wire [1:0] tipo;          // 2 bits: Tipo
    wire [2:0] opcode;        // 3 bits: Opcode
    wire [3:0] Rd, Rn;        // 4 bits cada uno: Rd y Rn
    wire [1:0] flag_mov_shift;// 2 bits: Flag MOV con Shift
    wire flag_mem_index;      // 1 bit: Flag de Índice de Memoria
    wire [13:0] Operando2;    // 14 bits: Operando2

// Extraer las señales del opcode
assign cond = InstrD[31:30];                // Bits 31:30 - Condición
assign tipo = InstrD[29:28];                // Bits 29:28 - Tipo
assign opcode = InstrD[27:25];              // Bits 27:25 - Opcode
assign Rd = InstrD[24:21];                  // Bits 24:21 - Rd
assign Rn = InstrD[20:17];                  // Bits 20:17 - Rn
assign flag_mov_shift = InstrD[16:15];      // Bits 16:15 - Flag MOV con Shift
assign flag_mem_index = InstrD[14];         // Bit 14 - Flag de Índice de Memoria
assign Operando2 = InstrD[13:0];            // Bits 13:0 - Operando2

// Iniciar los módulos
// Unidad de Control (ajustada para la nueva ISA)
Control_Unit control (
    .cond(cond),               // Condición (Bits 31:30)
    .tipo(tipo),               // Tipo de instrucción (Bits 29:28)
    .opcode(opcode),           // Opcode (Bits 27:25)
    .flag_mov_shift(flag_mov_shift),  // Flag MOV con Shift (Bits 16:15)
    .RegWrite(RegWriteD),      // Señal de escritura en registro
    .ImmSrc(ImmSrcD),          // Fuente del inmediato
    .ALUSrc(ALUSrcD),          // Selección de ALU fuente (registro o inmediato)
    .MemWrite(MemWriteD),      // Señal de escritura en memoria
    .ResultSrc(ResultSrcD),    // Fuente del resultado (ALU o memoria)
    .Branch(BranchD),          // Señal de branch (salto)
    .ALUControl(ALUControlD)   // Control de la ALU
);


    // Archivo de Registros
    Register_File rf (
        .clk(clk),
        .rst(rst),
        .WE3(RegWriteW),
        .WD3(ResultW),
        .A1(Rn),    // Usamos Rn en lugar de InstrD[19:15]
        .A2(Rd),    // Usamos Rd en lugar de InstrD[24:20]
        .A3(RDW),
        .RD1(RD1_D),
        .RD2(RD2_D)
    );

    // Extensión de Signo (aún sin cambios, se ajustará si es necesario)
    Sign_Extend extension (
        .In({18'b0, Operando2}),  // Solo extendemos los 14 bits de Operando2
        .Imm_Ext(Imm_Ext_D),
        .ImmSrc(ImmSrcD)
    );

    // Lógica de registro
    always @(posedge clk or negedge rst) begin
        if (rst == 1'b0) begin
            RegWriteD_r <= 1'b0;
            ALUSrcD_r <= 1'b0;
            MemWriteD_r <= 1'b0;
            ResultSrcD_r <= 1'b0;
            BranchD_r <= 1'b0;
            ALUControlD_r <= 3'b000;
            RD1_D_r <= 32'h00000000;
            RD2_D_r <= 32'h00000000;
            Imm_Ext_D_r <= 32'h00000000;
            RD_D_r <= 5'h00;
            PCD_r <= 32'h00000000;
            PCPlus4D_r <= 32'h00000000;
            RS1_D_r <= 5'h00;
            RS2_D_r <= 5'h00;
        end
        else begin
            RegWriteD_r <= RegWriteD;
            ALUSrcD_r <= ALUSrcD;
            MemWriteD_r <= MemWriteD;
            ResultSrcD_r <= ResultSrcD;
            BranchD_r <= BranchD;
            ALUControlD_r <= ALUControlD;
            RD1_D_r <= RD1_D;
            RD2_D_r <= RD2_D;
            Imm_Ext_D_r <= Imm_Ext_D;
            RD_D_r <= Rd;          // Usamos Rd en lugar de InstrD[11:7]
            PCD_r <= PCD;
            PCPlus4D_r <= PCPlus4D;
            RS1_D_r <= Rn;         // Usamos Rn en lugar de InstrD[19:15]
            RS2_D_r <= Rd;         // Usamos Rd en lugar de InstrD[24:20]
        end
    end

    // Asignación de salidas
    assign RegWriteE = RegWriteD_r;
    assign ALUSrcE = ALUSrcD_r;
    assign MemWriteE = MemWriteD_r;
    assign ResultSrcE = ResultSrcD_r;
    assign BranchE = BranchD_r;
    assign ALUControlE = ALUControlD_r;
    assign RD1_E = RD1_D_r;
    assign RD2_E = RD2_D_r;
    assign Imm_Ext_E = Imm_Ext_D_r;
    assign RD_E = RD_D_r;
    assign PCE = PCD_r;
    assign PCPlus4E = PCPlus4D_r;
    assign RS1_E = RS1_D_r;
    assign RS2_E = RS2_D_r;

endmodule
