module Data_Memory(
    input clk,
    input rst,
    input WE,
    input [31:0] A,
    input [31:0] WD,
    output [31:0] RD
);

    // ROM for pixel data
    logic [7:0] pixel_data;
    logic [17:0] pixel_address;

    drom rom_data (
        .clock(clk),
        .address_a(pixel_address),
        .q_a(pixel_data)
    );

    // RAM for results
    logic [31:0] pixel_result;
    logic [31:0] ram_data;
    logic [17:0] pixel_address_result;
    logic [31:0] protected_write_data;

    dram ram_result(
        .address_a(A[17:0]),
        .address_b(pixel_address_result),
        .clock(clk),
        .data_a(protected_write_data),
        .wren_a(WE),  
        .q_a(ram_data),
        .q_b(pixel_result)
    );

    // Logic to protect first 6 bits
    always_comb begin
        if (WE) begin
            protected_write_data[31:6] = WD[31:6];
            protected_write_data[5:0] = ram_data[5:0];  // Preserve existing 6 bits
        end else begin
            protected_write_data = WD;  // Not used when not writing
        end
    end

    // Output logic
    assign RD = rst ? ram_data : 32'd0;

    // Address calculation
    always_comb begin
        pixel_address = A[17:0];
        pixel_address_result = A[17:0];
    end

endmodule