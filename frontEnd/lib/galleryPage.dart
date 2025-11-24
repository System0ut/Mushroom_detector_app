import 'package:flutter/material.dart';
import 'main.dart';
import 'assets/loadImages_.dart';

class galleryPage extends StatefulWidget {
  @override
  _galleryPage createState() => _galleryPage();
}

class _galleryPage extends State<galleryPage>{

  String imagen = '';
  int indexImage = -1;
  void selectImage(String imagePath){
    setState(() {
      imagen = imagePath;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color.fromRGBO(32, 83, 117, 1),
      body: SafeArea(
          child: Column(children: [
        Row(
          children: [
            Container(
                width: MediaQuery.of(context).size.width / 1.3,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      border: Border.all(width: 3.0),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: const Text(
                    'GALERIA DE IMAGENES',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.black),
                    textScaler: TextScaler.linear(2),
                  ),
                )),
            Center(
                child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                border: Border.all(width: 3.0),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.orange,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color.fromRGBO(207, 229, 255, 1),
                  size: 50.0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )),
            Container(
              width: 10,
            )
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 1.45,
          decoration: BoxDecoration(
            border: Border.all(width: 3.0),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Color.fromRGBO(9, 24, 77, 1),
          ),
          child: GridView.builder(
            padding: const EdgeInsets.all(12.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: imagePaths.length,
            itemBuilder: (context, index) {
              final isSelected = imagePaths[index] == imagen;
              return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: IntrinsicHeight(
                      child: IntrinsicWidth(
                          child:  GestureDetector(
                      onTap: () {
                        setState(() {
                          // Toggle light when tapped.
                          imagen = imagePaths[index];
                          indexImage = index;
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 3.0),
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: isSelected ? Colors.green: Colors.black),
                          child: Image.asset(imagePaths[index]),
                      )
                          )
                      )
                  )
              );
            },
          ),
        ),
        Container(
          height: 10,
        ),
        Center(
          child: Container(
            height: 80,
            width: 80,

            child: IntrinsicHeight(
                  child: IntrinsicWidth(
                    child:IconButton(
                      icon: const Icon(
                        Icons.check_circle,
                        color: Color.fromRGBO(0, 161,57, 1),
                        size: 80,
                      ),
                      onPressed: () {
                        Navigator.pop(context, imagen);
                      },
                    ),
                  )
            )
          ),
        )
      ])),
    );
  }
}
