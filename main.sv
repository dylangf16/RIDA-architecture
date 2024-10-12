module main ( input 			clock_50,
				  input 			reset,
				  input 			start,
				  output [7:0] red_out,
				  output [7:0] green_out,
				  output [7:0] blue_out,
				  output 		hsync,
				  output 		vsync,
				  output 		n_blank,
				  output 		vgaclock
);
	
	// Reloj
	logic clock_25;
	
	// ROM
	reg   [31:0] pixel_address;
	logic [31:0] pixel_data;
		
	//Modulos
	clock25mh clock(clock_50, clock_25);
	
	controlador_vga controlador (.clock_25(clock_25),
										  .reset(reset),
										  .start(start),
										  .data_drom(pixel_data),
										  .address(pixel_address),
										  .red(red_out),
										  .green(green_out),
										  .blue(blue_out),
										  .hsync(hsync), 
										  .vsync(vsync), 
										  .n_blank(n_blank));
											
	drom rom_image (.clock(clock_50),
						.address_b(pixel_address),
						.q_b(pixel_data));		
				
	assign vgaclock = clock_25;
		
endmodule 