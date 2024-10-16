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
    
    return salida

# Ejemplo de uso
imagen_path_1 = "image.png"  # Ruta de la imagen
resultado_1 = generarPixelesMIF(imagen_path_1)

# Guardar el resultado en un archivo de texto
with open("resultado_pixeles.txt", "w") as archivo:
    archivo.write(resultado_1)

print("Proceso completado. Resultado guardado en 'resultado_pixeles.txt'")

from PIL import Image

def generarPixelesZoomMIF(imagen_path):
    # Abrir la imagen en modo de escala de grises (L) para obtener pixeles de 0 a 255
    imagen = Image.open(imagen_path).convert('L')
    pixeles = list(imagen.getdata())
    
    # Crear el string con el formato especificado
    salida = "CONTENT BEGIN\n"
    # Agregar los primeros seis valores con 0
    for i in range(6):
        salida += f"\t{i}\t:\t0;\n"
    # Agregar los valores de los píxeles a partir de la posición 6
    for i, pixel in enumerate(pixeles, start=6):
        salida += f"\t{i}\t:\t{pixel:X};\n"
    salida += "END;"
    
    return salida

# Ejemplo de uso
imagen_path_2 = "zoom_image.png"  # Ruta de la imagen
resultado_2 = generarPixelesZoomMIF(imagen_path_2)

# Guardar el resultado en un archivo de texto
with open("resultado_pixeles_zoom.txt", "w") as archivo:
    archivo.write(resultado_2)

print("Proceso completado. Resultado guardado en 'resultado_pixeles_zoom.txt'")



