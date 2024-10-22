module Data_Memory(
    input clk, rst, WE,
    input [31:0] A, WD,
    input IndexedAddr,
    input [31:0] IndexValue,
    input ByteOp,
    input StackOp,
    input [31:0] StackPointer,
    output reg [31:0] RD
);

    reg [7:0] mem [0:1023]; // Byte-addressable memory

    wire [31:0] EffectiveAddress = IndexedAddr ? A + IndexValue : 
                                   StackOp ? StackPointer : A;

    always @(posedge clk) begin
        if (WE) begin
            if (ByteOp)
                mem[EffectiveAddress] <= WD[7:0];
            else
                {mem[EffectiveAddress+3], mem[EffectiveAddress+2], 
                 mem[EffectiveAddress+1], mem[EffectiveAddress]} <= WD;
        end
    end

    always @(*) begin
        if (ByteOp)
            RD = {24'b0, mem[EffectiveAddress]};
        else
            RD = {mem[EffectiveAddress+3], mem[EffectiveAddress+2], 
                  mem[EffectiveAddress+1], mem[EffectiveAddress]};
    end
endmodule