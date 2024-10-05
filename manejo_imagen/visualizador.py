import cv2
import numpy as np
import os

# Función para cargar valores en escala de grises desde un archivo .txt
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

# Función para cargar valores RGB desde un archivo .txt
def load_rgb_values_from_txt(filepath):
    with open(filepath, 'r') as file:
        values = []
        for line in file:
            line = line.strip()
            if line:  # Asegurarse de no procesar líneas vacías
                # Dividir los valores hexadecimales en tríos (RGB) y convertirlos a enteros
                hex_values = line.split()
                rgb_values = [(int(hex_values[i], 16), int(hex_values[i + 1], 16), int(hex_values[i + 2], 16))
                              for i in range(0, len(hex_values), 3)]
                values.extend(rgb_values)
    return values

# Función para crear una imagen a partir de valores hexadecimales (escala de grises)
def create_image_from_hex_values(hex_values, width, height, filename):
    # Convertir la lista de valores a un array de NumPy y darle forma de imagen
    image_array = np.array(hex_values, dtype=np.uint8).reshape((height, width))
    # Guardar la imagen en formato .png
    cv2.imwrite(filename, image_array)
    print(f"Imagen en escala de grises guardada como {filename}")

# Función para crear una imagen a partir de valores RGB
def create_image_from_rgb_values(rgb_values, width, height, filename):
    # Convertir la lista de valores a un array de NumPy y darle forma de imagen (RGB)
    image_array = np.array(rgb_values, dtype=np.uint8).reshape((height, width, 3))
    # Guardar la imagen en formato .png
    cv2.imwrite(filename, image_array)
    print(f"Imagen en RGB guardada como {filename}")

# Rutas del proyecto
repo_base_path = os.path.dirname(__file__)

# Escala de grises
referencia_greyscale_path = os.path.join(repo_base_path, 'memoria', 'base_greyscale.txt')
interpolacion_greyscale_path = os.path.join(repo_base_path, 'memoria', 'memory_greyscale.txt')

# Color RGB
referencia_rgb_path = os.path.join(repo_base_path, 'memoria', 'base_rgb.txt')
interpolacion_rgb_path = os.path.join(repo_base_path, 'memoria', 'memory_rgb.txt')

# Output paths
referencia_imagen_greyscale_path = os.path.join(repo_base_path, 'imagenes', 'referencia_greyscale.png')
interpolacion_imagen_greyscale_path = os.path.join(repo_base_path, 'imagenes', 'interpolacion_greyscale.png')

referencia_imagen_rgb_path = os.path.join(repo_base_path, 'imagenes', 'referencia_rgb.png')
interpolacion_imagen_rgb_path = os.path.join(repo_base_path, 'imagenes', 'interpolacion_rgb.png')

# Cargar y generar imágenes en escala de grises
referencia_greyscale = load_hex_values_from_txt(referencia_greyscale_path)
interpolacion_greyscale = load_hex_values_from_txt(interpolacion_greyscale_path)

create_image_from_hex_values(referencia_greyscale, 100, 100, referencia_imagen_greyscale_path)
create_image_from_hex_values(interpolacion_greyscale, 396, 396, interpolacion_imagen_greyscale_path)

# Cargar y generar imágenes en RGB
referencia_rgb = load_rgb_values_from_txt(referencia_rgb_path)
#interpolacion_rgb = load_rgb_values_from_txt(interpolacion_rgb_path)

create_image_from_rgb_values(referencia_rgb, 100, 100, referencia_imagen_rgb_path)
#create_image_from_rgb_values(interpolacion_rgb, 396, 396, interpolacion_imagen_rgb_path)
