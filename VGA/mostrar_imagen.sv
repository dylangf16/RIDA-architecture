module mostrar_imagen (input        [0:9]  x, 
							  input        [0:9]  y,
							  input               reset,
							  input               start,
							  input  reg   [31:0] data_drom,
							  output logic [7:0]  red,
							  output logic [7:0]  green,
							  output logic [7:0]  blue);
	

	// Variables requeridas
	logic [7:0] pixel_data;
	
	
	always_comb begin
	
		pixel_data = 0;
		red = 8'b00000000;
		green = 8'b00000000;
		blue = 8'b00000000;
		
		if (reset) begin
			red = 8'b00000000;
			green = 8'b00000000;
			blue = 8'b00000000;
		end
		
		else begin
			if ((x >= 0 && x <= 399) && (y >= 0 && y <= 399)) begin	
				pixel_data = data_drom[7:0];
				
				red = pixel_data;
				green = pixel_data;
				blue = pixel_data;
			end
			
			else begin
				red = 8'b00000000;
				green = 8'b00000000;
				blue = 8'b00000000;
			end
		end
		
	end
	
endmodule 