module Fetch_Cycle(
    input wire clk,
    input wire rst,
    input wire PCSrcE,
    input wire [31:0] PCTargetE,
    output wire [31:0] InstrD,
    output wire [31:0] PCD,
    output wire [31:0] PCPlus4D
);

    // Declaring interim wires
    wire [31:0] PC_F, PCF, PCPlus4F;
    wire [31:0] InstrF;

    // Declaration of Registers
    reg [31:0] InstrF_reg;
    reg [31:0] PCF_reg, PCPlus4F_reg;

    // Initiation of Modules
    // Declare PC Mux
    Mux PC_MUX (
        .a(PCPlus4F),
        .b(PCTargetE),
        .s(PCSrcE),
        .c(PC_F)
    );

    // Declare PC Counter
    PC_Module Program_Counter (
        .clk(clk),
        .rst(rst),
        .PC(PCF),
        .PC_Next(PC_F)
    );

    // Declare Instruction Memory
    Instruction_Memory IMEM (
        .clk(clk),
        .rst(rst),
        .A(PCF),
        .RD(InstrF)
    );

    // Declare PC adder
    PC_Adder PC_adder (
        .a(PCF),
        .b(32'h00000004),
        .c(PCPlus4F)
    );

    // Fetch Cycle Register Logic
    always @(posedge clk or negedge rst) begin
        if(rst == 1'b0) begin
            InstrF_reg <= 32'b00000000;
            PCF_reg <= 32'b00000000;
            PCPlus4F_reg <= 32'b00000000;
        end
        else begin
            InstrF_reg <= InstrF;
            PCF_reg <= PCF;
            PCPlus4F_reg <= PCPlus4F;
        end
    end

    // Assigning Registers Value to the Output port
    assign InstrD = (rst == 1'b0) ? 32'b00000000 : InstrF_reg;
    assign PCD = (rst == 1'b0) ? 32'b00000000 : PCF_reg;
    assign PCPlus4D = (rst == 1'b0) ? 32'b00000000 : PCPlus4F_reg;

endmodule