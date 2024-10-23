`timescale 1ns / 1ps

module fetch_tb();

    // Señales de prueba
    reg clk, rst;
    reg PCSrcE;
    reg [31:0] PCTargetE;
    wire [31:0] InstrD, PCD, PCPlus4D;

    // Instanciación del módulo Fetch_Cycle
    Fetch_Cycle uut (
        .clk(clk),
        .rst(rst),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D)
    );

    // Generación de reloj
    always #5 clk = ~clk;

    // Procedimiento de prueba
    // Procedimiento de prueba
		initial begin
			 // Inicialización
			 clk = 0;
			 rst = 0;
			 PCSrcE = 0;
			 PCTargetE = 32'd0;

			 // Reset the CPU
			 #10 rst = 1;

			 // Load first 50 instructions
			 repeat(50) @(posedge clk);

			 // Branch to instruction 70
			 PCSrcE = 1;
			 PCTargetE = 32'd72;  // Multiply by 4 for byte addressing
			 repeat(2) @(posedge clk);  // Hold the branch signal for 2 clock cycles
			 PCSrcE = 0;

			 // Load 10 instructions starting from 70
			 repeat(10) @(posedge clk);

			 // Branch back to instruction 10
			 PCSrcE = 1;
			 PCTargetE = 32'd10;  // Multiply by 4 for byte addressing
			 repeat(2) @(posedge clk);  // Hold the branch signal for 2 clock cycles
			 PCSrcE = 0;

			 // Load 20 instructions starting from 10
			 repeat(20) @(posedge clk);

			 // End simulation
			 #10 $finish;
		end

    // Monitor
    always @(posedge clk) begin
        if (rst) begin
            $display("Time=%0t ns: PC=%0d, Instruction=%b, PCTargetE=%d", $time, PCD, InstrD, PCTargetE);
        end
    end

endmodule