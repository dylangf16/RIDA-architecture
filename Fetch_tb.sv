`timescale 1ns/1ps

module Fetch_tb();
    parameter INSTR_WIDTH = 27;
    parameter ADDR_WIDTH = 7;
    parameter CLOCK_PERIOD = 10; // 10ns clock period (100MHz)

    reg clk;
    reg reset;
    reg i_Freeze;
    reg i_Branch_Taken;
    reg [ADDR_WIDTH-1:0] i_Branch_Address;
    reg i_Branch_Result;
    wire [ADDR_WIDTH-1:0] o_Pc;
    wire [INSTR_WIDTH-1:0] o_Instruction;
    wire o_Prediction;

    // Instantiate the updated Fetch module
    Fetch #(INSTR_WIDTH) uut (
        .clk(clk),
        .reset(reset),
        .i_Freeze(i_Freeze),
        .i_Branch_Taken(i_Branch_Taken),
        .i_Branch_Address(i_Branch_Address),
        .i_Branch_Result(i_Branch_Result),
        .o_Pc(o_Pc),
        .o_Instruction(o_Instruction),
        .o_Prediction(o_Prediction)
    );

    // Clock generation
    always begin
        #(CLOCK_PERIOD/2) clk = ~clk;
    end

    // Test scenario
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        i_Freeze = 0;
        i_Branch_Taken = 0;
        i_Branch_Address = 0;
        i_Branch_Result = 0;

        // Apply reset
        #(CLOCK_PERIOD*2);
        reset = 0;

        // Wait for a few clock cycles to fill the instruction buffer
        #(CLOCK_PERIOD*5);

        // Test normal fetching
        repeat(25) begin
            $display("Time %0t: PC = %0d, Instruction = %b, Prediction = %b", $time, o_Pc, o_Instruction, o_Prediction);
            #(CLOCK_PERIOD);
        end

        // Test stall
        i_Freeze = 1;
        #(CLOCK_PERIOD*3);
        $display("Time %0t: Stall applied. PC = %0d, Instruction = %b", $time, o_Pc, o_Instruction);
        repeat(5) begin
            $display("Time %0t: PC = %0d, Instruction = %b, Prediction = %b", $time, o_Pc, o_Instruction, o_Prediction);
            #(CLOCK_PERIOD);
        end
        i_Freeze = 0;
        
        $display("Time %0t: Stall finished, continuing. PC = %0d, Instruction = %b", $time, o_Pc, o_Instruction);
        repeat(5) begin
            $display("Time %0t: PC = %0d, Instruction = %b, Prediction = %b", $time, o_Pc, o_Instruction, o_Prediction);
            #(CLOCK_PERIOD);
        end

// Test instruction buffer
        $display("Testing instruction buffer:");
        repeat(6) begin
            @(posedge clk);
            $display("Time %0t: PC = %0d, Instruction = %b", $time, o_Pc, o_Instruction);
        end

        // Test buffer with freeze
        $display("\nTesting buffer with freeze:");
        i_Freeze = 1;
        repeat(3) begin
            @(posedge clk);
            $display("Time %0t: Freeze active, PC = %0d, Instruction = %b", $time, o_Pc, o_Instruction);
        end
        i_Freeze = 0;
        repeat(3) begin
            @(posedge clk);
            $display("Time %0t: After freeze, PC = %0d, Instruction = %b", $time, o_Pc, o_Instruction);
        end

        // Test branch prediction
        $display("\nTesting branch prediction:");
        repeat(10) begin
            i_Branch_Result = $random;  // Randomly set branch result
            @(posedge clk);
            $display("Time %0t: Branch Result = %b, Prediction = %b", $time, i_Branch_Result, o_Prediction);
        end

        // Test branch taken
        $display("\nTesting branch taken:");
        i_Branch_Taken = 1;
        i_Branch_Address = 27'd20; // Example branch address
        @(posedge clk);
        i_Branch_Taken = 0;
        repeat(3) begin
            @(posedge clk);
            $display("Time %0t: After branch, PC = %0d, Instruction = %b", $time, o_Pc, o_Instruction);
        end

        // End simulation
        $display("Simulation completed");
        $finish;
    end

    // Optional: Dump waveforms
    initial begin
        $dumpfile("fetch_tb.vcd");
        $dumpvars(0, Fetch_tb);
    end

endmodule