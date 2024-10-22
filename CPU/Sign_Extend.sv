module Sign_Extend(
    input [31:0] In,        // Entrada completa de la instrucción
    input [1:0] ImmSrc,     // Control de la fuente del inmediato
    output reg [31:0] Imm_Ext  // Salida extendida
);

    always @(*) begin
        case (ImmSrc)
            2'b00: Imm_Ext = {{18{In[13]}}, In[13:0]};  // Extiende los 14 bits del Operando2
            2'b01: Imm_Ext = {{18{In[13]}}, In[13:0]};  // Misma extension para todos los casos
            2'b10: Imm_Ext = {{18{In[13]}}, In[13:0]};  
            default: Imm_Ext = 32'h00000000;            // Valor por defecto
        endcase
    end

endmodule
