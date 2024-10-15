import re

# Diccionarios de mapeo (sin cambios)
conditions = {"AL": "00", "EQ": "01", "NE": "10", "GE": "11"}
types = {"REG": "00", "IMM": "01", "MEM": "10", "CTRL": "11"}
opcodes = {
    "REG": {"ADD": "000", "SUB": "001", "AND": "010", "MOV": "011", "LSL": "100", "UDIV": "101", "SUBS": "110"},
    "IMM": {"ADD": "000", "SUB": "001", "MOV": "010", "CMP": "011", "LSL": "100"},
    "MEM": {"LDR": "000", "LDRB": "001", "STR": "010", "STRB": "011"},
    "CTRL": {"B": "000", "PUSH": "001", "POP": "010"}
}


def register_to_binary(reg):
    return format(int(reg[1:]), '04b')


def immediate_to_binary(imm):
    if imm.startswith('#'):
        imm = imm[1:]
    if imm.startswith('0x'):
        value = int(imm, 16)
    else:
        value = int(imm)
    return format(value & 0xFFF, '012b')  # Limitar a 12 bits


def generate_opcode(instruction):
    parts = re.split(r'[,\s]+', instruction.strip())
    operation = parts[0].upper()

    # Determinar el tipo de instrucción
    if operation in opcodes["REG"]:
        type_code = types["REG"]
        opcode = opcodes["REG"][operation]
    elif operation in opcodes["IMM"]:
        type_code = types["IMM"]
        opcode = opcodes["IMM"][operation]
    elif operation in opcodes["MEM"]:
        type_code = types["MEM"]
        opcode = opcodes["MEM"][operation]
    elif operation in opcodes["CTRL"]:
        type_code = types["CTRL"]
        opcode = opcodes["CTRL"][operation]
    else:
        return f"Operación no reconocida: {operation}"

    # Determinar la condición (por defecto AL)
    condition = "00"  # AL por defecto
    for cond, code in conditions.items():
        if operation.endswith(cond):
            condition = code
            operation = operation[:-2]  # Remover el sufijo de condición
            break

    # Procesar los operandos
    try:
        if type_code == types["REG"]:
            rd = register_to_binary(parts[1])
            rn = register_to_binary(parts[2])
            operand2 = register_to_binary(parts[3]) + "00000000"  # Padding para llegar a 12 bits
        elif type_code == types["IMM"]:
            rd = register_to_binary(parts[1])
            rn = "0000"  # No se usa en operaciones inmediatas
            operand2 = immediate_to_binary(parts[2])
        elif type_code == types["MEM"]:
            rd = register_to_binary(parts[1])
            rn = register_to_binary(parts[2][1:-1])  # Quitar los corchetes
            operand2 = "000000000000"  # No se usa en operaciones de memoria
        elif type_code == types["CTRL"]:
            rd = "0000"
            rn = "0000"
            operand2 = immediate_to_binary(parts[1])
    except IndexError:
        return f"Error: faltan operandos en la instrucción: {instruction}"

    # Construir el opcode final
    final_opcode = f"{condition}{type_code}{opcode}{rd}{rn}{operand2}"
    return final_opcode


def process_assembly_code(code):
    lines = code.strip().split('\n')
    results = []
    for line in lines:
        line = line.split('@')[0].strip()  # Eliminar comentarios
        if line and not line.startswith('.'):  # Ignorar líneas vacías y directivas
            opcode = generate_opcode(line)
            results.append(f"{line}: {opcode}")
    return '\n'.join(results)


# Ejemplo de uso con las primeras instrucciones del código proporcionado
assembly_code = """
MOV R0, #0x1f4 
LDR R0, [R0]
MOV R1, #0x1f0 
LDR R1, [R1]
MOV R2, #100
MOV R3, #0
ADD R3, R3, #4080
"""

print(process_assembly_code(assembly_code))