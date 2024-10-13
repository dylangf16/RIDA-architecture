module mostrar_imagen (input        [0:9] x, 
							  input        [0:9] y,
							  input              reset,
							  input  logic [4:0] quadrant,
							  input  reg   [7:0] data_drom,
							  output logic [7:0] red,
							  output logic [7:0] green,
							  output logic [7:0] blue);
	
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
			if ((x >= 20 && x <= 419) && (y >= 40 && y <= 439)) begin	
				pixel_data = data_drom[7:0];
				
				red = pixel_data;
				green = pixel_data;
				blue = pixel_data;
			end
			
			else if ((x >= 490 && x <= 589) && (y >= 190 && y <= 289)) begin
            case (quadrant)
                1: if (dibujar_numero_1(x, y)) pixel_data = 8'b11111111; // Número 1
                2: if (dibujar_numero_2(x, y)) pixel_data = 8'b11111111; // Número 2
                3: if (dibujar_numero_3(x, y)) pixel_data = 8'b11111111; // Número 3
                4: if (dibujar_numero_4(x, y)) pixel_data = 8'b11111111; // Número 4
                5: if (dibujar_numero_5(x, y)) pixel_data = 8'b11111111; // Número 5
                6: if (dibujar_numero_6(x, y)) pixel_data = 8'b11111111; // Número 6
                7: if (dibujar_numero_7(x, y)) pixel_data = 8'b11111111; // Número 7
                8: if (dibujar_numero_8(x, y)) pixel_data = 8'b11111111; // Número 8
                9: if (dibujar_numero_9(x, y)) pixel_data = 8'b11111111; // Número 9
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
                           ((x >= 570 && x <= 579) && (y >= 240 && y <= 279));     // Línea vertical derecha inferior             // Línea vertical derecha inferior
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
	 
endmodule 