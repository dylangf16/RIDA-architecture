module Fetch (
    clk, 
    reset, 
    i_Freeze, 
    i_Branch_Taken, 
    i_Branch_Address,
    o_Pc, 
    o_Instruction
);
    parameter DATA_WIDTH = 27;
    
    input clk;
    input reset;
    input i_Freeze;
    input i_Branch_Taken; 
    input [DATA_WIDTH - 1:0] i_Branch_Address;
    output [DATA_WIDTH - 1:0] o_Pc;
    output [DATA_WIDTH - 1:0] o_Instruction;

    wire [DATA_WIDTH - 1:0] w_Mux_In;
    wire [DATA_WIDTH - 1:0] w_Mux_Out;
    wire [DATA_WIDTH - 1:0] w_Pc_In;
    wire [DATA_WIDTH - 1:0] w_Pc_Out;
    wire [DATA_WIDTH - 1:0] w_Pc_Added;

    assign w_Mux_Out = i_Branch_Taken ? i_Branch_Address : w_Mux_In;
    assign w_Pc_In = w_Mux_Out;
    assign w_Pc_Added = w_Pc_Out + 1;
    assign w_Mux_In = w_Pc_Added;
    assign o_Pc = w_Pc_Added;

    // Instantiate the PC module
    PC_Module #(DATA_WIDTH) Pc (
        .clk(clk),
        .reset(reset),
        .i_Load(~i_Freeze),
        .i_PC(w_Pc_In),
        .o_PC(w_Pc_Out)
    );

    // Instantiate the instruction memory module
    Instruction_Memory #(DATA_WIDTH) Instruction_Mem (
        .clk(clk),
        .reset(reset),
        .i_Address(w_Pc_Out[6:0]), // Use only the lower 7 bits
        .o_Instruction(o_Instruction)
    );

endmodule