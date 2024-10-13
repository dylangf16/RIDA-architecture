import numpy as np
from PIL import Image
import matplotlib.pyplot as plt

def bilinear_interpolation(img, new_height, new_width):
    height, width = img.shape
    new_img = np.zeros((new_height, new_width))
    
    # Escala para la interpolación
    x_scale = width / new_width
    y_scale = height / new_height
    
    for new_y in range(new_height):
        for new_x in range(new_width):
            # Coordenadas originales
            x = new_x * x_scale
            y = new_y * y_scale
            
            # Coordenadas base (índices de los píxeles superiores)
            x1 = int(x)
            y1 = int(y)
            
            # Coordenadas superiores
            x2 = min(x1 + 1, width - 1)
            y2 = min(y1 + 1, height - 1)
            
            # Pesos de interpolación
            a = x - x1
            b = y - y1
            
            # Realizamos la interpolación
            new_img[new_y, new_x] = (1 - a) * (1 - b) * img[y1, x1] + \
                                    a * (1 - b) * img[y1, x2] + \
                                    (1 - a) * b * img[y2, x1] + \
                                    a * b * img[y2, x2]
    
    return new_img

# Cargar la imagen en blanco y negro de 400x400
image_path = 'image.png'  # Cambiar a la ruta de la imagen
img = Image.open(image_path).convert('L')
img_np = np.array(img)

# Coordenadas del bloque 100x100 que quieres ampliar
# Ejemplo: bloque superior izquierdo (0, 0) a (100, 100)
x_start, y_start = 0, 0  # Cambiar según el bloque deseado
block_100x100 = img_np[y_start:y_start+100, x_start:x_start+100]

# Aplicar la interpolación bilineal para ampliar el bloque a 400x400
zoomed_img = bilinear_interpolation(block_100x100, 400, 400)

# Convertir la matriz resultante a una imagen y guardarla
zoomed_img = Image.fromarray(np.uint8(zoomed_img))

# Mostrar y guardar la imagen ampliada
zoomed_img.show()
zoomed_img.save('zoom_image.png')
