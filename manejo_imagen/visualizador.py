import cv2
import numpy as np
import os

def load_hex_values_from_txt(filepath):
    with open(filepath, 'r') as file:
        values = []
        for line in file:
            line = line.strip()
            if line:  # Asegurarse de no procesar líneas vacías
                # Dividir los valores hexadecimales y convertirlos a enteros
                hex_values = line.split()
                int_values = [int(val, 16) for val in hex_values]
                values.extend(int_values)
    return values


def create_image_from_hex_values(hex_values, width, height, filename):
    # Convertir la lista de valores a un array de NumPy y darle forma de imagen
    image_array = np.array(hex_values, dtype=np.uint8).reshape((height, width))
    # Guardar la imagen en formato .png
    cv2.imwrite(filename, image_array)
    print(f"Imagen guardada como {filename}")


repo_base_path = os.path.dirname(__file__)
referencia_path = os.path.join(repo_base_path, 'memoria', 'base.txt')
interpolacion_path = os.path.join(repo_base_path, 'memoria', 'memory_27500.txt')
print(referencia_path)
print(interpolacion_path)

referencia_imagen_path = os.path.join(repo_base_path, 'imagenes', 'referencia.png')
interpolacion_imagen_path = os.path.join(repo_base_path, 'imagenes', 'interpolacion.png')


# Cargar los valores desde los archivos .txt
referencia = load_hex_values_from_txt(referencia_path)
interpolacion = load_hex_values_from_txt(interpolacion_path)

# Crear las imágenes a partir de los valores cargados
create_image_from_hex_values(referencia, 100, 100, referencia_imagen_path)
create_image_from_hex_values(interpolacion, 396, 396, interpolacion_imagen_path)

'''
Nota: 

guardado código con label:

sector_seleccionado: 28c 
inicio imagen: 2a0
guarda: 27500
final: 31140

guardado con loop:

sector_seleccionado: 1c8 
inicio imagen: 1c8
guarda: 272e0
final: 30f20

'''