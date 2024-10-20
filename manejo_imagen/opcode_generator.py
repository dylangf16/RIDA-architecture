import re

# Diccionarios para mapear operaciones a sus códigos binarios
conditions = {"AL": "00", "EQ": "01", "NE": "10", "GE": "11"}
types = {"REG": "00", "IMM": "01", "MEM": "10", "CTRL": "11"}
opcodes = {
    "REG": {"ADD": "000", "SUB": "001", "AND": "010", "MOV": "011", "CMP": "100", "UDIV": "101", "SUBS": "110", "MUL": "111"},
    "IMM": {"ADD": "000", "SUB": "001", "AND": "010", "MOV": "011", "CMP": "100", "LSL": "101"},
    "MEM": {"LDR": "000", "LDRB": "001", "STR": "010", "STRB": "011"},
    "CTRL": {"B": "000", "PUSH": "001", "POP": "010", "CMP": "100"}
}
mov_shifts = {"Normal": "00", "LSR": "01", "LSL": "10"}
mem_index = {"No índice": "0", "Índice": "1"}

def int_to_binary(n, bits):
    return format(n & ((1 << bits) - 1), f'0{bits}b')

def parse_register(reg_str):
    return int(reg_str[1:])

def parse_immediate(imm_str, is_ctrl=False):
    print(f"Parsing immediate: {imm_str}")
    if not is_ctrl and not imm_str.startswith('#'):
        raise ValueError(f"Inmediato inválido: {imm_str}. Debe comenzar con '#'")
    value = imm_str[1:] if imm_str.startswith('#') else imm_str
    return int(value, 16) if value.startswith('0x') else int(value)

def generate_opcode(condition, op_type, operation, rd, rn, op2, mov_shift="Normal", mem_idx="No índice"):
    opcode = conditions[condition] + types[op_type] + opcodes[op_type][operation]
    opcode += int_to_binary(rd, 4) + int_to_binary(rn, 4)
    opcode += mov_shifts[mov_shift]
    opcode += mem_index[mem_idx]
    if isinstance(op2, int):
        opcode += int_to_binary(op2, 14)
    else:  # op2 es un registro
        opcode += int_to_binary(op2, 4) + "0" * 10
    return opcode

def parse_instruction(instruction):
    print(f"Parsing instruction: {instruction}")
    parts = instruction.strip().split()
    operation = parts[0]

    condition = "AL"
    for cond in conditions.keys():
        if operation.endswith(cond) and operation != cond:
            condition = cond
            operation = operation[:-len(cond)]
            break

    print(f"Operation: {operation}, Condition: {condition}")

    mov_shift = "Normal"
    if operation in ["LSR", "LSL"]:
        mov_shift = operation
        operation = "MOV"

    if operation in ["LDR", "STR", "LDRB", "STRB"]:
        rd = parse_register(parts[1].rstrip(','))
        mem_parts = re.findall(r'\[([^\]]+)\]', instruction)[0].split(',')
        rn = parse_register(mem_parts[0].strip())
        if len(mem_parts) > 1:
            op2_str = mem_parts[1].strip()
            op2 = parse_immediate(op2_str) if op2_str.startswith('#') else parse_register(op2_str)
            mem_idx = "Índice"
        else:
            op2 = 0
            mem_idx = "No índice"
        op_type = "MEM"
    elif operation in ["ADD", "SUB", "AND", "MOV", "CMP", "UDIV", "SUBS", "MUL"]:
        rd = parse_register(parts[1].rstrip(','))
        if operation == "MOV" and mov_shift != "Normal":
            rn = parse_register(parts[2].rstrip(','))
            op2 = parse_immediate(parts[3])
            op_type = "IMM"
        elif operation == "MUL":
            rn = parse_register(parts[2].rstrip(','))
            op2 = parse_register(parts[3].rstrip(','))
            op_type = "REG"
        elif operation == "UDIV":
            rn = parse_register(parts[2].rstrip(','))
            op2 = parse_register(parts[3].rstrip(','))
            op_type = "REG"
        elif operation == "SUBS":
            rn = parse_register(parts[2].rstrip(','))
            op2 = parse_register(parts[3].rstrip(','))
            op_type = "REG"
        else:
            rn = parse_register(parts[2].rstrip(',')) if len(parts) > 2 and parts[2].startswith('R') else 0
            op2 = parse_immediate(parts[-1]) if parts[-1].startswith('#') else parse_register(parts[-1])
            op_type = "IMM" if isinstance(op2, int) else "REG"
    elif operation == "B":
        op_type = "CTRL"
        rd = rn = 0
        op2 = parse_immediate(parts[1], is_ctrl=True)
    else:
        raise ValueError(f"Operación no soportada: {operation}")

    print(f"Parsed instruction: op_type={op_type}, operation={operation}, rd={rd}, rn={rn}, op2={op2}, mov_shift={mov_shift}, mem_idx={mem_idx if 'mem_idx' in locals() else 'No índice'}")
    return condition, op_type, operation, rd, rn, op2, mov_shift, mem_idx if 'mem_idx' in locals() else "No índice"


def process_instructions(input_file, output_file):
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        for line in infile:
            if line.strip():
                print(f"Analizando instrucción: {line.strip()}")
                try:
                    params = parse_instruction(line)
                    opcode = generate_opcode(*params)
                    print(f"Opcode generado: {opcode}")
                    outfile.write(opcode + '\n')
                    print("--------------------------------------------------------------------------------------------")
                except Exception as e:
                    print(f"Error al procesar la instrucción: {line.strip()}")
                    print(f"Error: {str(e)}")
                    import traceback
                    print(traceback.format_exc())
                    return 0
    return 1

# Archivos de entrada y salida
input_file = 'interpolado_loop_12bits_limpio.txt'
bin_output_file = 'opcode_bin.txt'

# Procesar las instrucciones
result = process_instructions(input_file, bin_output_file)

if result != 0:
    print(f"Procesamiento completado. Los opcodes se han guardado en {bin_output_file}")
else:
    print("El procesamiento se detuvo debido a un error.")