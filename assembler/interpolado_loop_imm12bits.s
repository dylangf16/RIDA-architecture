.arch armv7ve
.data
MATRICES_BASE: .word 0x204
RESULTADO_BASE: .word 0x27310
SECTOR_SELECT: .word 0x200

.text
.global main

main:
    LDR R0, =MATRICES_BASE
    LDR R0, [R0]                @ R0 = dirección base de las matrices
    LDR R1, =SECTOR_SELECT
    LDR R1, [R1]
    LDRB R1, [R1]               @ R1 = número de sector (0-15)
    MOV R2, #100                 @ R2 = tamaño de incremento básico (64 bytes)
    @ Dividir 39700 en operaciones más pequeñas
    MOV R3, #0                  @ Inicializar R3
    ADD R3, R3, #4080
    ADD R3, R3, #4080
	ADD R3, R3, #4080          
    ADD R3, R3, #4080          
    ADD R3, R3, #4080          
    ADD R3, R3, #4080         
    ADD R3, R3, #4080          
    ADD R3, R3, #4080          
    ADD R3, R3, #4080          
    ADD R3, R3, #596
	ADD R3, R3, #596
	ADD R3, R3, #596
	ADD R3, R3, #596
	ADD R3, R3, #596
    MOV R4, #0                  @ R4 = contador de sectores
    MOV R10, R0                 @ R10 = dirección resultante, inicializada con MATRICES_BASE

calculate_sector:
    CMP R4, R1
    BGE continue_main           @ Si hemos alcanzado el sector deseado, terminamos
    ADD R4, R4, #1              @ Incrementamos el contador de sectores
    AND R5, R4, #3              @ Comprobamos si es múltiplo de 3
    CMP R5, #0
    ADDEQ R10, R10, R3          @ Si es múltiplo de 3, sumamos 0x9b14
    ADDNE R10, R10, R2          @ Si no es múltiplo de 3, sumamos 64 bytes
    B calculate_sector

continue_main:
    @ Actualizar MATRICES_BASE con el nuevo valor
    LDR R9, =MATRICES_BASE
    STR R10, [R9]

    LDR R11, =RESULTADO_BASE
    LDR R11, [R11]               @ R11 = dirección base del resultado
    MOV R12, #99                 @ Contador de matrices 100x2 (ahora procesamos 2)

loop_100x2:
    PUSH {R10-R12}               @ Guardar registros importantes
    MOV R12, #99                 @ Contador de matrices 2x2 de matrices horizontales

loop_matrices:
    @ Cargar las esquinas de la matriz actual
    LDRB R0, [R10]               @ Esquina superior izquierda
    LDRB R1, [R10, #1]           @ Esquina superior derecha
    LDRB R2, [R10, #400]         @ Esquina inferior izquierda
    LDRB R3, [R10, #401]         @ Esquina inferior derecha

    @ Cargar el valor 3 en un registro para las divisiones
    MOV R9, #3                   @ R9 = 3, divisor para las operaciones

    @ Calcular el offset para la matriz actual en el resultado
    MOV R8, #99                   
    SUB R8, R8, R12              @ R8 = índice de matriz (0-49)
    AND R7, R8, #3               @ R7 = columna (0-3)
    LSL R7, R7, #2               @ R7 *= 4 (offset horizontal en bytes)
    MOV R6, R8, LSR #2           @ R6 = fila (0-12)
    MOV R5, #16                  @ 16 bytes por fila en resultado
    MUL R6, R6, R5               @ R6 *= 16 (offset vertical en bytes)
    ADD R8, R7, R6               @ R8 = offset total
    ADD R11, R11, R8             @ Ajustar la dirección base del resultado para esta matriz

    @ ---- Calcular y almacenar la primera fila ----
    STRB R0, [R11]               @ Guardar en la posición (0,0)
    
    @ Calcular a = (2/3 * R0) + (1/3 * R1)
    MOV R4, R0, LSL #1           @ Multiplicar por 2
    ADD R4, R4, R1               @ Sumar R1
    UDIV R4, R4, R9              @ Dividir por 3
    STRB R4, [R11, #1]           @ Guardar en la posición (0,1)
    
    @ Calcular b = (1/3 * R0) + (2/3 * R1)
    MOV R5, R1, LSL #1           @ Multiplicar R1 por 2
    ADD R5, R5, R0               @ Sumar R0
    UDIV R5, R5, R9              @ Dividir por 3
    STRB R5, [R11, #2]           @ Guardar en la posición (0,2)
    STRB R1, [R11, #3]           @ Guardar en la posición (0,3)

    @ ---- Calcular y almacenar la segunda fila ----
    @ Calcular c = (2/3 * R0) + (1/3 * R2)
    MOV R4, R0, LSL #1           @ Multiplicar R0 por 2
    ADD R4, R4, R2               @ Sumar R2
    UDIV R4, R4, R9              @ Dividir por 3
    STRB R4, [R11, #396]         @ Guardar en la posición (1,0)

    @ Calcular d = (2/3 * a) + (1/3 * f)
    LDRB R5, [R11, #1]           @ Cargar a
    MOV R6, R5, LSL #1           @ Multiplicar a por 2
    ADD R6, R6, R1               @ Sumar R1 (f aún no calculado, usamos R1 como aproximación)
    UDIV R6, R6, R9              @ Dividir por 3
    STRB R6, [R11, #397]         @ Guardar en la posición (1,1)

    @ Calcular e = (1/3 * a) + (2/3 * f)
    MOV R7, R1, LSL #1           @ Multiplicar R1 por 2 (f aproximado)
    ADD R7, R7, R5               @ Sumar a
    UDIV R7, R7, R9              @ Dividir por 3
    STRB R7, [R11, #398]         @ Guardar en la posición (1,2)

    @ Calcular f = (2/3 * R1) + (1/3 * R3)
    MOV R4, R1, LSL #1           @ Multiplicar R1 por 2
    ADD R4, R4, R3               @ Sumar R3
    UDIV R4, R4, R9              @ Dividir por 3
    STRB R4, [R11, #399]         @ Guardar en la posición (1,3)

    @ ---- Calcular y almacenar la tercera fila ----
    @ Calcular g = (1/3 * R0) + (2/3 * R2)
    MOV R5, R2, LSL #1           @ Multiplicar R2 por 2
    ADD R5, R5, R0               @ Sumar R0
    UDIV R5, R5, R9              @ Dividir por 3
    STRB R5, [R11, #792]         @ Guardar en la posición (2,0)

    @ Calcular h = (2/3 * g) + (1/3 * k)
    MOV R6, R5, LSL #1           @ Multiplicar g por 2
    ADD R6, R6, R2               @ Sumar R2 (k aproximado)
    UDIV R6, R6, R9              @ Dividir por 3
    STRB R6, [R11, #793]         @ Guardar en la posición (2,1)

    @ Calcular i = (1/3 * g) + (2/3 * k)
    MOV R7, R2, LSL #1           @ Multiplicar R2 por 2 (k aproximado)
    ADD R7, R7, R5               @ Sumar g
    UDIV R7, R7, R9              @ Dividir por 3
    STRB R7, [R11, #794]         @ Guardar en la posición (2,2)

    @ Calcular j = (1/3 * R1) + (2/3 * R3)
    MOV R4, R3, LSL #1           @ Multiplicar R3 por 2
    ADD R4, R4, R1               @ Sumar R1
    UDIV R4, R4, R9              @ Dividir por 3
    STRB R4, [R11, #795]         @ Guardar en la posición (2,3)

    @ ---- Calcular y almacenar la cuarta fila ----
    STRB R2, [R11, #1188]         @ Guardar en la posición (3,0)

    @ Calcular k = (2/3 * R2) + (1/3 * R3)
    MOV R4, R2, LSL #1           @ Multiplicar R2 por 2
    ADD R4, R4, R3               @ Sumar R3
    UDIV R4, R4, R9              @ Dividir por 3
    STRB R4, [R11, #1189]         @ Guardar en la posición (3,1)

    @ Calcular l = (1/3 * R2) + (2/3 * R3)
    MOV R5, R3, LSL #1           @ Multiplicar R3 por 2
    ADD R5, R5, R2               @ Sumar R2
    UDIV R5, R5, R9              @ Dividir por 3
    STRB R5, [R11, #1190]         @ Guardar en la posición (3,2)

    STRB R3, [R11, #1191]         @ Guardar en la posición (3,3)

    @ Preparar para la siguiente matriz
    ADD R10, R10, #1             @ Avanzar a la siguiente matriz en la entrada
    LDR R11, =RESULTADO_BASE
    LDR R11, [R11]               @ Restaurar R11 a la base del resultado
    SUBS R12, R12, #1            @ Decrementar el contador de matrices
    BNE loop_matrices            @ Si no hemos terminado, continuar con la siguiente matriz

    POP {R10-R12}                @ Restaurar registros importantes
    ADD R10, R10, #400           @ Mover a la siguiente columna de la matriz 100x2
    ADD R11, R11, #1584        	 @ (396*4) 396 = 99*4
    LDR R9, =RESULTADO_BASE      @ Cargar la dirección de RESULTADO_BASE
    STR R11, [R9]                @ Actualizar el valor de RESULTADO_BASE
    SUBS R12, R12, #1            @ Decrementar el contador de matrices 100x2
    BNE loop_100x2               @ Si no hemos terminado, continuar con la siguiente matriz 100x2

    @ ---- Terminar el programa de forma segura ----
    MOV R0, #0x18
    LDR R1, =0x20026
    SWI 0x123456