from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image
from tensorflow.keras.preprocessing.image import ImageDataGenerator

import numpy as np
import os

model = load_model('modelo_setas.h5')


def cargar_y_preprocesar_imagen(ruta_imagen, tamaño_imagen=(224, 224)):
    img = image.load_img(ruta_imagen, target_size=tamaño_imagen)
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)
    img_array /= 255.0
    return img_array
def predecirEspecie(rutaImagen):
    imagen_preprocesada = cargar_y_preprocesar_imagen(rutaImagen)

    umbral = 0.7
    prediccion = model.predict(imagen_preprocesada)

    probabilidad_max = np.max(prediccion)
    clase_predicha = np.argmax(prediccion, axis=1)

    nombres_clases = ['Amanita muscaria','Fomes fomentarius','Fomitopsis pinicola','Hypogymnia physodes',
                      'Laetiporus sulphureus','Parmelia sulcata','Xanthoria parietina']

    if probabilidad_max < umbral:
        return 'Desconocida'
    else:
        nombre_clase_predicha = nombres_clases[clase_predicha[0]]
        return nombre_clase_predicha

