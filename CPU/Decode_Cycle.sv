module Decode_Cycle (
    input clk, rst, RegWriteW,
    input [4:0] RDW,
    input [31:0] InstrD, PCD, PCPlus4D, ResultW,

    output RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE,
    output [3:0] ALUControlE,
    output [31:0] RD1_E, RD2_E, Imm_Ext_E,
    output [4:0] RS1_E, RS2_E, RD_E,
    output [31:0] PCE, PCPlus4E,
    output [4:0] ShiftAmountE,
    output [1:0] CondE,
    output [1:0] TypeE,
    output [1:0] ShiftTypeE,
    output IndexedAddrE,
    output MemReadE, PushE, PopE
);

    // Declaración de señales internas
    wire [1:0] ImmSrcD;
    wire [3:0] ALUControlD;
    wire [31:0] RD1_D, RD2_D, Imm_Ext_D;
    wire MemReadD, PushD, PopD;

    // Extract fields
    wire [1:0] cond = InstrD[31:30];
    wire [1:0] tipo = InstrD[29:28];
    wire [2:0] opcode = InstrD[27:25];
    wire [3:0] Rd = InstrD[24:21];
    wire [3:0] Rn = InstrD[20:17];
    wire [1:0] shift_flag = InstrD[16:15];
    wire index_flag = InstrD[14];
    wire [13:0] Operando2 = InstrD[13:0];

    // Registro de señales intermedias
    reg RegWriteD_r, ALUSrcD_r, MemWriteD_r, ResultSrcD_r, BranchD_r;
    reg [3:0] ALUControlD_r;
    reg [31:0] RD1_D_r, RD2_D_r, Imm_Ext_D_r;
    reg [4:0] RD_D_r, RS1_D_r, RS2_D_r;
    reg [31:0] PCD_r, PCPlus4D_r;
    reg [4:0] ShiftAmountD_r;
    reg [1:0] CondD_r, TypeD_r, ShiftTypeD_r;
    reg IndexedAddrD_r;
    reg MemReadD_r, PushD_r, PopD_r;

    // Unidad de Control
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
        .A1(Rn),
        .A2(Rd),
        .A3(RDW),
        .RD1(RD1_D),
        .RD2(RD2_D)
    );

    // Extensión de Signo
    Sign_Extend extension (
        .In(Operando2),
        .Imm_Ext(Imm_Ext_D),
        .ImmSrc(ImmSrcD)
    );

    // Lógica de registro
    always @(posedge clk or negedge rst) begin
        if (rst == 1'b0) begin
            // Reset all registers
            RegWriteD_r <= 1'b0;
            ALUSrcD_r <= 1'b0;
            MemWriteD_r <= 1'b0;
            ResultSrcD_r <= 1'b0;
            BranchD_r <= 1'b0;
            ALUControlD_r <= 4'b0000;
            RD1_D_r <= 32'h00000000;
            RD2_D_r <= 32'h00000000;
            Imm_Ext_D_r <= 32'h00000000;
            RD_D_r <= 5'h00;
            RS1_D_r <= 5'h00;
            RS2_D_r <= 5'h00;
            PCD_r <= 32'h00000000;
            PCPlus4D_r <= 32'h00000000;
            ShiftAmountD_r <= 5'h00;
            CondD_r <= 2'b00;
            TypeD_r <= 2'b00;
            ShiftTypeD_r <= 2'b00;
            IndexedAddrD_r <= 1'b0;
            MemReadD_r <= 1'b0;
            PushD_r <= 1'b0;
            PopD_r <= 1'b0;
        end
        else begin
            // Update all registers
            RegWriteD_r <= RegWriteD;
            ALUSrcD_r <= ALUSrcD;
            MemWriteD_r <= MemWriteD;
            ResultSrcD_r <= ResultSrcD;
            BranchD_r <= BranchD;
            ALUControlD_r <= ALUControlD;
            RD1_D_r <= RD1_D;
            RD2_D_r <= RD2_D;
            Imm_Ext_D_r <= Imm_Ext_D;
            RD_D_r <= Rd;
            RS1_D_r <= Rn;
            RS2_D_r <= Rd;
            PCD_r <= PCD;
            PCPlus4D_r <= PCPlus4D;
            ShiftAmountD_r <= Operando2[4:0];
            CondD_r <= cond;
            TypeD_r <= tipo;
            ShiftTypeD_r <= shift_flag;
            IndexedAddrD_r <= index_flag;
            MemReadD_r <= MemReadD;
            PushD_r <= PushD;
            PopD_r <= PopD;
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
    assign RS1_E = RS1_D_r;
    assign RS2_E = RS2_D_r;
    assign PCE = PCD_r;
    assign PCPlus4E = PCPlus4D_r;
    assign ShiftAmountE = ShiftAmountD_r;
    assign CondE = CondD_r;
    assign TypeE = TypeD_r;
    assign ShiftTypeE = ShiftTypeD_r;
    assign IndexedAddrE = IndexedAddrD_r;
    assign MemReadE = MemReadD_r;
    assign PushE = PushD_r;
    assign PopE = PopD_r;

endmodule