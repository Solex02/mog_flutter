import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:mog_flutter/pages/profile.dart';
import 'package:mog_flutter/pages/ranking.dart';
import 'package:flutter/material.dart';
import 'upload_content.dart'; // Importa el nuevo archivo
import 'package:supabase/supabase.dart';
import 'package:uuid/uuid.dart';

final supabase = SupabaseClient(
  'https://ngejlljkgxzpnwznpddk.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5nZWpsbGprZ3h6cG53em5wZGRrIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTY0MDY1NjMsImV4cCI6MjAxMTk4MjU2M30.nlZnIiHCjiThvu-cLj_aBPYaGE1knPFWXOhCkJQDLL4',
);

class MainActivity extends StatefulWidget {
  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  int _currentIndex = 0;
  List<Widget> _publications = [];

  @override
  void initState() {
    super.initState();
    _loadPublications();
  }

  void handleUpload(String imagePath, String description) async {
    List<int> bytes = await File(imagePath).readAsBytes();
    String imageData = base64Encode(bytes);

    final response = await supabase
        .from('Publicacionpureba')
        .insert({'image_data': imageData, 'description': description});

    _loadPublications(); // Recargar las publicaciones después de insertar
    setState(() {
      _currentIndex = 0; // Cambia a la pantalla principal después de cargar
    });
  }

  void _loadPublications() async {
    final response = await supabase.from('Publicacionpureba').select();

    if (response != null) {
      List<Map<String, dynamic>> publications =
          (response).cast<Map<String, dynamic>>();

      setState(() {
        _publications = publications.map((publication) {
          String imageData = publication['image_data'];
          String description = publication['description'];

          return ImageItem(
            imageData: imageData,
            description: description,
            logoImagePath: 'assets/images/oscar.png',
            logoText: 'Gangzalo',
          );
        }).toList();
      });
    } else {
      print('Error fetching publications');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset('assets/images/iogo.png', width: 40, height: 40),
            SizedBox(width: 8),
            Text(
              'Motorship Official Gallery',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'YourFontFamily',
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Color.fromARGB(255, 37, 45, 95),
            child: IndexedStack(
              index: _currentIndex,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // Use un ListView.builder para mostrar la lista de publicaciones
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _publications.length,
                        itemBuilder: (context, index) => _publications[index],
                      ),
                    ],
                  ),
                ),
                Container(), // Contenedor vacío para la pantalla de carga
              ],
            ),
          ),
           if (_currentIndex ==
              1) // Muestra la pantalla de carga solo cuando se selecciona "Upload"
            Positioned.fill(
              child: RankingPage(),
            ),
          if (_currentIndex ==
              2) // Muestra la pantalla de carga solo cuando se selecciona "Upload"
            Positioned.fill(
              child: UploadContent(onUpload: handleUpload),
            ),
          if (_currentIndex ==
              3) // Muestra la pantalla de carga solo cuando se selecciona "Upload"
            Positioned.fill(
              child: ProfilePage(),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: 'Top',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.grey,
      ),
    );
  }
}


                        //LISTA DE PUBLICACIONES



class ImageItem extends StatefulWidget {
  final String imageData; // Cambiado a String para contener la ruta de la imagen desde Supabase
  final String description;
  final String logoImagePath;
  final String logoText;

  ImageItem({
    required this.imageData, // Cambiado de File a String
    required this.description,
    required this.logoImagePath,
    required this.logoText,
  });

  @override
  _ImageItemState createState() => _ImageItemState();
}

class _ImageItemState extends State<ImageItem> {
  int likeCount = 0;
  bool isVoted = false; // Variable para indicar si se ha dado like

  void toggleVote() {
    setState(() {
      isVoted = !isVoted;
    });
  }

  void handleVote() {
    setState(() {
      if (isVoted) {
        likeCount--;
      } else {
        likeCount++;
      }
      toggleVote();
    });
  }

  @override
Widget build(BuildContext context) {
  // Decodificar los datos base64
  Uint8List imageDataBytes = base64Decode(widget.imageData);

  // Retornar el widget ImageItem con la imagen cargada desde datos decodificados
  return Align(
    alignment: Alignment.centerLeft,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Logo a la izquierda de la publicación
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(widget.logoImagePath, width: 30, height: 30),
            ),
            // Texto a la derecha del logo
            Text(widget.logoText, style: TextStyle(color: Colors.white)),
          ],
        ),
        // Mostrar la imagen desde los datos decodificados
        Image.memory(
          imageDataBytes,
          width: MediaQuery.of(context).size.width, // Ancho máximo
          fit: BoxFit.cover, // Ajuste de la imagen
        ),
        SizedBox(height: 8), // Margen por encima de los botones
        Container(
          margin: EdgeInsets.only(left: 9.0),
          child: Row(
            children: [
              SizedBox(
                width: 40, // Ancho específico para el botón
                child: IconButton(
                  onPressed: () {
                    handleVote();
                  },
                  icon: Icon(
                    isVoted ? Icons.favorite : Icons.favorite_border,
                    color: isVoted ? Colors.white : Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 0), // Espacio entre el icono y el campo de texto
              Text('${likeCount}', style: TextStyle(fontSize: 16, color: Colors.white)),
              SizedBox(width: 16), // Espacio entre los botones
              IconButton(
                onPressed: () {
                  // Lógica para el botón de compartir
                },
                icon: Icon(
                  isVoted ? Icons.share : Icons.share,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 0), // Margen por debajo de los botones
        Padding(
          padding: const EdgeInsets.only(left: 18.0, bottom: 40.0),
          child: Text(widget.description, style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
}
