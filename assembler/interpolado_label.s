.arch armv7ve
.data
MATRICES_BASE: .word 0x2a0
RESULTADO_BASE: .word 0x27500
SECTOR_SELECT: .word 0x28c

.text
.global main

main:
    @ Selección del sector
    LDR R9, =SECTOR_SELECT
    LDR R9, [R9]
    LDRB R8, [R9]               @ Cargar el valor del sector desde la dirección 0x200

    @ Tabla de saltos para los sectores
    ADR R7, sector_table
    LDR PC, [R7, R8, LSL #2]    @ Cargar la dirección del sector seleccionado en PC

sector_table:
    .word sector1, sector2, sector3, sector4, sector5, sector6, sector7, sector8
    .word sector9, sector10, sector11, sector12, sector13, sector14, sector15, sector16

sector1:
    LDR R10, =0x2a0
    B continue_main
sector2:
    LDR R10, =0x304
    B continue_main
sector3:
    LDR R10, =0x368
    B continue_main
sector4:
    LDR R10, =0x3cc
    B continue_main
sector5:
    LDR R10, =0x9ee0
    B continue_main
sector6:
    LDR R10, =0x9f44
    B continue_main
sector7:
    LDR R10, =0x9fa8
    B continue_main
sector8:
    LDR R10, =0xa00c
    B continue_main
sector9:
    LDR R10, =0x13b20
    B continue_main
sector10:
    LDR R10, =0x13b84
    B continue_main
sector11:
    LDR R10, =0x13be8
    B continue_main
sector12:
    LDR R10, =0x13c4c
    B continue_main
sector13:
    LDR R10, =0x1d760
    B continue_main
sector14:
    LDR R10, =0x1d7c4
    B continue_main
sector15:
    LDR R10, =0x1d828
    B continue_main
sector16:
    LDR R10, =0x1d88c

continue_main:
    @ Actualizar MATRICES_BASE con el nuevo valor
    LDR R9, =MATRICES_BASE
    STR R10, [R9]

    LDR R11, =RESULTADO_BASE
    LDR R11, [R11]               @ R11 = dirección base del resultado
    MOV R12, #50                 @ Contador de matrices 100x2 (ahora procesamos 2)

loop_100x2:
    PUSH {R10-R12}               @ Guardar registros importantes
    MOV R12, #50                 @ Contador de matrices 2x2

loop_matrices:
    @ Cargar las esquinas de la matriz actual
    LDRB R0, [R10]               @ Esquina superior izquierda
    LDRB R1, [R10, #1]           @ Esquina superior derecha
    LDRB R2, [R10, #400]         @ Esquina inferior izquierda
    LDRB R3, [R10, #401]         @ Esquina inferior derecha

    @ Cargar el valor 3 en un registro para las divisiones
    MOV R9, #3                   @ R9 = 3, divisor para las operaciones

    @ Calcular el offset para la matriz actual en el resultado
    MOV R8, #50                   
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
    STRB R4, [R11, #200]         @ Guardar en la posición (1,0)

    @ Calcular d = (2/3 * a) + (1/3 * f)
    LDRB R5, [R11, #1]           @ Cargar a
    MOV R6, R5, LSL #1           @ Multiplicar a por 2
    ADD R6, R6, R1               @ Sumar R1 (f aún no calculado, usamos R1 como aproximación)
    UDIV R6, R6, R9              @ Dividir por 3
    STRB R6, [R11, #201]         @ Guardar en la posición (1,1)

    @ Calcular e = (1/3 * a) + (2/3 * f)
    MOV R7, R1, LSL #1           @ Multiplicar R1 por 2 (f aproximado)
    ADD R7, R7, R5               @ Sumar a
    UDIV R7, R7, R9              @ Dividir por 3
    STRB R7, [R11, #202]         @ Guardar en la posición (1,2)

    @ Calcular f = (2/3 * R1) + (1/3 * R3)
    MOV R4, R1, LSL #1           @ Multiplicar R1 por 2
    ADD R4, R4, R3               @ Sumar R3
    UDIV R4, R4, R9              @ Dividir por 3
    STRB R4, [R11, #203]         @ Guardar en la posición (1,3)

    @ ---- Calcular y almacenar la tercera fila ----
    @ Calcular g = (1/3 * R0) + (2/3 * R2)
    MOV R5, R2, LSL #1           @ Multiplicar R2 por 2
    ADD R5, R5, R0               @ Sumar R0
    UDIV R5, R5, R9              @ Dividir por 3
    STRB R5, [R11, #400]         @ Guardar en la posición (2,0)

    @ Calcular h = (2/3 * g) + (1/3 * k)
    MOV R6, R5, LSL #1           @ Multiplicar g por 2
    ADD R6, R6, R2               @ Sumar R2 (k aproximado)
    UDIV R6, R6, R9              @ Dividir por 3
    STRB R6, [R11, #401]         @ Guardar en la posición (2,1)

    @ Calcular i = (1/3 * g) + (2/3 * k)
    MOV R7, R2, LSL #1           @ Multiplicar R2 por 2 (k aproximado)
    ADD R7, R7, R5               @ Sumar g
    UDIV R7, R7, R9              @ Dividir por 3
    STRB R7, [R11, #402]         @ Guardar en la posición (2,2)

    @ Calcular j = (1/3 * R1) + (2/3 * R3)
    MOV R4, R3, LSL #1           @ Multiplicar R3 por 2
    ADD R4, R4, R1               @ Sumar R1
    UDIV R4, R4, R9              @ Dividir por 3
    STRB R4, [R11, #403]         @ Guardar en la posición (2,3)

    @ ---- Calcular y almacenar la cuarta fila ----
    STRB R2, [R11, #600]         @ Guardar en la posición (3,0)

    @ Calcular k = (2/3 * R2) + (1/3 * R3)
    MOV R4, R2, LSL #1           @ Multiplicar R2 por 2
    ADD R4, R4, R3               @ Sumar R3
    UDIV R4, R4, R9              @ Dividir por 3
    STRB R4, [R11, #601]         @ Guardar en la posición (3,1)

    @ Calcular l = (1/3 * R2) + (2/3 * R3)
    MOV R5, R3, LSL #1           @ Multiplicar R3 por 2
    ADD R5, R5, R2               @ Sumar R2
    UDIV R5, R5, R9              @ Dividir por 3
    STRB R5, [R11, #602]         @ Guardar en la posición (3,2)

    STRB R3, [R11, #603]         @ Guardar en la posición (3,3)

    @ Preparar para la siguiente matriz
    ADD R10, R10, #2             @ Avanzar a la siguiente matriz en la entrada
    LDR R11, =RESULTADO_BASE
    LDR R11, [R11]               @ Restaurar R11 a la base del resultado
    SUBS R12, R12, #1            @ Decrementar el contador de matrices
    BNE loop_matrices            @ Si no hemos terminado, continuar con la siguiente matriz

    POP {R10-R12}                @ Restaurar registros importantes
    ADD R10, R10, #800           @ Mover a la siguiente columna de la matriz 100x4
    ADD R11, R11, #800           @ Ajustar el offset vertical en el resultado
    LDR R9, =RESULTADO_BASE      @ Cargar la dirección de RESULTADO_BASE
    STR R11, [R9]                @ Actualizar el valor de RESULTADO_BASE
    SUBS R12, R12, #1            @ Decrementar el contador de matrices 100x2
    BNE loop_100x2               @ Si no hemos terminado, continuar con la siguiente matriz 100x2

    @ ---- Terminar el programa de forma segura ----
    MOV R0, #0x18
    LDR R1, =0x20026
    SWI 0x123456