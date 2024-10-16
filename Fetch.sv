module Fetch (
    input wire clk,
    input wire reset,
    input wire i_Freeze,
    input wire i_Branch_Taken,
    input wire [6:0] i_Branch_Address,
    input wire i_Branch_Result,
    output reg [6:0] o_Pc,
    output reg [26:0] o_Instruction,
    output reg o_Prediction
);
    parameter INSTR_WIDTH = 27;
    parameter ADDR_WIDTH = 7;
    parameter BUFFER_SIZE = 4;
    
    // Instruction buffer
    reg [INSTR_WIDTH-1:0] instr_buffer [BUFFER_SIZE-1:0];
    reg [$clog2(BUFFER_SIZE)-1:0] buffer_head, buffer_tail;
    reg [BUFFER_SIZE-1:0] buffer_valid;

    // Branch prediction
    reg [1:0] branch_history;
    wire prediction;

    // Internal signals
    reg [ADDR_WIDTH-1:0] current_pc;
    wire [ADDR_WIDTH-1:0] next_pc;
    wire [INSTR_WIDTH-1:0] fetched_instruction;

    // PC logic
    assign next_pc = (i_Branch_Taken) ? i_Branch_Address : current_pc + 1;

    // Simple 2-bit saturating counter for branch prediction
    always @(posedge clk or posedge reset) begin
        if (reset)
            branch_history <= 2'b01;
        else if (i_Branch_Result)
            branch_history <= (branch_history == 2'b11) ? 2'b11 : branch_history + 1;
        else
            branch_history <= (branch_history == 2'b00) ? 2'b00 : branch_history - 1;
    end

    assign prediction = branch_history[1];

    // Instruction memory
    Instruction_Memory #(INSTR_WIDTH) Instruction_Mem (
        .clk(clk),
        .reset(reset),
        .i_Address(current_pc),
        .o_Instruction(fetched_instruction)
    );

    // Buffer management and PC update
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            buffer_head <= 0;
            buffer_tail <= 0;
            buffer_valid <= 0;
            current_pc <= 0;
        end else if (!i_Freeze) begin
            if (i_Branch_Taken) begin
                // Clear buffer and update PC on branch taken
                buffer_valid <= 0;
                buffer_head <= 0;
                buffer_tail <= 0;
                current_pc <= i_Branch_Address;
            end else begin
                // Normal operation
                if (!buffer_valid[buffer_tail]) begin
                    instr_buffer[buffer_tail] <= fetched_instruction;
                    buffer_valid[buffer_tail] <= 1;
                    buffer_tail <= buffer_tail + 1;
                end
                if (buffer_valid[buffer_head]) begin
                    buffer_valid[buffer_head] <= 0;
                    buffer_head <= buffer_head + 1;
                end
                current_pc <= next_pc;
            end
        end
    end

    // Pipeline registers
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            o_Pc <= 0;
            o_Instruction <= 0;
            o_Prediction <= 0;
        end else if (!i_Freeze) begin
            o_Pc <= current_pc;
            o_Instruction <= buffer_valid[buffer_head] ? instr_buffer[buffer_head] : fetched_instruction;
            o_Prediction <= prediction;
        end
    end

endmodule