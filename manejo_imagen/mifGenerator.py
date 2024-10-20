def generate_mif_file(input_file, output_file):
    with open(input_file, 'r') as f:
        opcodes = [line.strip() for line in f.readlines()]

    with open(output_file, 'w') as f:
        f.write("WIDTH = 32;\n")
        f.write(f"DEPTH = {len(opcodes)};\n")
        f.write("ADDRESS_RADIX = UNS;\n")
        f.write("DATA_RADIX = BIN;\n")
        f.write("CONTENT BEGIN\n")

        for i, opcode in enumerate(opcodes):
            f.write(f"    {i} : {opcode};\n")

        f.write("END;\n")

# Uso del programa
input_file = "opcode_bin.txt"
output_file = "instrMEM.mif"
generate_mif_file(input_file, output_file)
print(f"Archivo MIF generado: {output_file}")