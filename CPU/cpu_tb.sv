`timescale 1ns/1ps

module cpu_tb();

    // Declare signals
    reg clk;
    reg rst;
    reg PCSrcE;
    reg [31:0] PCTargetE;
    wire [31:0] InstrD;
    wire [31:0] PCD;
    wire [31:0] PCPlus4D;

    // Instantiate the Fetch_Cycle module
    Fetch_Cycle dut (
        .clk(clk),
        .rst(rst),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D)
    );

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
        PCTargetE = 32'd0;

        // Reset the CPU
        #10 rst = 1;

        // Load first 50 instructions
        repeat(50) @(posedge clk);

        // Branch to instruction 70
        PCSrcE = 1;
        PCTargetE = 32'd70 * 4;  // Multiply by 4 for byte addressing
        @(posedge clk);
        PCSrcE = 0;

        // Load 10 instructions starting from 70
        repeat(10) @(posedge clk);

        // Branch back to instruction 10
        PCSrcE = 1;
        PCTargetE = 32'd10 * 4;  // Multiply by 4 for byte addressing
        @(posedge clk);
        PCSrcE = 0;

        // Load 20 instructions starting from 10
        repeat(20) @(posedge clk);

        // End simulation
        #10 $finish;
    end

    // Monitor
    always @(posedge clk) begin
        if (rst) begin
            $display("Time=%0t ns: PC=%0d, Instruction=%b", $time, PCD/4, InstrD);
        end
    end

endmodule