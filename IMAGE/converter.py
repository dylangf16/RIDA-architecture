from PIL import Image

def generarPixelesMIF(imagen_path):
    # Abrir la imagen en modo de escala de grises (L) para obtener pixeles de 0 a 255
    imagen = Image.open(imagen_path).convert('L')
    pixeles = list(imagen.getdata())
    
    # Crear el string con el formato especificado
    salida = "CONTENT BEGIN\n"
    for i, pixel in enumerate(pixeles):
        salida += f"\t{i}\t:\t{pixel:X};\n"  # Convertir los índices y los píxeles a hexadecimal
    salida += "END;"
    
    with open("RomPixeles.txt", "w") as archivo:
        archivo.write(salida)

    print("Proceso completado. Resultado guardado en 'RomPixeles.txt'")
    
    cuadrante = 100
    x0 = 0
    x1 = cuadrante
    y0 = 0
    y1 = cuadrante
    
    imageCuadrant = imagen.crop((x0,y0,x1,y1))
    imageInterp = imageCuadrant.resize((400,400), Image.BILINEAR)
    pixelesCuadrant = list(imageInterp.getdata())
    
    salida = "CONTENT BEGIN\n"
    for i in range(6):
        if i == 2: salida += f"\t{i}\t:\t6;\n"
        else: salida += f"\t{i}\t:\t0;\n"
    # Agregar los valores de los píxeles a partir de la posición 6
    for i, pixel in enumerate(pixelesCuadrant, start=6):
        salida += f"\t{i}\t:\t{pixel:X};\n"
    salida += "END;"
    
    with open("RamPixeles.txt", "w") as archivo:
        archivo.write(salida)

    print("Proceso completado. Resultado guardado en 'RamPixeles.txt'")
    

# Ejemplo de uso
imagen_path = "image.png"  # Ruta de la imagen
generarPixelesMIF(imagen_path)



