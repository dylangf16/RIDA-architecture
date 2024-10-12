module contador_direccion #(parameter n = 5) (input  logic         clk,      
															 input  logic         reset,  
															 input        [0:9]   x, 
															 input        [0:9]   y,		
															 output reg   [n-1:0] out);  
	
	// Variables requeridas	
	reg [n-1:0] contador = 0;
	
	always @ (posedge clk) begin
		
		if (reset) contador = 0;
		
		else begin
			if (x == 0 && y == 0) contador = 0;
			else if ((x >= 0 && x <= 399) && (y >= 0 && y <= 399)) contador = contador + 1'b1;			
		end
				
	end 
	
	assign out = contador;

endmodule