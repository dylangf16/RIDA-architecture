`timescale 1ns / 1ps

module Execute_Cycle_tb;

    // Inputs
    reg clk;
    reg rst;
    reg RegWriteE;
    reg ALUSrcE;
    reg MemWriteE;
    reg ResultSrcE;
    reg BranchE;
    reg [2:0] ALUControlE;
    reg [1:0] ShiftTypeE;
    reg [4:0] ShiftAmountE;
    reg [31:0] RD1_E;
    reg [31:0] RD2_E;
    reg [31:0] Imm_Ext_E;
    reg [4:0] RS1_E;
    reg [4:0] RS2_E;
    reg [4:0] RD_E;
    reg [31:0] PCE;
    reg [31:0] PCPlus4E;
    reg [31:0] ResultW;
    reg [1:0] ForwardA_E;
    reg [1:0] ForwardB_E;

    // Outputs
    wire PCSrcE;
    wire RegWriteM;
    wire MemWriteM;
    wire ResultSrcM;
    wire [4:0] RD_M;
    wire [31:0] PCPlus4M;
    wire [31:0] WriteDataM;
    wire [31:0] ALU_ResultM;
    wire [31:0] PCTargetE;
    wire [3:0] ALUFlagsE;

    // Instantiate the Execute_Cycle module
    Execute_Cycle dut (
        .clk(clk),
        .rst(rst),
        .RegWriteE(RegWriteE),
        .ALUSrcE(ALUSrcE),
        .MemWriteE(MemWriteE),
        .ResultSrcE(ResultSrcE),
        .BranchE(BranchE),
        .ALUControlE(ALUControlE),
        .ShiftTypeE(ShiftTypeE),
        .ShiftAmountE(ShiftAmountE),
        .RD1_E(RD1_E),
        .RD2_E(RD2_E),
        .Imm_Ext_E(Imm_Ext_E),
        .RS1_E(RS1_E),
        .RS2_E(RS2_E),
        .RD_E(RD_E),
        .PCE(PCE),
        .PCPlus4E(PCPlus4E),
        .ResultW(ResultW),
        .ForwardA_E(ForwardA_E),
        .ForwardB_E(ForwardB_E),
        .PCSrcE(PCSrcE),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM),
        .RD_M(RD_M),
        .PCPlus4M(PCPlus4M),
        .WriteDataM(WriteDataM),
        .ALU_ResultM(ALU_ResultM),
        .PCTargetE(PCTargetE),
        .ALUFlagsE(ALUFlagsE)
    );

    // Test bench logic
    initial begin
        // Initialize inputs with "burned" values
        clk = 0;
        rst = 0;
        RegWriteE = 1'b1;
        ALUSrcE = 1'b0;
        MemWriteE = 1'b1;
        ResultSrcE = 1'b1;
        BranchE = 1'b0;
        ALUControlE = 3'b010;
        ShiftTypeE = 2'b00;
        ShiftAmountE = 5'b00101;
        RD1_E = 32'h12345678;
        RD2_E = 32'habcdef01;
        Imm_Ext_E = 32'h00000100;
        RS1_E = 5'b10101;
        RS2_E = 5'b11010;
        RD_E = 5'b01111;
        PCE = 32'h00001000;
        PCPlus4E = 32'h00001004;
        ResultW = 32'h87654321;
        ForwardA_E = 2'b01;
        ForwardB_E = 2'b10;

        // Apply reset
        #10 rst = 1;

        // Run the test
        #100 $finish;
    end

    // Clock generation
    always #5 clk = ~clk;

endmodule