module Fetch(
input clk, rst,
input PCSrcE,
input [26:0] PCTargetE,
output reg [26:0] InstrD,
output reg [26:0] PCD, PCPlus4D,
// Debug outputs
output [26:0] PCF_debug,
output [26:0] InstrF_debug
);
// Declaring interim wires and registers
wire [26:0] PC_F, PCPlus4F;
reg [26:0] PCF;
wire [26:0] InstrF;
// Debug assignments
assign PCF_debug = PCF;
assign InstrF_debug = InstrF;

// PC Mux
assign PC_F = PCSrcE ? PCTargetE : PCPlus4F;

// PC Counter
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        PCF <= 27'b0;
    end else begin
        PCF <= PC_F;
    end
end

// Instruction ROM (now using combinational read)
instrROM IMEM (
    .address(PC_F),  // Use PC_F instead of PCF
    .clock(clk),
    .q(InstrF)
);

// PC Adder (increment by 1 instruction word)
assign PCPlus4F = PCF + 27'h0000001;

// Fetch Cycle Register Logic
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        InstrD <= 27'b0;
        PCD <= 27'b0;
        PCPlus4D <= 27'b0;
    end else begin
        InstrD <= InstrF;
        PCD <= PCF;
        PCPlus4D <= PCPlus4F;
    end
end

endmodule