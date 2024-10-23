module contador_cuadrante(
    input logic clock,            // Reloj de la FPGA
    input logic reset,          // Botón de reinicio manual
    input logic button,         // Botón para incrementar el contador
	 input logic enable,
    output logic [4:0] count    // Salida del contador (4 bits para contar hasta 8)
);

    // Registro para almacenar el valor del contador
    logic [4:0] counter;
    // Registro para detectar el flanco ascendente del botón
    logic button_sync1, button_sync2, button_pressed;

    // Sincronización del botón a la señal de reloj
    always_ff @(posedge clock) begin
        button_sync1 <= button;
        button_sync2 <= button_sync1;
    end

    // Detección de flanco ascendente del botón
    assign button_pressed = button_sync2 & ~button_sync1;

    // Lógica del contador
    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            counter <= 1; // Reinicia el contador si el botón de reset está activo
        end else if (enable & button_pressed) begin
            if (counter == 16) begin
                counter <= 1; // Reinicia el contador al llegar a 10
            end else begin
                counter <= counter + 1; // Incrementa el contador
            end
        end
    end

    // Asignación de la salida
    assign count = counter;

endmodule
