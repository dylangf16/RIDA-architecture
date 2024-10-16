module Instruction_Memory(
    clk,
    reset,
    i_Address, 
    o_Instruction
);
    parameter DATA_WIDTH = 27;
    input clk;
    input reset;
    input [6:0] i_Address; // Changed to 7 bits to match instrROM
    output reg [DATA_WIDTH - 1:0] o_Instruction;
    
    wire [DATA_WIDTH - 1:0] rom_output;
    
    // Instantiate the instrROM module
    instrROM rom_instance (
        .address(i_Address),
        .clock(clk),
        .q(rom_output)
    );
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            o_Instruction <= 27'b0;
        end
        else begin
            o_Instruction <= rom_output;
        end
    end
    
endmodule