`timescale 1ns/1ps

module cpu_tb();

    // Signals for clock and reset
    reg clk;
    reg rst;

    // Signals for Fetch Cycle
    wire [31:0] InstrD, PCD, PCPlus4D;
    reg PCSrcE;
    reg [31:0] PCTargetE;

    // Signals for Decode Cycle
    wire RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE;
    wire [2:0] ALUControlE;
    wire [31:0] RD1_E, RD2_E, Imm_Ext_E;
    wire [4:0] RS1_E, RS2_E, RD_E;
    wire [31:0] PCE, PCPlus4E;

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
        .RegWriteW(1'b0),  // Not connected for this test
        .RDW(5'b0),        // Not connected for this test
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D),
        .ResultW(32'b0),   // Not connected for this test
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

    // Extract signals from InstrD
    assign cond = InstrD[31:30];
    assign tipo = InstrD[29:28];
    assign opcode = InstrD[27:25];
    assign Rd = InstrD[24:21];
    assign Rn = InstrD[20:17];
    assign flag_mov_shift = InstrD[16:15];
    assign flag_mem_index = InstrD[14];
    assign Operando2 = InstrD[13:0];

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Test scenario
    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        PCSrcE = 0;
        PCTargetE = 32'h0;

        // Apply reset
        #10 rst = 1;

        // Wait for a few clock cycles
        #30;

        // Monitor and display signals for 10 clock cycles
        repeat(10) begin
            @(posedge clk);
            #1; // Wait for signals to stabilize
            $display("Time: %0t", $time);
            $display("Instruction: %b", InstrD);
            $display("Condition: %b", cond);
            $display("Type: %b", tipo);
            $display("Opcode: %b", opcode);
            $display("Rd: %b", Rd);
            $display("Rn: %b", Rn);
            $display("Flag MOV with Shift: %b", flag_mov_shift);
            $display("Flag Memory Index: %b", flag_mem_index);
            $display("Operand2: %b", Operando2);
            $display("-----------------------------");
        end

        // End simulation
        $finish;
    end

endmodule