import 'dart:io';

import 'package:flutter/material.dart';
import 'upload_content.dart'; // Importa el nuevo archivo

class MainActivity extends StatefulWidget {
  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  int _currentIndex = 0;

  // Lista de publicaciones
  List<Widget> _publications = [
    
  ];

  void handleUpload(String imagePath, String description) {
    setState(() {
      // Agrega la nueva publicación a la lista
      _publications.add(
        ImageItem(
          imagePath: imagePath,
          description: description,
          logoImagePath: 'assets/images/oscar.png',
          logoText: 'Gangzalo',
        ),
      );
      _currentIndex = 0; // Cambia a la pantalla principal después de cargar
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              // Use un ListView.builder para mostrar la lista de publicaciones
              ListView.builder(
                itemCount: _publications.length,
                itemBuilder: (context, index) => _publications[index],
              ),
              TopScreen(),
              Container(), // Contenedor vacío para la pantalla de carga
              ProfileScreen(),
            ],
          ),
        ),
        if (_currentIndex == 2) // Muestra la pantalla de carga solo cuando se selecciona "Upload"
          Positioned.fill(
            child: UploadContent(onUpload: handleUpload),
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


class MenuPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      
      children: [
        
        // Agrega más elementos según sea necesario
      ],
    );
  }
}

class TopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Contenido de la pantalla Top
      ],
    );
  }
}

class UploadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Contenido de la pantalla Upload
      ],
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Contenido de la pantalla Profile
      ],
    );
  }
}
                        //LISTA DE PUBLICACIONES



class ImageItem extends StatefulWidget {
  final String imagePath;
  final String description;
  final String logoImagePath;
  final String logoText;

  ImageItem({
    required this.imagePath,
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
          Image.file(File(widget.imagePath)),
          SizedBox(height: 14), // Margen por encima de los botones
          Container(
            margin: EdgeInsets.only(left: 9.0), // Ajusta el valor según el margen deseado
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    handleVote();
                  },
                  icon: Icon(
                    isVoted ? Icons.favorite : Icons.favorite_border,
                    color: isVoted ? Colors.white : Colors.white,
                  ),
                ),
                SizedBox(width: 1), // Espacio entre el icono y el campo de texto
                Text('${likeCount}', style: TextStyle(fontSize: 16, color: Colors.white)),
                SizedBox(width: 16), // Espacio entre los botones
                IconButton(
                  onPressed: () {
                    // Agrega la lógica para el botón "Share"
                  },
                  icon: Icon(
                    isVoted ? Icons.share : Icons.share,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8), // Margen por debajo de los botones
          Padding(
            padding: const EdgeInsets.only(left: 18.0, bottom: 40.0), // Ajusta los valores según el margen deseado
            child: Text(widget.description, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}