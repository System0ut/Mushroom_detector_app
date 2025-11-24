import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Flatten, Dense, Dropout
from tensorflow.keras.optimizers import Adam

# Ruta a las imágenes de entrenamiento
ruta_entrenamiento = 'dataset/setas'

# Parámetros de entrenamiento
tamaño_imagen = (224, 224)  # Ajusta este tamaño según el tamaño de tus imágenes
batch_size = 32
epochs = 20
num_clases = 7  # Número de especies de setas

# Generador de imágenes con aumento de datos
train_datagen = ImageDataGenerator(
    rescale=1./255,
    rotation_range=20,
    width_shift_range=0.2,
    height_shift_range=0.2,
    shear_range=0.2,
    zoom_range=0.2,
    horizontal_flip=True,
    validation_split=0.2  # Usar 20% de los datos para validación
)

# Generador para datos de entrenamiento
train_generator = train_datagen.flow_from_directory(
    ruta_entrenamiento,
    target_size=tamaño_imagen,
    batch_size=batch_size,
    class_mode='categorical',
    subset='training'  # Usar el subconjunto de entrenamiento
)

# Generador para datos de validación
validation_generator = train_datagen.flow_from_directory(
    ruta_entrenamiento,
    target_size=tamaño_imagen,
    batch_size=batch_size,
    class_mode='categorical',
    subset='validation'  # Usar el subconjunto de validación
)

# Construcción del modelo CNN
model = Sequential([
    Conv2D(32, (3, 3), activation='relu', input_shape=(tamaño_imagen[0], tamaño_imagen[1], 3)),
    MaxPooling2D(pool_size=(2, 2)),
    Conv2D(64, (3, 3), activation='relu'),
    MaxPooling2D(pool_size=(2, 2)),
    Conv2D(128, (3, 3), activation='relu'),
    MaxPooling2D(pool_size=(2, 2)),
    Flatten(),
    Dense(128, activation='relu'),
    Dropout(0.5),
    Dense(num_clases, activation='softmax')
])

# Compilación del modelo
model.compile(optimizer=Adam(), loss='categorical_crossentropy', metrics=['accuracy'])

# Resumen del modelo
model.summary()

# Entrenamiento del modelo
history = model.fit(
    train_generator,
    epochs=epochs,
    validation_data=validation_generator
)

# Guardar el modelo entrenado
model.save('modelo_setas.h5')
