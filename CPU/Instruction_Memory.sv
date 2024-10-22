module Instruction_Memory(
    input wire clk,
    input wire rst,
    input wire [31:0] A,
    output wire [31:0] RD
);

    wire [6:0] rom_address;
    wire [31:0] rom_data;

    // Convert byte address to word address
    assign rom_address = A[8:2];  // We use 7 bits to address 128 words

    // Instantiate the ROM module
    instrROM rom_inst (
        .address(rom_address),
        .clock(clk),
        .q(rom_data)
    );

    // Output logic
    assign RD = (rst == 1'b0) ? 32'b0 : rom_data;

endmodule