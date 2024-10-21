`timescale 1ns / 1ps
module cpu_tb2;
    // Signals
    reg clk, rst;
    
	 // Nuevas señales para Control_Unit
    wire RegWrite, ALUSrc, MemWrite, ResultSrc, Branch;
    wire [1:0] ImmSrc;
    wire [3:0] ALUControl;
    wire MemRead, Push, Pop;
	 
    // Fetch Cycle
    wire [31:0] InstrD, PCD, PCPlus4D;
    wire [31:0] PCTargetE;
    wire PCSrcE;
    
    // Decode Cycle
    wire RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE;
    wire [3:0] ALUControlE;
    wire [31:0] RD1_E, RD2_E, Imm_Ext_E;
    wire [4:0] RS1_E, RS2_E, RD_E;
    wire [31:0] PCE, PCPlus4E;
    wire [4:0] ShiftAmountE;
    wire [1:0] CondE, TypeE, ShiftTypeE;
    wire IndexedAddrE, MemReadE, PushE, PopE;
    
    // Execute Cycle
    wire [3:0] ALUFlagsE;
    wire [1:0] ForwardAE, ForwardBE;
    
    // Memory Cycle
    wire RegWriteM, MemWriteM, ResultSrcM;
    wire [4:0] RD_M;
    wire [31:0] PCPlus4M, WriteDataM, ALU_ResultM;
    wire [31:0] StackPointer;
    
    // Writeback Cycle
    wire RegWriteW, ResultSrcW;
    wire [4:0] RDW;
    wire [31:0] PCPlus4W, ALU_ResultW, ReadDataW, ResultW;

    // Instantiate the pipeline stages
    Fetch_Cycle fetch (
        .clk(clk),
        .rst(rst),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D)
    );

    Decode_Cycle decode (
        .clk(clk),
        .rst(rst),
        .RegWriteW(RegWriteW),
        .RDW(RDW),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D),
        .ResultW(ResultW),
        .RegWriteE(RegWriteE),
        .ALUSrcE(ALUSrcE),
        .MemWriteE(MemWriteE),
        .ResultSrcE(ResultSrcE),
        .BranchE(BranchE),
        .ALUControlE(ALUControlE),
        .RD1_E(RD1_E),
        .RD2_E(RD2_E),
        .Imm_Ext_E(Imm_Ext_E),
        .RS1_E(RS1_E),
        .RS2_E(RS2_E),
        .RD_E(RD_E),
        .PCE(PCE),
        .PCPlus4E(PCPlus4E),
        .ShiftAmountE(ShiftAmountE),
        .CondE(CondE),
        .TypeE(TypeE),
        .ShiftTypeE(ShiftTypeE),
        .IndexedAddrE(IndexedAddrE),
        .MemReadE(MemReadE),
        .PushE(PushE),
        .PopE(PopE)
    );
	 
	 Control_Unit control_unit (
        .cond(CondE),
        .tipo(TypeE),
        .opcode(InstrD[31:29]),  // Asumiendo que el opcode está en estos bits
        .flag_mov_shift(ShiftTypeE),
        .index_flag(IndexedAddrE),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .ImmSrc(ImmSrc),
        .ALUControl(ALUControl),
        .MemRead(MemRead),
        .Push(Push),
        .Pop(Pop)
    );

    Execute_Cycle execute (
        .clk(clk),
        .rst(rst),
        .RegWriteE(RegWriteE),
        .ALUSrcE(ALUSrcE),
        .MemWriteE(MemWriteE),
        .ResultSrcE(ResultSrcE),
        .BranchE(BranchE),
        .ALUControlE(ALUControlE),
        .CondE(CondE),
        .TypeE(TypeE),
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
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
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

    Memory_Cycle memory (
        .clk(clk),
        .rst(rst),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM),
        .RD_M(RD_M),
        .PCPlus4M(PCPlus4M),
        .WriteDataM(WriteDataM),
        .ALU_ResultM(ALU_ResultM),
        .IndexedAddrM(IndexedAddrE),
        .RD2_M(RD2_E),
        .ByteOpM(1'b0), // Assuming no byte operations for now
        .PushM(PushE),
        .PopM(PopE),
        .RegWriteW(RegWriteW),
        .ResultSrcW(ResultSrcW),
        .RD_W(RDW),
        .PCPlus4W(PCPlus4W),
        .ALU_ResultW(ALU_ResultW),
        .ReadDataW(ReadDataW),
        .StackPointer(StackPointer)
    );

    Writeback_Cycle writeback (
        .clk(clk),
        .rst(rst),
        .ResultSrcW(ResultSrcW),
        .PCPlus4W(PCPlus4W),
        .ALU_ResultW(ALU_ResultW),
        .ReadDataW(ReadDataW),
        .ResultW(ResultW)
    );

    // Hazard Unit
    Hazard_Unit Forwarding_block (
        .rst(rst),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .RD_M(RD_M),
        .RD_W(RDW),
        .Rs1_E(RS1_E),
        .Rs2_E(RS2_E),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        
        // Reset
        #10 rst = 1;
        
        // Run for some cycles
        #10000;
        
        // End simulation
        $finish;
    end

    // Display pipeline stage information
    always @(posedge clk) begin
        $display("\nTime: %0t", $time);
		  
		  // Fetch Stage
        $display("Fetch Stage:");
        $display("  InstrD: %b", InstrD);
        $display("  PCD: %0d", PCD);
        $display("  PCPlus4D: %0d", PCPlus4D);
		  $display("--------------------------------");

        
        // Decode Stage
        $display("Decode Stage:");
        $display("  RegWriteE: %b", RegWriteE);
        $display("  ALUSrcE: %b", ALUSrcE);
        $display("  MemWriteE: %b", MemWriteE);
        $display("  ResultSrcE: %b", ResultSrcE);
        $display("  BranchE: %b", BranchE);
        $display("  ALUControlE: %b", ALUControlE);
        $display("  RD1_E: %b", RD1_E);
        $display("  RD2_E: %b", RD2_E);
        $display("  Imm_Ext_E: %b", Imm_Ext_E);
        $display("  RS1_E: %b", RS1_E);
        $display("  RS2_E: %b", RS2_E);
        $display("  RD_E: %b", RD_E);
        $display("  PCE: %0d", PCE);
        $display("  PCPlus4E: %0d", PCPlus4E);
        $display("  ShiftAmountE: %b", ShiftAmountE);
        $display("  CondE: %b", CondE);
        $display("  TypeE: %b", TypeE);
        $display("  ShiftTypeE: %b", ShiftTypeE);
        $display("  IndexedAddrE: %b", IndexedAddrE);
        $display("  MemReadE: %b", MemReadE);
        $display("  PushE: %b", PushE);
        $display("  PopE: %b", PopE);
		  $display("--------------------------------");

        
        // Execute Stage
        $display("Execute Stage:");
        $display("  PCSrcE: %b", PCSrcE);
        $display("  PCTargetE: %0d", PCTargetE);
        $display("  ALUFlagsE: %b", ALUFlagsE);
        $display("  ForwardAE: %b", ForwardAE);
        $display("  ForwardBE: %b", ForwardBE);
		  $display("--------------------------------");

        
        // Memory Stage
        $display("Memory Stage:");
        $display("  RegWriteM: %b", RegWriteM);
        $display("  MemWriteM: %b", MemWriteM);
        $display("  ResultSrcM: %b", ResultSrcM);
        $display("  RD_M: %b", RD_M);
        $display("  PCPlus4M: %0d", PCPlus4M);
        $display("  WriteDataM: %b", WriteDataM);
        $display("  ALU_ResultM: %b", ALU_ResultM);
        $display("  StackPointer: %0d", StackPointer);
		  $display("--------------------------------");

        
        // Writeback Stage
        $display("Writeback Stage:");
        $display("  RegWriteW: %b", RegWriteW);
        $display("  ResultSrcW: %b", ResultSrcW);
        $display("  RDW: %b", RDW);
        $display("  PCPlus4W: %0d", PCPlus4W);
        $display("  ALU_ResultW: %b", ALU_ResultW);
        $display("  ReadDataW: %b", ReadDataW);
        $display("  ResultW: %b", ResultW);
		  $display("--------------------------------");

        
        // Nuevas impresiones de depuración para Control_Unit
        $display("Control Unit:");
        $display("  RegWrite: %b", RegWrite);
        $display("  ALUSrc: %b", ALUSrc);
        $display("  MemWrite: %b", MemWrite);
        $display("  ResultSrc: %b", ResultSrc);
        $display("  Branch: %b", Branch);
        $display("  ImmSrc: %b", ImmSrc);
        $display("  ALUControl: %b", ALUControl);
        $display("  MemRead: %b", MemRead);
        $display("  Push: %b", Push);
        $display("  Pop: %b", Pop);
		  $display("--------------------------------");

        
        // Impresiones de depuración para Register_File
        $display("Register File:");
        $display("  WE3: %b", RegWriteW);
        $display("  A1: %b", RS1_E);
        $display("  A2: %b", RS2_E);
        $display("  A3: %b", RDW);
        $display("  WD3: %b", ResultW);
        $display("  RD1: %b", RD1_E);
        $display("  RD2: %b", RD2_E);
		  $display("--------------------------------");

        
        // Impresiones de depuración para Hazard_Unit
        $display("Hazard Unit:");
        $display("  RegWriteM: %b", RegWriteM);
        $display("  RegWriteW: %b", RegWriteW);
        $display("  RD_M: %b", RD_M);
        $display("  RD_W: %b", RDW);
        $display("  Rs1_E: %b", RS1_E);
        $display("  Rs2_E: %b", RS2_E);
        $display("  ForwardAE: %b", ForwardAE);
        $display("  ForwardBE: %b", ForwardBE);
        
        $display("--------------------------------------------------------------------------------------");
    end
endmodule