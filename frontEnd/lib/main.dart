import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'galleryPage.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';

enum CameraState {NONE, LOADING, LOADED, ERROR}
late List<CameraDescription> _cameras;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(MaterialApp(
      title: 'HomePage',
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp>{
  // variables Galeria
  String selectedImage = '';

  // variables Camara
  CameraState estado = CameraState.NONE;
  late CameraController controller;
  String imageTaked = '';
  String ResultPrediction = '';

  // obtener camara
  @override
  void initState() {
    super.initState();
    _requestPermissions();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller.initialize();
  }



  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    await [Permission.camera, Permission.storage].request();
  }

  // tomar foto
  Future<void> _takePicture() async {
    try {
      await controller.value.isInitialized;
      final directory = await getApplicationDocumentsDirectory();
      final filePath = join(directory.path, '${DateTime.now().millisecondsSinceEpoch}_FotoCamara.jpg');

      final XFile image = await controller.takePicture();
      final File newImage = await File(image.path).copy(filePath);
      setState(() {
        imageTaked = newImage.path;
        selectedImage = 'no esta vacio';
      });
      await _uploadImage(newImage);
    } catch (e) {
      print(e);
    }
  }

  // Enviar foto la servidor
  Future<void> _uploadImage(File image) async {
    final url = Uri.parse("http://xxx.xxx.xxx.xxx:5000/predecir"); // url del server

    final request = http.MultipartRequest('Post', url)
      ..files.add(await http.MultipartFile.fromPath('imagen',
        image.path,
    ));
    
    try{
      final response = await request.send();
      
      if(response.statusCode == 200){
        print('Imagen subida');
        final responseData = await response.stream.bytesToString();
        final decodedData = json.decode(responseData);

        setState(() {
          ResultPrediction = decodedData['result'];
        });
      }else{
        print('Error subiendo imagen: ${response.statusCode}');
        setState(() {
          ResultPrediction = 'Error2 al detectar la especie';
        });
      }
    } catch(e){
      print("Exceptcion mientras la subida de la imagen: $e");
      setState(() {
        ResultPrediction = 'Error 1 al detectar la especie';
      });
    }
        
  }

  Future<void> _uploadGalleryImage(String imagePath) async {
    try {
      // Cargar el archivo desde los assets
      final byteData = await rootBundle.load(imagePath);

      // Crear un archivo temporal
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp_image.jpg');

      // Escribir los datos del archivo en el archivo temporal
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());

      // Subir el archivo al servidor
      await _uploadImage(tempFile);
    } catch (e) {
      print("Error cargando imagen desde assets: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(32, 83, 117, 1),
        body: Column(children: [
          Container(

            width: 3,
            height: 60,
          ),
          Container(

            width: MediaQuery.of(context).size.width,
            child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      border: Border.all(
                          width: 3.0
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  width: MediaQuery.of(context).size.width/1.2,
                  child: const Text('Detector de setas',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w800,color: Colors.black),
                    textScaler: TextScaler.linear(4),
                  ),
                )
            ),
          ),
          Container(
            width: 90,
            height: selectedImage.isEmpty ? 75: 65,
            decoration: BoxDecoration(
              border: Border.all(width: 3.0),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.purple,
            ),
            child: TextButton(
              onPressed: (){
                setState(() {
                  selectedImage = '';
                  imageTaked = '';
                });
              },
              child: const Text(
                'Reset',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          Container(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(6.0),
            width: MediaQuery.of(context).size.width/1.5,
            height: selectedImage.isEmpty ? MediaQuery.of(context).size.height/2.5: MediaQuery.of(context).size.height/2.7,
            decoration: BoxDecoration(
                color: selectedImage.isEmpty ? Color.fromRGBO(9, 24, 77, 1) : Color.fromRGBO(9, 24, 77, 1),
                border: Border.all(
                    width: 3.0
                ),
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: selectedImage.isEmpty ? Center(
              child: controller.value.isInitialized ? CameraPreview(controller):
                Text('sin imagen',
                  style: TextStyle(color: Colors.white),),
                    ): imageTaked.isNotEmpty ? Image.file(File(imageTaked))
                : Image.asset(selectedImage)
          ),

          Container(
            width: selectedImage.isEmpty ? 3 : null,
            height: selectedImage.isEmpty ? 40 : 60,
            child: selectedImage.isNotEmpty
                ? Center(
              child: AutoSizeText(
                ResultPrediction.isNotEmpty
                    ? '$ResultPrediction'
                    : 'Procesando...',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
                maxLines: 1,
                minFontSize: 25,
                overflow: TextOverflow.ellipsis,
              ),
            )
                : null,
          ),
          Row(children: [
            Container(
              width: MediaQuery.of(context).size.width/6,
            ),
            Container( // boton Galeria
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(37, 47, 156, 1),
                  border: Border.all(
                      width: 3.0
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.insert_photo,
                  color: Color.fromRGBO(207, 229, 255, 1),
                  size: 80.0,
                ),
                onPressed: () async{
                  final image_ = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => galleryPage()),
                  );
                  if(image_ != null){
                    print('Selected image: $image_');
                    setState(() {
                      imageTaked = '';
                      selectedImage = image_;
                    });
                    await _uploadGalleryImage(image_);
                  }
                },
              ),
            ),
            Spacer(flex: 2,),
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(37, 47, 156, 1),
                  border: Border.all(
                      width: 3.0
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.photo_camera,
                  color: Color.fromRGBO(207, 229, 255, 1),
                  size: 80.0,
                ),
                onPressed: (){
                  if(selectedImage == ''){
                    _takePicture();
                  }

                },
              )
            ),
            Container(
              width: MediaQuery.of(context).size.width/6,
            ),
          ],),
        ],
        ),
      ),
    );
  }

}


