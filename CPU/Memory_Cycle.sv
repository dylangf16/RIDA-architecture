module Memory_Cycle(
    input clk, rst,
    input RegWriteM, MemWriteM, ResultSrcM,
    input [4:0] RD_M,
    input [31:0] PCPlus4M, WriteDataM, ALU_ResultM,
    input IndexedAddrM,
    input [31:0] RD2_M,
    input ByteOpM,
    input PushM, PopM,

    output RegWriteW, ResultSrcW,
    output [4:0] RD_W,
    output [31:0] PCPlus4W, ALU_ResultW, ReadDataW,
    output reg [31:0] StackPointer
);

    // Declaration of Interim Wires
    wire [31:0] ReadDataM;

    // Declaration of Interim Registers
    reg RegWriteM_r, ResultSrcM_r;
    reg [4:0] RD_M_r;
    reg [31:0] PCPlus4M_r, ALU_ResultM_r, ReadDataM_r;

    // Stack Pointer Logic
    always @(posedge clk or negedge rst) begin
        if (rst == 1'b0)
            StackPointer <= 32'hFFFFFFFF; // Initialize stack pointer
        else if (PushM)
            StackPointer <= StackPointer - 4;
        else if (PopM)
            StackPointer <= StackPointer + 4;
    end

    // Declaration of Module Initiation
    Data_Memory dmem (
        .clk(clk),
        .rst(rst),
        .WE(MemWriteM),
        .WD(WriteDataM),
        .A(ALU_ResultM),
        .RD(ReadDataM),
        .IndexedAddr(IndexedAddrM),
        .IndexValue(RD2_M),
        .ByteOp(ByteOpM),
        .StackOp(PushM | PopM),
        .StackPointer(StackPointer)
    );

    // Memory Stage Register Logic
    always @(posedge clk or negedge rst) begin
        if (rst == 1'b0) begin
            RegWriteM_r <= 1'b0;
            ResultSrcM_r <= 1'b0;
            RD_M_r <= 5'b0;
            PCPlus4M_r <= 32'b0;
            ALU_ResultM_r <= 32'b0;
            ReadDataM_r <= 32'b0;
        end
        else begin
            RegWriteM_r <= RegWriteM; 
            ResultSrcM_r <= ResultSrcM;
            RD_M_r <= RD_M;
            PCPlus4M_r <= PCPlus4M; 
            ALU_ResultM_r <= ALU_ResultM; 
            ReadDataM_r <= ReadDataM;
        end
    end 

    // Declaration of output assignments
    assign RegWriteW = RegWriteM_r;
    assign ResultSrcW = ResultSrcM_r;
    assign RD_W = RD_M_r;
    assign PCPlus4W = PCPlus4M_r;
    assign ALU_ResultW = ALU_ResultM_r;
    assign ReadDataW = ReadDataM_r;

endmodule