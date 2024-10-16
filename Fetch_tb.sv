`timescale 1ns/1ps

module Fetch_tb();
    parameter DATA_WIDTH = 27;
    parameter CLOCK_PERIOD = 10; // 10ns clock period (100MHz)

    reg clk;
    reg reset;
    reg i_Freeze;
    reg i_Branch_Taken;
    reg [DATA_WIDTH-1:0] i_Branch_Address;
    wire [DATA_WIDTH-1:0] o_Pc;
    wire [DATA_WIDTH-1:0] o_Instruction;

    // Instantiate the IF stage
    Fetch #(DATA_WIDTH) uut (
        .clk(clk),
        .reset(reset),
        .i_Freeze(i_Freeze),
        .i_Branch_Taken(i_Branch_Taken),
        .i_Branch_Address(i_Branch_Address),
        .o_Pc(o_Pc),
        .o_Instruction(o_Instruction)
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

        // Apply reset
        #(CLOCK_PERIOD*2);
        reset = 0;

        // Wait for a few clock cycles to fetch initial instructions
        #(CLOCK_PERIOD*3);

        // Test normal fetching
        repeat(10) begin
            $display("Time %0t: PC = %0d, Instruction = %b", $time, o_Pc, o_Instruction);
            #(CLOCK_PERIOD);
        end

        // Test stall
        i_Freeze = 1;
        #(CLOCK_PERIOD*3);
        $display("Time %0t: Stall applied. PC = %0d, Instruction = %b", $time, o_Pc, o_Instruction);
		  repeat(5) begin
            $display("Time %0t: PC = %0d, Instruction = %b", $time, o_Pc, o_Instruction);
            #(CLOCK_PERIOD);
        end
        i_Freeze = 0;
		  
		  $display("Time %0t: Stall finished, continuing. PC = %0d, Instruction = %b", $time, o_Pc, o_Instruction);
		  repeat(5) begin
            $display("Time %0t: PC = %0d, Instruction = %b", $time, o_Pc, o_Instruction);
            #(CLOCK_PERIOD);
        end

        // Test branch
        #(CLOCK_PERIOD*2);
        i_Branch_Taken = 1;
        i_Branch_Address = 27'd20; // Example branch address
        #(CLOCK_PERIOD);
        i_Branch_Taken = 0;
        $display("Time %0t: Branch taken. New PC = %0d, Instruction = %b", $time, o_Pc, o_Instruction);

        // Continue normal execution for a few more cycles
        #(CLOCK_PERIOD*5);

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