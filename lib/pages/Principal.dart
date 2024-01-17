import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainActivity(),
    );
  }
}

class MainActivity extends StatefulWidget {
  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  int _currentIndex = 0;

  // Lista de widgets correspondientes a cada ítem de la barra de navegación
  final List<Widget> _screens = [
    MenuPrincipal(),
    TopScreen(),
    UploadScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Logo de la aplicación
            Image.asset('assets/images/iogo.png', width: 40, height: 40),
            SizedBox(width: 8), // Espacio entre el logo y el título
            Text(
              'Motorship Official Gallery',
              style: TextStyle(
                fontSize: 20, // Tamaño del texto
                fontWeight: FontWeight.bold, // Negrita
                fontFamily: 'YourFontFamily', // Cambia 'YourFontFamily' por el nombre de tu fuente personalizada
                color: Colors.black, // Color del texto
              ),
            ),
          ],
        ),
      ),
      body: Container(color: Color.fromARGB(255, 22, 29, 77),
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
          
        ),
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
        ImageItem(
          imagePath: 'assets/images/Autobello.jpg',
          description: 'Descripción de la imagen 1',
          logoImagePath: 'assets/images/iogo.png',
          logoText: 'Motorship1',
        ),
        ImageItem(
          imagePath: 'assets/images/auto2.jpg',
          description: 'Descripción de la imagen 2',
          logoImagePath: 'assets/images/iogo.png',
          logoText: 'Motorship2',
        ),
        ImageItem(
          imagePath: 'assets/images/Autobello.jpg',
          description: 'Descripción de la imagen 1',
          logoImagePath: 'assets/images/iogo.png',
          logoText: 'Motorship3',
        ),
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
          Image.asset(widget.imagePath),
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
          Container(
            margin: EdgeInsets.only(left: 18.0), // Ajusta el valor según el margen deseado
            child: Text(widget.description, style: TextStyle(color: Colors.white)),
          ),
          Divider(),
        ],
      ),
    );
  }
}