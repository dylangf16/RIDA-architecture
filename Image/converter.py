from PIL import Image

def generarPixelesMIF(imagen_path):
    # Abrir la imagen en modo de escala de grises (L) para obtener pixeles de 0 a 255
    imagen = Image.open(imagen_path).convert('L')
    pixeles = list(imagen.getdata())
    
    # Crear el string con el formato especificado
    salida = "CONTENT BEGIN\n"
    for i, pixel in enumerate(pixeles):
        salida += f"\t{i}\t:\t{pixel};\n"
    salida += "END;"
    
    return salida

# Ejemplo de uso
imagen_path = "zoom_image.png"  # Ruta de la imagen
resultado = generarPixelesMIF(imagen_path)

# Guardar el resultado en un archivo de texto
with open("resultado_pixeles_zoom.txt", "w") as archivo:
    archivo.write(resultado)

print("Proceso completado. Resultado guardado en 'resultado_pixeles.txt'")
