module Execute_Cycle(
    input clk, rst,
    input RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE,
    input [3:0] ALUControlE,
    input [1:0] CondE,
    input [1:0] TypeE,
    input [1:0] ShiftTypeE,
    input [4:0] ShiftAmountE,
    input [31:0] RD1_E, RD2_E, Imm_Ext_E,
    input [4:0] RS1_E, RS2_E, RD_E,
    input [31:0] PCE, PCPlus4E,
    input [31:0] ResultW,
    input [1:0] ForwardAE, ForwardBE,

    output PCSrcE, RegWriteM, MemWriteM, ResultSrcM,
    output [4:0] RD_M, 
    output [31:0] PCPlus4M, WriteDataM, ALU_ResultM,
    output [31:0] PCTargetE,
    output [3:0] ALUFlagsE
);

    // Declaration of Interim Wires
    wire [31:0] Src_A, Src_B_interim, Src_B;
    wire [31:0] ALU_Result;
    wire [3:0] ALUFlags;
    reg ConditionPassed;  // Declare ConditionPassed as a reg
	 
    // Declaration of Registers
    reg RegWriteE_r, MemWriteE_r, ResultSrcE_r;
    reg [4:0] RD_E_r;
    reg [31:0] PCPlus4E_r, WriteDataE_r, ALU_ResultE_r;
    reg [3:0] ALUFlagsE_r;

    // Condition checking logic
    always @(*) begin
        case(CondE)
            2'b00: ConditionPassed = 1'b1; // AL
            2'b01: ConditionPassed = ALUFlags[2]; // EQ
            2'b10: ConditionPassed = !ALUFlags[2]; // NE
            2'b11: ConditionPassed = ALUFlags[3] == ALUFlags[1]; // GE
            default: ConditionPassed = 1'b0; // Default case
        endcase
    end

    // 3 by 1 Mux for Source A
    Mux_3_by_1 srca_mux (
        .a(RD1_E),
        .b(ResultW),
        .c(ALU_ResultM),
        .s(ForwardAE),
        .d(Src_A)
    );

    // 3 by 1 Mux for Source B
    Mux_3_by_1 srcb_mux (
        .a(RD2_E),
        .b(ResultW),
        .c(ALU_ResultM),
        .s(ForwardBE),
        .d(Src_B_interim)
    );
	 
    // ALU Src Mux
    Mux alu_src_mux (
        .a(Src_B_interim),
        .b(Imm_Ext_E),
        .s(ALUSrcE),
        .c(Src_B)
    );

    // ALU Unit
    ALU alu (
        .A(Src_A),
        .B(Src_B),
        .ALUControl(ALUControlE),
        .ShiftType(ShiftTypeE),
        .Type(TypeE),
        .ShiftAmount(ShiftAmountE),
        .Result(ALU_Result),
        .Flags(ALUFlags)
    );

    // Adder for branch target
    PC_Adder branch_adder (
        .a(PCE),
        .b(Imm_Ext_E),
        .c(PCTargetE)
    );

    // Register Logic
    always @(posedge clk or negedge rst) begin
        if(rst == 1'b0) begin
            RegWriteE_r <= 1'b0; 
            MemWriteE_r <= 1'b0; 
            ResultSrcE_r <= 1'b0;
            RD_E_r <= 5'h00;
            PCPlus4E_r <= 32'h00000000; 
            WriteDataE_r <= 32'h00000000; 
            ALU_ResultE_r <= 32'h00000000;
            ALUFlagsE_r <= 4'h0;
        end
        else begin
            RegWriteE_r <= RegWriteE; 
            MemWriteE_r <= MemWriteE; 
            ResultSrcE_r <= ResultSrcE;
            RD_E_r <= RD_E;
            PCPlus4E_r <= PCPlus4E; 
            WriteDataE_r <= Src_B_interim; 
            ALU_ResultE_r <= ALU_Result;
            ALUFlagsE_r <= ALUFlags;
        end
    end

    // Output Assignments
    assign PCSrcE = BranchE & ConditionPassed;
    assign RegWriteM = RegWriteE_r;
    assign MemWriteM = MemWriteE_r;
    assign ResultSrcM = ResultSrcE_r;
    assign RD_M = RD_E_r;
    assign PCPlus4M = PCPlus4E_r;
    assign WriteDataM = WriteDataE_r;
    assign ALU_ResultM = ALU_ResultE_r;
    assign ALUFlagsE = ALUFlagsE_r;

endmodule