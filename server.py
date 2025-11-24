from flask import Flask, request, jsonify;
import os
from Backend import predecirEspecie

app = Flask(__name__)

@app.route('/predecir', methods=['POST'])
def predecir():
    print('recivido')
    # Verificar si se ha enviado una imagen
    if 'imagen' not in request.files:
        return jsonify({'error': 'No se ha proporcionado ninguna imagen'}), 400
    
    file = request.files['imagen']
    
    # Guardar la imagen en una ruta temporal
    ruta_imagen = os.path.join('temp', file.filename)
    file.save(ruta_imagen)
    
    # Realizar la predicción utilizando la función de modelo_setas
    resultado = predecirEspecie(ruta_imagen)
    
    # Borrar la imagen temporal
    os.remove(ruta_imagen)
    
    return jsonify({'result': resultado})

if __name__ == '__main__':
    # Crear la carpeta temporal si no existe
    if not os.path.exists('temp'):
        os.makedirs('temp')
    # Ejecutar el servidor Flask
    app.run(host='0.0.0.0', port=5000, debug=False)
