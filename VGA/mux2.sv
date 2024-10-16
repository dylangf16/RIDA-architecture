module mux2 #(parameter WIDTH = 8) (input  logic [WIDTH-1:0] d1, d2,
												input  logic             flag,
												output logic [WIDTH-1:0] out);
				  
		assign out = flag? d1 : d2;
		
endmodule