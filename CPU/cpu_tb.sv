`timescale 1ns/1ps

module cpu_tb();
    // Signals for clock and reset
    reg clk;
    reg rst;

    // Signals for Fetch Cycle
    wire [31:0] InstrD, PCD, PCPlus4D;
    wire PCSrcE;
    wire [31:0] PCTargetE;

    // Signals for Decode Cycle
    wire RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE;
    wire [2:0] ALUControlE;
    wire [1:0] ShiftTypeE;
    wire [4:0] ShiftAmountE;
    wire [31:0] RD1_E, RD2_E, Imm_Ext_E;
    wire [4:0] RS1_E, RS2_E, RD_E;
    wire [31:0] PCE, PCPlus4E;

    // Signals for Execute Cycle
    wire RegWriteM, MemWriteM, ResultSrcM;
    wire [4:0] RD_M;
    wire [31:0] PCPlus4M, WriteDataM, ALU_ResultM;
    wire [3:0] ALUFlagsE;

    // Signals to extract from InstrD
    wire [1:0] cond, tipo, flag_mov_shift;
    wire [2:0] opcode;
    wire [3:0] Rd, Rn;
    wire flag_mem_index;
    wire [13:0] Operando2;

    // Instantiate Fetch Cycle
    Fetch_Cycle fetch (
        .clk(clk),
        .rst(rst),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D)
    );

    // Instantiate Decode Cycle
    Decode_Cycle decode (
        .clk(clk),
        .rst(rst),
        .RegWriteW(1'b0),  // Not connected for this test
        .RDW(5'b0),        // Not connected for this test
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D),
        .ResultW(32'b0),   // Not connected for this test
        .RegWriteE(RegWriteE),
        .ALUSrcE(ALUSrcE),
        .MemWriteE(MemWriteE),
        .ResultSrcE(ResultSrcE),
        .BranchE(BranchE),
        .ALUControlE(ALUControlE),
        .RD1_E(RD1_E),
        .RD2_E(RD2_E),
        .Imm_Ext_E(Imm_Ext_E),
        .RS1_E(RS1_E),
        .RS2_E(RS2_E),
        .RD_E(RD_E),
        .PCE(PCE),
        .PCPlus4E(PCPlus4E)
    );

    // Instantiate Execute Cycle
    Execute_Cycle execute (
        .clk(clk),
        .rst(rst),
        .RegWriteE(RegWriteE),
        .ALUSrcE(ALUSrcE),
        .MemWriteE(MemWriteE),
        .ResultSrcE(ResultSrcE),
        .BranchE(BranchE),
        .ALUControlE(ALUControlE),
        .ShiftTypeE(ShiftTypeE),
        .ShiftAmountE(ShiftAmountE),
        .RD1_E(RD1_E),
        .RD2_E(RD2_E),
        .Imm_Ext_E(Imm_Ext_E),
        .RS1_E(RS1_E),
        .RS2_E(RS2_E),
        .RD_E(RD_E),
        .PCE(PCE),
        .PCPlus4E(PCPlus4E),
        .ResultW(32'b0),  // Not connected for this test
        .ForwardA_E(2'b00),  // No forwarding for this test
        .ForwardB_E(2'b00),  // No forwarding for this test
        .PCSrcE(PCSrcE),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM),
        .RD_M(RD_M),
        .PCPlus4M(PCPlus4M),
        .WriteDataM(WriteDataM),
        .ALU_ResultM(ALU_ResultM),
        .PCTargetE(PCTargetE),
        .ALUFlagsE(ALUFlagsE)
    );

    // Extract signals from InstrD
    assign cond = InstrD[31:30];
    assign tipo = InstrD[29:28];
    assign opcode = InstrD[27:25];
    assign Rd = InstrD[24:21];
    assign Rn = InstrD[20:17];
    assign flag_mov_shift = InstrD[16:15];
    assign flag_mem_index = InstrD[14];
    assign Operando2 = InstrD[13:0];

    // Assign ShiftTypeE and ShiftAmountE based on flag_mov_shift and Operando2
    assign ShiftTypeE = flag_mov_shift;
    assign ShiftAmountE = Operando2[4:0];

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Test scenario
    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;

        // Apply reset
        #10 rst = 1;

        // Wait for a few clock cycles
        #20;

        // Monitor and display signals for 10 clock cycles
        repeat(10) begin
            @(posedge clk);
            #1; // Wait for signals to stabilize
            $display("Time: %0t", $time);
            $display("Instruction: %b", InstrD);
            $display("Condition: %b", cond);
            $display("Type: %b", tipo);
            $display("Opcode: %b", opcode);
            $display("Rd: %b", Rd);
            $display("Rn: %b", Rn);
            $display("Flag MOV with Shift: %b", flag_mov_shift);
            $display("Flag Memory Index: %b", flag_mem_index);
            $display("Operand2: %b", Operando2);
            
            // Decode the instruction and display operation
            case (tipo)
                2'b00: begin // REG type
                    case (opcode)
                        3'b000: $display("Operation: ADD R%0d, R%0d, R%0d", Rd, Rn, Operando2[3:0]);
                        3'b001: $display("Operation: SUB R%0d, R%0d, R%0d", Rd, Rn, Operando2[3:0]);
                        3'b010: $display("Operation: AND R%0d, R%0d, R%0d", Rd, Rn, Operando2[3:0]);
                        3'b011: begin
                            case (flag_mov_shift)
                                2'b00: $display("Operation: MOV R%0d, R%0d", Rd, Rn);
                                2'b01: $display("Operation: MOV R%0d, R%0d, LSR #%0d", Rd, Rn, ShiftAmountE);
                                2'b10: $display("Operation: MOV R%0d, R%0d, LSL #%0d", Rd, Rn, ShiftAmountE);
                            endcase
                        end
                        3'b100: $display("Operation: CMP R%0d, R%0d", Rn, Operando2[3:0]);
                        3'b101: $display("Operation: UDIV R%0d, R%0d, R%0d", Rd, Rn, Operando2[3:0]);
                        3'b110: $display("Operation: SUBS R%0d, R%0d, R%0d", Rd, Rn, Operando2[3:0]);
                        3'b111: $display("Operation: MUL R%0d, R%0d, R%0d", Rd, Rn, Operando2[3:0]);
                    endcase
                end
                2'b01: begin // IMM type
                    case (opcode)
                        3'b000: $display("Operation: ADD R%0d, R%0d, #%0d", Rd, Rn, Operando2);
                        3'b001: $display("Operation: SUB R%0d, R%0d, #%0d", Rd, Rn, Operando2);
                        3'b010: $display("Operation: AND R%0d, R%0d, #%0d", Rd, Rn, Operando2);
                        3'b011: $display("Operation: MOV R%0d, #%0d", Rd, Operando2);
                        3'b100: $display("Operation: CMP R%0d, #%0d", Rn, Operando2);
                        3'b101: $display("Operation: LSL R%0d, R%0d, #%0d", Rd, Rn, Operando2[4:0]);
                    endcase
                end
                2'b10: begin // MEM type
                    case (opcode)
                        3'b000: $display("Operation: LDR R%0d, [R%0d, #%0d]", Rd, Rn, Operando2);
                        3'b001: $display("Operation: LDRB R%0d, [R%0d, #%0d]", Rd, Rn, Operando2);
                        3'b010: $display("Operation: STR R%0d, [R%0d, #%0d]", Rd, Rn, Operando2);
                        3'b011: $display("Operation: STRB R%0d, [R%0d, #%0d]", Rd, Rn, Operando2);
                    endcase
                end
                2'b11: begin // CTRL type
                    case (opcode)
                        3'b000: $display("Operation: B #%0d", {{18{Operando2[13]}}, Operando2});
                        3'b001: $display("Operation: PUSH {R%0d}", Rd);
                        3'b010: $display("Operation: POP {R%0d}", Rd);
                    endcase
                end
            endcase

            $display("ALU Result: %0d", ALU_ResultM);
            $display("ALU Flags (NZCV): %b", ALUFlagsE);
            $display("-----------------------------");
        end

        // End simulation
        $finish;
    end
endmodule