from PIL import Image
#import requests
from io import BytesIO
import cv2
import numpy as np
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers, models
from tensorflow.keras.models import load_model
#import tensorflow_hub as hub


def categorizar(image,modelo):
  
  image = cv2.imread(image)
  image = cv2.resize(image, (224,224))
  image = np.array(image).astype(float)/255

  
  prediccion = modelo.predict(image.reshape(-1, 224, 224, 3))
  print(prediccion)
  return np.argmax(prediccion[0], axis=-1)



def cargarModelo(url):
  # model = tf.keras.models.load_model(
  #   ("modelo2.h5"),
  #   custom_objects={'KerasLayer':hub.KerasLayer}
  #   )
  
  model = tf.keras.models.load_model(url) 
  #model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])
  #model.summary()
  return model

#urlImagen = 'assets/Hypogymnia_physodes_testAI.jpg'
#urlImagen = 'assets/amanitaMuscaria_test1.jpeg'
#urlImagen = 'assets/amanitaMuscaria_test4.jpg'
#urlImagen = 'assets/hypogymniaPhysodes_test3.jpg'
urlImagen = 'assets/fomitopsisPinicola_test2.JPG'
#urlImagen = 'assets/laetiporusSulphureus_test3.jpeg'
urlModelo = 'modelo_setas.h5'

modelo = cargarModelo(urlModelo)

prediccion = categorizar(urlImagen,modelo)
print(prediccion)

# 0 -> 
# 1 -> Fomes fomentarius
# 2 -> amanita muscaria
# 3 -> Hypogymnia Physodes
# 4 ->
# 5 ->
# 6 ->


solutions = [{'Result':''},{'Result':'Fomes fomentarius, No Venenosa, No comenstible'},{'Result':'Amanita Muscaria, Venenoso'},
              {'Result':'Hypogymnia Physodes, No Venenosa, No comenstible'},{'Result':''},{'Result':''},{'Result':''}]

