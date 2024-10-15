import re

def parse_instruction(instruction):
    parts = instruction.split(None, 1)
    opcode = parts[0].lower()
    operands = parts[1] if len(parts) > 1 else ""
    return opcode, operands

def get_condition(opcode):
    if opcode.endswith('eq'):
        return '01'
    elif opcode.endswith('ne'):
        return '10'
    elif opcode.endswith('ge'):
        return '11'
    else:
        return '00'

def get_type_and_opcode(opcode):
    opcodes = {
        'add': '000', 'sub': '001', 'and': '010', 'mov': '011', 'udiv': '101', 'subs': '110', 'cmp': '100',
        'lsl': '101', 'ldr': '000', 'ldrb': '001', 'str': '010', 'strb': '011',
        'b': '000', 'push': '001', 'pop': '010',
        'mul': '111',
    }

    base_opcode = opcode.rstrip('eqneg')

    if base_opcode in opcodes:
        return opcodes[base_opcode]
    else:
        raise ValueError(f"Opcode desconocido: {opcode}")

def parse_register(reg):
    match = re.match(r'R(\d+)', reg)
    if match:
        reg_num = int(match.group(1))
        if 0 <= reg_num <= 12:
            return format(reg_num, '04b')
    raise ValueError(f"Registro inválido: {reg}. Debe ser R0-R12.")

def parse_immediate(imm, with_hash=True, bits=12):
    if with_hash and not imm.startswith('#'):
        raise ValueError(f"Inmediato inválido: {imm}. Debe comenzar con '#'.")
    imm = imm[1:] if with_hash else imm  # Eliminar el '#' inicial si es necesario
    if imm.startswith('0x'):
        value = int(imm, 16)
    else:
        value = int(imm)
    if value < 0 or value >= (1 << bits):
        raise ValueError(f"Valor inmediato fuera de rango: {imm}")
    return format(value, f'0{bits}b')

def generate_opcode(instruction):
    opcode, operands = parse_instruction(instruction)
    condition = get_condition(opcode)

    if opcode.startswith('b'):
        # Instrucción de control (branch)
        type_bits = '11'
        opcode_bits = get_type_and_opcode(opcode)
        rd = rn = '0000'
        operand2 = parse_immediate(operands.strip(), with_hash=False)
    elif opcode in ['ldr', 'ldrb', 'str', 'strb']:
        # Instrucción de memoria
        type_bits = '10'
        opcode_bits = get_type_and_opcode(opcode)
        rd, memory_op = operands.split(',', 1)
        rd = parse_register(rd.strip())
        memory_op = memory_op.strip()[1:-1]  # Remover corchetes
        if ',' in memory_op:
            # Modo indexado
            rn, offset = memory_op.split(',')
            rn = parse_register(rn.strip())
            operand2 = '1' + parse_immediate(offset.strip(), bits=11)
        else:
            # Modo indirecto
            rn = parse_register(memory_op.strip())
            operand2 = '0' + '0' * 11
    elif opcode in ['push', 'pop']:
        # Operación de control (push/pop)
        type_bits = '11'
        opcode_bits = get_type_and_opcode(opcode)
        rd = parse_register(operands.strip())
        rn = '0000'
        operand2 = '0' * 12
    elif opcode == 'mul':
        # Instrucción MUL
        type_bits = '10'
        opcode_bits = get_type_and_opcode(opcode)
        parts = operands.split(',')
        rd = parse_register(parts[0].strip())
        rn = parse_register(parts[1].strip())
        rm = parse_register(parts[2].strip())
        operand2 = '00000000' + rm
    elif opcode.startswith('mov'):
        # Caso especial MOV
        type_bits = '00'
        opcode_bits = get_type_and_opcode('mov')
        parts = operands.split(',')
        rd = parse_register(parts[0].strip())
        if 'lsl' in parts[1].lower():
            rn, shift = parts[1].split('lsl')
            rn = parse_register(rn.strip())
            mov_type = '10'
            shift_amount = parse_immediate(shift.strip(), bits=10)
        elif 'lsr' in parts[1].lower():
            rn, shift = parts[1].split('lsr')
            rn = parse_register(rn.strip())
            mov_type = '01'
            shift_amount = parse_immediate(shift.strip(), bits=10)
        elif parts[1].strip().startswith('#'):
            # MOV con inmediato
            type_bits = '01'
            rn = '0000'
            mov_type = '00'
            shift_amount = parse_immediate(parts[1].strip(), bits=12)
            operand2 = shift_amount
        else:
            rn = parse_register(parts[1].strip())
            mov_type = '00'
            shift_amount = '0' * 10
        if type_bits == '00':
            operand2 = mov_type + shift_amount
    elif '#' in operands:
        # Operación con inmediato
        type_bits = '01'
        opcode_bits = get_type_and_opcode(opcode)
        parts = operands.split(',')
        rd = parse_register(parts[0].strip())
        if len(parts) > 2:
            rn = parse_register(parts[1].strip())
            operand2 = parse_immediate(parts[2].strip())
        else:
            rn = '0000' if opcode.startswith('mov') else rd
            operand2 = parse_immediate(parts[1].strip())
    else:
        # Operación con registros
        type_bits = '00'
        opcode_bits = get_type_and_opcode(opcode)
        parts = operands.split(',')
        rd = parse_register(parts[0].strip())
        rn = parse_register(parts[1].strip())
        rm = parse_register(parts[2].strip()) if len(parts) > 2 else '0000'
        operand2 = '00000000' + rm

    return condition + type_bits + opcode_bits + rd + rn + operand2

def process_file(input_file, hex_output_file, bin_output_file):
    with open(input_file, 'r') as f, open(hex_output_file, 'w') as f_hex, open(bin_output_file, 'w') as f_bin:
        for line_num, line in enumerate(f, 1):
            line = line.strip()
            if line:
                try:
                    binary_opcode = generate_opcode(line)
                    hex_opcode = format(int(binary_opcode, 2), '08x')
                    f_bin.write(f"{binary_opcode}\n")
                    f_hex.write(f"{hex_opcode}\n")
                    print(f"Instrucción: {line}")
                    print(f"Opcode (binario): {binary_opcode}")
                    print(f"Opcode (hexadecimal): {hex_opcode}")
                    print("--------------------")
                except ValueError as e:
                    print(f"Error en la línea {line_num}: {line}")
                    print(f"  {str(e)}")
                    print("--------------------")

# Uso del script
input_file = 'interpolado_loop_12bits_limpio.txt'
hex_output_file = 'opcode_hex.txt'
bin_output_file = 'opcode_bin.txt'

process_file(input_file, hex_output_file, bin_output_file)
print(f"Opcode generado en {hex_output_file} (hexadecimal) y {bin_output_file} (binario)")