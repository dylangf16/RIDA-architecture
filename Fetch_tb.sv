`timescale 1ns/1ps
module Fetch_tb();
    reg clk, rst;
    reg PCSrcE;
    reg [26:0] PCTargetE;
    wire [26:0] InstrD, PCD, PCPlus4D;
    wire [26:0] PCF_debug, InstrF_debug;

    // Instantiate the fetch_cycle module
    Fetch uut (
        .clk(clk),
        .rst(rst),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D),
        .PCF_debug(PCF_debug),
        .InstrF_debug(InstrF_debug)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        clk = 0;
        rst = 0;
        PCSrcE = 0;
        PCTargetE = 0;

        // Apply reset
        #10 rst = 0;
        #10 rst = 1;

        // Wait for 45 clock cycles
        repeat(45) @(posedge clk);

        // End simulation
        #10 $finish;
    end

    // Monitor to display detailed pipeline stages
    integer cycle_count = 0;
    always @(posedge clk) begin
        if (rst) begin
            $display("Cycle %0d: PCF=%h, InstrF=%h, PCD=%h, InstrD=%h", 
                     cycle_count, PCF_debug, InstrF_debug, PCD, InstrD);
            cycle_count = cycle_count + 1;
        end
    end
endmodule