module Control_Unit(
    input [1:0] cond,
    input [1:0] tipo,
    input [2:0] opcode,
    input [1:0] flag_mov_shift,
    input index_flag,
    output reg RegWrite, ALUSrc, MemWrite, ResultSrc, Branch,
    output reg [1:0] ImmSrc,
    output reg [3:0] ALUControl,
    output reg MemRead, Push, Pop
);

    always @(*) begin
        // Default values
        RegWrite = 1'b0;
        ALUSrc = 1'b0;
        MemWrite = 1'b0;
        ResultSrc = 1'b0;
        Branch = 1'b0;
        ImmSrc = 2'b00;
        ALUControl = 4'b0000;
        MemRead = 1'b0;
        Push = 1'b0;
        Pop = 1'b0;

        case(tipo)
            2'b00: begin // REG
                RegWrite = 1'b1;
                case(opcode)
                    3'b000: ALUControl = 4'b0000; // ADD
                    3'b001: ALUControl = 4'b0001; // SUB
                    3'b010: ALUControl = 4'b0010; // AND
                    3'b011: begin // MOV
                        ALUControl = 4'b0011;
                        case(flag_mov_shift)
                            2'b01: ALUControl = 4'b1000; // LSR
                            2'b10: ALUControl = 4'b1001; // LSL
                        endcase
                    end
                    3'b100: begin // CMP
                        RegWrite = 1'b0;
                        ALUControl = 4'b0100;
                    end
                    3'b101: ALUControl = 4'b0101; // UDIV
                    3'b110: ALUControl = 4'b0110; // SUBS
                    3'b111: ALUControl = 4'b0111; // MUL
                endcase
            end
            2'b01: begin // IMM
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
                ImmSrc = 2'b00;
                case(opcode)
                    3'b000: ALUControl = 4'b0000; // ADD
                    3'b001: ALUControl = 4'b0001; // SUB
                    3'b010: ALUControl = 4'b0010; // AND
                    3'b011: ALUControl = 4'b0011; // MOV
                    3'b100: begin // CMP
                        RegWrite = 1'b0;
                        ALUControl = 4'b0100;
                    end
                    3'b101: ALUControl = 4'b1001; // LSL
                endcase
            end
            2'b10: begin // MEM
                ALUSrc = 1'b1;
                ImmSrc = index_flag ? 2'b10 : 2'b01;
                case(opcode)
                    3'b000, 3'b001: begin // LDR, LDRB
                        RegWrite = 1'b1;
                        ResultSrc = 1'b1;
                        MemRead = 1'b1;
                    end
                    3'b010, 3'b011: MemWrite = 1'b1; // STR, STRB
                endcase
                ALUControl = 4'b0000; // Use ADD for address calculation
            end
            2'b11: begin // CTRL
                case(opcode)
                    3'b000: begin // B
                        Branch = 1'b1;
                        ImmSrc = 2'b10;
                    end
                    3'b001: Push = 1'b1; // PUSH
                    3'b010: begin // POP
                        Pop = 1'b1;
                        RegWrite = 1'b1;
                    end
                endcase
            end
        endcase
    end

endmodule