    `timescale 1ns/1ps

module cpu_tb2();
	 // Signals for clock and reset
    reg clk;
    reg rst;

    // Signals for Fetch Cycle
    wire [31:0] InstrD, PCD, PCPlus4D;
    wire PCSrcE;
    wire [31:0] PCTargetE;

    // Signals for Decode Cycle
    wire RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE;
    wire [2:0] ALUControlE;
    wire [1:0] ShiftTypeE;
    wire [4:0] ShiftAmountE;
    wire [31:0] RD1_E, RD2_E, Imm_Ext_E;
    wire [4:0] RS1_E, RS2_E, RD_E;
    wire [31:0] PCE, PCPlus4E;

    // Signals for Execute Cycle
    wire RegWriteM, MemWriteM, ResultSrcM;
    wire [4:0] RD_M;
    wire [31:0] PCPlus4M, WriteDataM, ALU_ResultM;
    wire [3:0] ALUFlagsE;

    // Signals for Memory Cycle
    wire RegWriteW, ResultSrcW;
    wire [4:0] RD_W;
    wire [31:0] PCPlus4W, ALU_ResultW, ReadDataW;

    // Signals to extract from InstrD
    wire [1:0] cond, tipo, flag_mov_shift;
    wire [2:0] opcode;
    wire [3:0] Rd, Rn;
    wire flag_mem_index;
    wire [13:0] Operando2;

    // Instantiate Fetch Cycle
    Fetch_Cycle fetch (
        .clk(clk),
        .rst(rst),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D)
    );

    // Instantiate Decode Cycle
    Decode_Cycle decode (
        .clk(clk),
        .rst(rst),
        .RegWriteW(RegWriteW),
        .RDW(RD_W),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D),
        .ResultW(ALU_ResultW),
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
        .PCPlus4E(PCPlus4E)
    );

    // Instantiate Execute Cycle
    Execute_Cycle execute (
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
        .ResultW(ALU_ResultW),
        .ForwardA_E(2'b00),  // No forwarding for this test
        .ForwardB_E(2'b00),  // No forwarding for this test
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
	 

    // Instantiate Memory Cycle
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
        .RegWriteW(RegWriteW),
        .ResultSrcW(ResultSrcW),
        .RD_W(RD_W),
        .PCPlus4W(PCPlus4W),
        .ALU_ResultW(ALU_ResultW),
        .ReadDataW(ReadDataW)
    );
	 
	     // Write Back Stage
    Writeback_Cycle WriteBack (
                        .clk(clk), 
                        .rst(rst), 
                        .ResultSrcW(ResultSrcW), 
                        .PCPlus4W(PCPlus4W), 
                        .ALU_ResultW(ALU_ResultW), 
                        .ReadDataW(ReadDataW), 
                        .ResultW(ResultW)
                    );

    // Extract signals from InstrD
    assign cond = InstrD[31:30];
    assign tipo = InstrD[29:28];
    assign opcode = InstrD[27:25];
    assign Rd = InstrD[24:21];
    assign Rn = InstrD[20:17];
    assign flag_mov_shift = InstrD[16:15];
    assign flag_mem_index = InstrD[14];
    assign Operando2 = InstrD[13:0];

    // Assign ShiftTypeE and ShiftAmountE based on flag_mov_shift and Operando2
    assign ShiftTypeE = flag_mov_shift;
    assign ShiftAmountE = Operando2[4:0];

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Test scenario
    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;

        // Apply reset
        #10 rst = 1;

        // Wait for a few clock cycles
        #20;

		          // Monitor and display signals for 10 clock cycles
        repeat(10) begin
            @(posedge clk);
            #1; // Wait for signals to stabilize
            $display("Time: %0t", $time);
            $display("Instruction: %h", InstrD);
            $display("ALU Control: %b", ALUControlE);
            $display("RD1: %h, RD2: %h", RD1_E, RD2_E);
            $display("ALU Result: %h", ALU_ResultM);
            $display("ALU Flags (NZCV): %b", ALUFlagsE);
            $display("Destination Register (RD_M): %d", RD_M);
            $display("-----------------------------");
        end

        // End simulation
        $finish;
    end

endmodule

