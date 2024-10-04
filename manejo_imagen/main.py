import cv2
import numpy as np
import os

def divide_image_into_sectors(image, sector_size=100):
    # Dimensiones de la imagen
    height, width = image.shape

    # Asegurarse de que la imagen sea exactamente divisible por el tamaño de los sectores
    if height != 400 or width != 400:
        print(f"Advertencia: Redimensionando la imagen de {height}x{width} a 400x400.")
        image = cv2.resize(image, (400, 400))
        height, width = image.shape

    # Diccionario para almacenar las matrices de cada sector
    sector_matrices = {}

    # Recorrer los sectores de la imagen (4x4 sectores en una imagen de 400x400)
    sector_num = 1
    for i in range(4):  # 4 filas de sectores
        for j in range(4):  # 4 columnas de sectores
            # Definir las coordenadas del sector
            y_start, y_end = i * sector_size, (i + 1) * sector_size
            x_start, x_end = j * sector_size, (j + 1) * sector_size

            # Extraer el sector de la imagen
            sector = image[y_start:y_end, x_start:x_end]

            # Verificar que cada sector tenga exactamente 100x100 píxeles
            if sector.shape != (sector_size, sector_size):
                print(f"Error: El sector {sector_num} tiene dimensiones incorrectas {sector.shape}.")
                return None

            # Guardar la matriz del sector en el diccionario
            sector_matrices[sector_num] = sector

            # Incrementar el número del sector
            sector_num += 1

    return sector_matrices

def save_sectors_to_file(sector_matrices, filename, separacion, num_sectores):
    # Abrir el archivo para escribir
    with open(filename, 'w') as file:
        # Recorrer todos los sectores
        contador = 0
        for sector_num, sector in sector_matrices.items():
            file.write(f"Sector {sector_num}:\n")  # Escribir el número del sector
            # Recorrer las filas de la matriz del sector
            if (contador == num_sectores):
                return 0
            for row in sector:
                # Convertir los valores de cada píxel a hexadecimal y unirlos en una cadena
                row_hex = f'{separacion}'.join(f'{val:02X}' for val in row)
                # Escribir la fila en el archivo
                file.write(row_hex + '\n')
            contador += 1
            file.write('\n')  # Separador entre sectores
    print(f"Todos los sectores guardados en {filename}")


def save_combined_sectors_to_file(sector_matrices, filename="output_sectors_combined.txt"):
    # Abrir el archivo para escribir
    with open(filename, 'w') as file:
        # Crear una imagen de 400x400 a partir de los sectores 100x100
        combined_matrix = np.zeros((400, 400), dtype=np.uint8)

        # Recorrer los sectores y ubicarlos en la imagen combinada
        sector_num = 1
        for i in range(4):  # 4 filas de sectores
            for j in range(4):  # 4 columnas de sectores
                # Obtener el sector actual
                sector = sector_matrices[sector_num]

                # Calcular las coordenadas donde se colocará este sector en la matriz combinada
                y_start, y_end = i * 100, (i + 1) * 100
                x_start, x_end = j * 100, (j + 1) * 100

                # Colocar el sector en la matriz combinada
                combined_matrix[y_start:y_end, x_start:x_end] = sector

                # Incrementar el número del sector
                sector_num += 1

        # Ahora escribimos los valores de la matriz combinada en el archivo
        for row in combined_matrix:
            # Convertir los valores de cada píxel a hexadecimal y unirlos en una cadena
            row_hex = '\n'.join(f'{val:02X}' for val in row)  # Puedes usar val en lugar de hex para decimal
            # Escribir la fila en el archivo
            file.write(row_hex + '\n')

    print(f"Valores de la imagen combinada guardados en {filename}")


# Construir la ruta relativa a partir del directorio del script
repo_base_path = os.path.dirname(__file__)
path_imagen = os.path.join(repo_base_path, 'imagenes', 'wallhaven-m3ky79_400x400.png')
output_sector = os.path.join(repo_base_path, 'memoria', 'sectores_100x100.txt')
output_completo = os.path.join(repo_base_path, 'memoria', 'imagen_completa.txt')
print(path_imagen)
print(output_sector)

# Cargar la imagen en escala de grises usando la ruta generada
image = cv2.imread(path_imagen, cv2.IMREAD_GRAYSCALE)

# Verificar que la imagen se haya cargado correctamente
if image is None:
    print("Error al cargar la imagen.")
else:
    # Dividir la imagen en sectores de 100x100 píxeles
    sector_matrices = divide_image_into_sectors(image, sector_size=100)

    # Si la imagen es divisible en sectores, guardar todos los sectores
    if sector_matrices:
        save_sectors_to_file(sector_matrices, output_sector, ' ', 16)
        save_combined_sectors_to_file(sector_matrices, output_completo)


