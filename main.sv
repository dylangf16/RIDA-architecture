module main ( input 			clock_50,
				  input 			reset,
				  input 			start,
				  input 			button,
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
	reg   [17:0] pixel_address;
	reg   [17:0] pixel_address_result;
	reg   [31:0] cpu_address;
	reg   [31:0] ram_address;
	reg   [31:0] cpu_data;
	reg   [31:0] ram_data;
	reg   	    cpu_wen;
	reg   	    ram_wen;
	logic [7:0]  pixel_data;
	logic [31:0] pixel_result;
	logic [31:0] quadrant;
		
	//Modulos
	clock25mh clock(clock_50, clock_25);   
	
	controlador_vga controlador (.clock_25(clock_25),
										  .reset(reset),
										  .start(start),
										  .quadrant(quadrant),
										  .data_drom(pixel_data),
										  .data_dram(pixel_result),
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
						
	dram ram_result(.address_a(ram_address),
						 .address_b(pixel_address_result),
						 .clock(clock_50),
	                .data_a(ram_data),
	                .wren_a(ram_wen),  
	                .q_b(pixel_result));
						 
	mux2 #(18) mux_direccion(.d1(cpu_address),
									 .d2(0),
									 .flag(start),
								    .out(ram_address));
	
	mux2 #(32) mux_data(.d1(cpu_data),
							  .d2(quadrant),
							  .flag(start),
							  .out(ram_data));
								
	mux2 #(1) mux_enable(.d1(cpu_wen),
							   .d2(~start),
							   .flag(start),
							   .out(ram_wen));
						  
	sumador #(18) sumador_dir_imagen(.a(pixel_address),
										      .b(6),
										      .result(pixel_address_result));
								 
	contador_cuadrante contador(.clock(clock_50),            
										 .reset(reset),        
										 .button(button),
										 .enable(~start),
										 .count(quadrant)); 
										 
	cpu cpu(.clk(clock_50),
			  .rst(reset));
				  
	assign vgaclock = clock_25;
		
endmodule 