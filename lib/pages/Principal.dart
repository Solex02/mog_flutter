import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mog_flutter/pages/otherprofile.dart';
import 'upload_content.dart'; // Importa el nuevo archivo
import 'package:supabase/supabase.dart';
import 'package:uuid/uuid.dart';
import 'package:mog_flutter/pages/profile.dart';
import 'package:mog_flutter/pages/ranking.dart';

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
        .from('publicaciones')
        .insert({'image_data': imageData, 'description': description});

    _loadPublications(); // Recargar las publicaciones después de insertar
    setState(() {
      _currentIndex = 0; // Cambia a la pantalla principal después de cargar
    });
  }

  void _loadPublications() async {
    final response = await supabase.from('publicaciones').select();

    if (response != null) {
      List<Map<String, dynamic>> publications =
          (response).cast<Map<String, dynamic>>();

      setState(() {
        _publications = publications.map((publication) {
          String imageData = publication['image_data'];
          String description = publication['description'];
          int likes = publication['likes'];
          int user_id = publication['id_usuario'];

          return ImageItem(
            imageData: imageData,
            description: description,
            likes: likes,
            logoImagePath: 'assets/images/oscar.png',
            Textid: user_id,
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
              child: ProfilePage(user_id: 3),
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

class ImageItem extends StatelessWidget {
  final String
      imageData; // Cambiado a String para contener la ruta de la imagen desde Supabase
  final String description;
  final int likes;
  final String logoImagePath;
  final int Textid;

  ImageItem({
    required this.imageData, // Cambiado de File a String
    required this.description,
    required this.likes,
    required this.logoImagePath,
    required this.Textid,
  });

  @override
  Widget build(BuildContext context) {
    // Decodificar los datos base64
    Uint8List imageDataBytes = base64Decode(imageData);

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
                child: Image.asset(logoImagePath, width: 30, height: 30),
              ),
              // Texto a la derecha del logo
              FutureBuilder<String>(
                future: getName(Textid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GestureDetector(
                      onTap: () {
                        // Navegar a la pantalla de perfil
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OtherProfilePage(user_id: Textid),
                          ),
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${snapshot.data} ",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      "Error",
                      style: TextStyle(color: Colors.white),
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
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
            child: LikeButton(
              initialLikeCount: likes,
            ),
          ),
          SizedBox(height: 0), // Margen por debajo de los botones
          Padding(
            padding: const EdgeInsets.only(left: 18.0, bottom: 40.0),
            child: Text(description, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<String> getName(int user_id) async {
    final response = await supabase
        .from('usuarios')
        .select("nombre")
        .eq("id_usuarios", user_id);
    return response[0]["nombre"];
  }
}

class LikeButton extends StatefulWidget {
  final int initialLikeCount;

  const LikeButton({Key? key, required this.initialLikeCount})
      : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late int likeCount;
  late bool isVoted;

  @override
  void initState() {
    super.initState();
    likeCount = widget.initialLikeCount;
    isVoted = false;
  }

  void handleVote() {
    setState(() {
      if (isVoted) {
        likeCount--;
      } else {
        likeCount++;
      }
      isVoted = !isVoted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
        Text('${likeCount}',
            style: TextStyle(fontSize: 16, color: Colors.white)),
      ],
    );
  }
}
