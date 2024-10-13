module controlador_vga (input               clock_25,
								input               reset,
								input  logic [4:0]  quadrant,
								input  reg   [7:0]  data_drom,
								output reg   [17:0] address,
								output       [7:0]  red,
								output       [7:0]  green,
								output       [7:0]  blue,
								output              hsync,
								output              vsync,
								output              n_blank);
	
	// Variables requeridas
	logic [0:9] pixel_num;
	logic [0:9] linea_num;
	logic       cambio_linea;
	logic       reset_temp = 0;
	
	
	//Instancias de módulos
	contador_horizontal contador_horizontal (.reloj(clock_25), 
														  .reset(reset_temp), 
														  .numero_pixel(pixel_num), 
														  .cambio_linea(cambio_linea));											
										
	contador_vertical contador_vertical (.reloj(cambio_linea),
													 .reset(reset_temp),
													 .numero_linea(linea_num));					
			
	sincronizador sincronizador(.pixel_num(pixel_num),
										 .linea_num(linea_num),
										 .hsync(hsync), 
										 .vsync(vsync), 
										 .n_blank(n_blank));								
										
	mostrar_imagen generarImagen(.x(pixel_num), 
										 .y(linea_num),
										 .reset(reset),
										 .quadrant(quadrant),
										 .data_drom(data_drom),
										 .red(red), 
										 .green(green), 
										 .blue(blue));
																									
  	contador_direccion #(18) contador(.clk(clock_25), 
												 .reset(reset),
												 .x(pixel_num), 
												 .y(linea_num),
												 .out(address));

endmodule