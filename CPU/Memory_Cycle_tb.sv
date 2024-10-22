`timescale 1ns / 1ps

module Memory_Cycle_tb;

    // Inputs
    reg clk;
    reg rst;
    reg RegWriteM;
    reg MemWriteM;
    reg ResultSrcM;
    reg [4:0] RD_M;
    reg [31:0] PCPlus4M;
    reg [31:0] WriteDataM;
    reg [31:0] ALU_ResultM;

    // Outputs
    wire RegWriteW;
    wire ResultSrcW;
    wire [4:0] RD_W;
    wire [31:0] PCPlus4W;
    wire [31:0] ALU_ResultW;
    wire [31:0] ReadDataW;

    // Instantiate the Memory_Cycle module
    Memory_Cycle dut (
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

    // Test bench logic
    initial begin
        // Initialize inputs with "burned" values
        clk = 0;
        rst = 0;
        RegWriteM = 1'b1;
        MemWriteM = 1'b1;
        ResultSrcM = 1'b0;
        RD_M = 5'b01111;
        PCPlus4M = 32'h00001004;
        WriteDataM = 32'habcdef01;
        ALU_ResultM = 32'h12345678;

        // Apply reset
        #10 rst = 1;

        // Run the test
        #100 $finish;
    end

    // Clock generation
    always #5 clk = ~clk;

endmodule