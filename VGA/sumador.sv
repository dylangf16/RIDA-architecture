module sumador #(parameter WIDTH = 8)( input logic  [WIDTH-1:0] a, // Primer registro de entrada
                                       input logic  [WIDTH-1:0] b, // Segundo registro de entrada
                                       output logic [WIDTH-1:0] result // Resultado de la operación
);
    assign result = a + b;
	 
endmodule
