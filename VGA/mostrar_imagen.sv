module mostrar_imagen (input        [0:9]  x, 
							  input        [0:9]  y,
							  input               reset,
							  input               start,
							  input  logic [4:0]  quadrant,
							  input  reg   [7:0]  data_drom,
							  input  reg   [31:0] data_dram,
							  output logic [7:0]  red,
							  output logic [7:0]  green,
							  output logic [7:0]  blue);
	
	logic [7:0] pixel_data;
	logic       in_border;
	
	always_comb begin
	
		pixel_data = 0;
		red = 8'b00000000;
		green = 8'b00000000;
		blue = 8'b00000000;
		in_border = 0;
		
		
		if (reset) begin
			red = 8'b00000000;
			green = 8'b00000000;
			blue = 8'b00000000;
		end
		
		else begin
		
			if ((x >= 20 && x <= 419) && (y >= 40 && y <= 439)) begin	
			
				if (start) begin
				pixel_data = data_dram[7:0];
				
				red = pixel_data;
				green = pixel_data;
				blue = pixel_data;
				
				end
				
				else begin
					case (quadrant)
                        1:  in_border = cuadrante_1 (x, y);
                        2:  in_border = cuadrante_2 (x, y);
                        3:  in_border = cuadrante_3 (x, y);
                        4:  in_border = cuadrante_4 (x, y);
                        5:  in_border = cuadrante_5 (x, y);
                        6:  in_border = cuadrante_6 (x, y);
								7:  in_border = cuadrante_7 (x, y);
                        8:  in_border = cuadrante_8 (x, y);
                        9:  in_border = cuadrante_9 (x, y);
                        10: in_border = cuadrante_10(x, y);
                        11: in_border = cuadrante_11(x, y);
                        12: in_border = cuadrante_12(x, y);
								13: in_border = cuadrante_13(x, y);
                        14: in_border = cuadrante_14(x, y);
                        15: in_border = cuadrante_15(x, y);
                        16: in_border = cuadrante_16(x, y);
                        default: in_border = 0;
                    endcase

                    if (in_border) begin
                        red = 8'b11111111;
                        green = 8'b00000000;
                        blue = 8'b00000000;
                    end
                    else begin
                        pixel_data = data_drom;
                        red = pixel_data;
                        green = pixel_data;
                        blue = pixel_data;
                    end
				end
			end
			
			else if ((x >= 490 && x <= 589) && (y >= 190 && y <= 289)) begin
			
            case (quadrant)
                1:  if (dibujar_numero_1 (x, y)) pixel_data = 8'b11111111; // Número 1
                2:  if (dibujar_numero_2 (x, y)) pixel_data = 8'b11111111; // Número 2
                3:  if (dibujar_numero_3 (x, y)) pixel_data = 8'b11111111; // Número 3
                4:  if (dibujar_numero_4 (x, y)) pixel_data = 8'b11111111; // Número 4
                5:  if (dibujar_numero_5 (x, y)) pixel_data = 8'b11111111; // Número 5
                6:  if (dibujar_numero_6 (x, y)) pixel_data = 8'b11111111; // Número 6
                7:  if (dibujar_numero_7 (x, y)) pixel_data = 8'b11111111; // Número 7
                8:  if (dibujar_numero_8 (x, y)) pixel_data = 8'b11111111; // Número 8
					 9:  if (dibujar_numero_9 (x, y)) pixel_data = 8'b11111111; // Número 9
                10: if (dibujar_numero_10(x, y)) pixel_data = 8'b11111111; // Número 10
					 11: if (dibujar_numero_11(x, y)) pixel_data = 8'b11111111; // Número 11
                12: if (dibujar_numero_12(x, y)) pixel_data = 8'b11111111; // Número 12
                13: if (dibujar_numero_13(x, y)) pixel_data = 8'b11111111; // Número 13
                14: if (dibujar_numero_14(x, y)) pixel_data = 8'b11111111; // Número 14
                15: if (dibujar_numero_15(x, y)) pixel_data = 8'b11111111; // Número 15
					 16: if (dibujar_numero_16(x, y)) pixel_data = 8'b11111111; // Número 16
                default: pixel_data = 8'b00000000;
            endcase
				
				red = pixel_data;
				green = 8'b00000000;
				blue = 8'b00000000;
         end
			
			else begin
				red = 8'b00000000;
				green = 8'b00000000;
				blue = 8'b00000000;
			end
		end	
	end
	
	function logic cuadrante_1(input [9:0] x, input [9:0] y);
       cuadrante_1 = (x >= 20 && x <= 119) && (y == 40 || y == 139) || // Lineas horizontales del cuadro
							 (x == 20 || x == 119) && (y >= 40 && y <= 139);   // Lineas verticales del cuadro
   endfunction
	
	function logic cuadrante_2(input [9:0] x, input [9:0] y);
       cuadrante_2 = (x >= 120 && x <= 219) && (y == 40 || y == 139) || // Lineas horizontales del cuadro
							 (x == 120 || x == 219) && (y >= 40 && y <= 139);   // Lineas verticales del cuadro
   endfunction
	
	function logic cuadrante_3(input [9:0] x, input [9:0] y); 
       cuadrante_3 = (x >= 220 && x <= 319) && (y == 40 || y == 139) || // Lineas horizontales del cuadro
							 (x == 220 || x == 319) && (y >= 40 && y <= 139);   // Lineas verticales del cuadro
   endfunction
	
	function logic cuadrante_4(input [9:0] x, input [9:0] y);
       cuadrante_4 = (x >= 320 && x <= 419) && (y == 40 || y == 139) || // Lineas horizontales del cuadro
							 (x == 320 || x == 419) && (y >= 40 && y <= 139);   // Lineas verticales del cuadro					 
	endfunction	
		
	function logic cuadrante_5(input [9:0] x, input [9:0] y);
       cuadrante_5 = (x >= 20 && x <= 119) && (y == 140 || y == 239) || // Lineas horizontales del cuadro
							 (x == 20 || x == 119) && (y >= 140 && y <= 239);   // Lineas verticales del cuadro
   endfunction
	
	function logic cuadrante_6(input [9:0] x, input [9:0] y);
       cuadrante_6 = (x >= 120 && x <= 219) && (y == 140 || y == 239) || // Lineas horizontales del cuadro
							 (x == 120 || x == 219) && (y >= 140 && y <= 239);   // Lineas verticales del cuadro
   endfunction
	
	function logic cuadrante_7(input [9:0] x, input [9:0] y); 
       cuadrante_7 = (x >= 220 && x <= 319) && (y == 140 || y == 239) || // Lineas horizontales del cuadro
							 (x == 220 || x == 319) && (y >= 140 && y <= 239);   // Lineas verticales del cuadro
   endfunction
	
	function logic cuadrante_8(input [9:0] x, input [9:0] y);
       cuadrante_8 = (x >= 320 && x <= 419) && (y == 140 || y == 239) || // Lineas horizontales del cuadro
							 (x == 320 || x == 419) && (y >= 140 && y <= 239);   // Lineas verticales del cuadro					 
	endfunction	
		
	function logic cuadrante_9(input [9:0] x, input [9:0] y);
       cuadrante_9 = (x >= 20 && x <= 119) && (y == 240 || y == 339) || // Lineas horizontales del cuadro
							 (x == 20 || x == 119) && (y >= 240 && y <= 339);   // Lineas verticales del cuadro
   endfunction
	
	function logic cuadrante_10(input [9:0] x, input [9:0] y);
       cuadrante_10 = (x >= 120 && x <= 219) && (y == 240 || y == 339) || // Lineas horizontales del cuadro
							 (x == 120 || x == 219) && (y >= 240 && y <= 339);   // Lineas verticales del cuadro
   endfunction
	
	function logic cuadrante_11(input [9:0] x, input [9:0] y); 
       cuadrante_11 = (x >= 220 && x <= 319) && (y == 240 || y == 339) || // Lineas horizontales del cuadro
							 (x == 220 || x == 319) && (y >= 240 && y <= 339);   // Lineas verticales del cuadro
   endfunction
	
	function logic cuadrante_12(input [9:0] x, input [9:0] y);
       cuadrante_12 = (x >= 320 && x <= 419) && (y == 240 || y == 339) || // Lineas horizontales del cuadro
							 (x == 320 || x == 419) && (y >= 240 && y <= 339);   // Lineas verticales del cuadro					 
	endfunction	
	
		function logic cuadrante_13(input [9:0] x, input [9:0] y);
       cuadrante_13 = (x >= 20 && x <= 119) && (y == 340 || y == 439) || // Lineas horizontales del cuadro
							 (x == 20 || x == 119) && (y >= 340 && y <= 439);   // Lineas verticales del cuadro
   endfunction
	
	function logic cuadrante_14(input [9:0] x, input [9:0] y);
       cuadrante_14 = (x >= 120 && x <= 219) && (y == 340 || y == 439) || // Lineas horizontales del cuadro
							 (x == 120 || x == 219) && (y >= 340 && y <= 439);   // Lineas verticales del cuadro
   endfunction
	
	function logic cuadrante_15(input [9:0] x, input [9:0] y); 
       cuadrante_15 = (x >= 220 && x <= 319) && (y == 340 || y == 439) || // Lineas horizontales del cuadro
							 (x == 220 || x == 319) && (y >= 340 && y <= 439);   // Lineas verticales del cuadro
   endfunction
	
	function logic cuadrante_16(input [9:0] x, input [9:0] y);
       cuadrante_16 = (x >= 320 && x <= 419) && (y == 340 || y == 439) || // Lineas horizontales del cuadro
							 (x == 320 || x == 419) && (y >= 340 && y <= 439);   // Lineas verticales del cuadro					 
	endfunction	
		
// ---------------------------------------------------------------------------------------------------------------------------------------------------
	 
	function logic dibujar_numero_1(input [9:0] x, input [9:0] y);
       dibujar_numero_1 = (x >= 535 && x <= 544) && (y >= 200 && y <= 279); // Representación simple del número 1
   endfunction

   function logic dibujar_numero_2(input [9:0] x, input [9:0] y);
		 dibujar_numero_2 = ((x >= 500 && x <= 579) && ((y >= 200 && y <= 209) || (y >= 235 && y <= 244) || (y >= 270 && y <= 279))) || // Líneas horizontales en la parte superior, media y parte inferior
                          ((x >= 570 && x <= 579) && (y >= 200 && y <= 239)) ||    // Línea vertical derecha superior
                          ((x >= 500 && x <= 509) && (y >= 240 && y <= 279));     // Línea vertical izquierda inferior
	endfunction

	function logic dibujar_numero_3(input [9:0] x, input [9:0] y);
		 dibujar_numero_3 = ((x >= 500 && x <= 579) && ((y >= 200 && y <= 209) || (y >= 235 && y <= 244) || (y >= 270 && y <= 279)) || // Líneas horizontales
                          ((x >= 570 && x <= 579) && (y >= 200 && y <= 279)));     // Línea vertical derecha
	endfunction

	function logic dibujar_numero_4(input [9:0] x, input [9:0] y);
		 dibujar_numero_4 = ((x >= 500 && x <= 509) && (y >= 200 && y <= 239)) || // Línea vertical izquierda superior
                          ((x >= 570 && x <= 579) && (y >= 200 && y <= 279)) || // Línea vertical derecha completa
                          ((x >= 500 && x <= 579) && (y >= 235 && y <= 244));   // Línea horizontal del medio
	endfunction

	function logic dibujar_numero_5(input [9:0] x, input [9:0] y);
		 dibujar_numero_5 = ((x >= 500 && x <= 579) && ((y >= 200 && y <= 209) || (y >= 235 && y <= 244) || (y >= 270 && y <= 279))) || // Líneas horizontales en la parte superior, media y parte inferior
                          ((x >= 500 && x <= 509) && (y >= 200 && y <= 239)) ||    // Línea vertical izquierda superior
                          ((x >= 570 && x <= 579) && (y >= 240 && y <= 279));     // Línea vertical derecha inferior            
	endfunction

   function logic dibujar_numero_6(input [9:0] x, input [9:0] y);
		 dibujar_numero_6 = ((x >= 500 && x <= 579) && ((y >= 200 && y <= 209) || (y >= 235 && y <= 244) || (y >= 270 && y <= 279))) || // Líneas horizontales
                          ((x >= 500 && x <= 509) && (y >= 200 && y <= 279)) ||             // Línea vertical izquierda completa
                          ((x >= 570 && x <= 579) && (y >= 239 && y <= 279));              // Línea vertical derecha inferior
	endfunction

   function logic dibujar_numero_7(input [9:0] x, input [9:0] y);
		 dibujar_numero_7 = ((x >= 500 && x <= 579) && (y >= 200 && y <= 209)) ||   // Línea horizontal superior
                          ((x >= 570 && x <= 579) && (y >= 200 && y <= 279));     // Línea vertical derecha completa
	endfunction

	function logic dibujar_numero_8(input [9:0] x, input [9:0] y);
		 dibujar_numero_8 = ((x >= 500 && x <= 579) && ((y >= 200 && y <= 209) || (y >= 235 && y <= 244) || (y >= 270 && y <= 279))) || // Líneas horizontales
                          ((x >= 500 && x <= 509) && (y >= 200 && y <= 279)) ||             // Línea vertical izquierda completa
                          ((x >= 570 && x <= 579) && (y >= 200 && y <= 279));              // Línea vertical derecha completa
	endfunction

	function logic dibujar_numero_9(input [9:0] x, input [9:0] y);
		 dibujar_numero_9 = ((x >= 500 && x <= 579) && ((y >= 200 && y <= 209) || (y >= 235 && y <= 244) || (y >= 270 && y <= 279))) || // Líneas horizontales
                          ((x >= 500 && x <= 509) && (y >= 200 && y <= 239)) ||             // Línea vertical izquierda superior
                          ((x >= 570 && x <= 579) && (y >= 200 && y <= 279));               // Línea vertical derecha completa
	endfunction	 
	 
	function logic dibujar_numero_10(input [9:0] x, input [9:0] y);
		 dibujar_numero_10 = ((x >= 500 && x <= 509) && (y >= 200 && y <= 279)) ||  // Numero uno inicial
                           ((x >= 520 && x <= 579) && ((y >= 200 && y <= 209) || (y >= 270 && y <= 279))) ||  // Líneas horizontales
                           (((x >= 520 && x <= 529) || (x >= 570 && x <= 579)) && (y >= 200 && y <= 279));    // Lineas verticales
	endfunction	
	
	function logic dibujar_numero_11(input [9:0] x, input [9:0] y);
		 dibujar_numero_11 = ((x >= 500 && x <= 509) && (y >= 200 && y <= 279)) ||  // Numero uno inicial
                           ((x >= 555 && x <= 564) && (y >= 200 && y <= 279));    // Línea vertical derecha completa
	endfunction
	 
	function logic dibujar_numero_12(input [9:0] x, input [9:0] y);
		 dibujar_numero_12 = ((x >= 500 && x <= 509) && (y >= 200 && y <= 279)) ||  // Numero uno inicial
                           ((x >= 520 && x <= 579) && ((y >= 200 && y <= 209) || (y >= 235 && y <= 244) || (y >= 270 && y <= 279))) || // Líneas horizontales en la parte superior, media y parte inferior
                           ((x >= 570 && x <= 579) && (y >= 200 && y <= 239)) ||    // Línea vertical derecha superior
                           ((x >= 520 && x <= 529) && (y >= 240 && y <= 279));
   endfunction
	 
	function logic dibujar_numero_13(input [9:0] x, input [9:0] y);
		 dibujar_numero_13 = ((x >= 500 && x <= 509) && (y >= 200 && y <= 279)) ||  // Numero uno inicial
                           ((x >= 520 && x <= 579) && ((y >= 200 && y <= 209) || (y >= 235 && y <= 244) || (y >= 270 && y <= 279)) || // Líneas horizontales
                           ((x >= 570 && x <= 579) && (y >= 200 && y <= 279)));
	endfunction
	 
	function logic dibujar_numero_14(input [9:0] x, input [9:0] y);
		 dibujar_numero_14 = ((x >= 500 && x <= 509) && (y >= 200 && y <= 279)) || // Numero uno inicial
                           ((x >= 520 && x <= 529) && (y >= 200 && y <= 239)) || // Línea vertical izquierda superior
                           ((x >= 570 && x <= 579) && (y >= 200 && y <= 279)) || // Línea vertical derecha completa
                           ((x >= 520 && x <= 579) && (y >= 235 && y <= 244));   // Línea horizontal del medio
	endfunction
	 
	function logic dibujar_numero_15(input [9:0] x, input [9:0] y);
		 dibujar_numero_15 = ((x >= 500 && x <= 509) && (y >= 200 && y <= 279)) || // Numero uno inicial
                           ((x >= 520 && x <= 579) && ((y >= 200 && y <= 209) || (y >= 235 && y <= 244) || (y >= 270 && y <= 279))) || // Líneas horizontales en la parte superior, media y parte inferior
                           ((x >= 520 && x <= 529) && (y >= 200 && y <= 239)) ||    // Línea vertical izquierda superior
                           ((x >= 570 && x <= 579) && (y >= 240 && y <= 279));     // Línea vertical derecha inferior 
	endfunction
	 
	function logic dibujar_numero_16(input [9:0] x, input [9:0] y);
		 dibujar_numero_16 = ((x >= 500 && x <= 509) && (y >= 200 && y <= 279)) || // Numero uno inicial
                           ((x >= 520 && x <= 579) && ((y >= 200 && y <= 209) || (y >= 235 && y <= 244) || (y >= 270 && y <= 279))) || // Líneas horizontales
                           ((x >= 520 && x <= 529) && (y >= 200 && y <= 279)) ||             // Línea vertical izquierda completa
                           ((x >= 570 && x <= 579) && (y >= 239 && y <= 279));              // Línea vertical derecha inferior
	endfunction
	 
endmodule 