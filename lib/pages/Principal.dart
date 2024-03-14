import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importar SharedPreferences
import 'package:supabase/supabase.dart';
import 'package:mog_flutter/others/color_palette.dart';
import 'package:mog_flutter/pages/otherprofile.dart';
import 'upload_content.dart'; // Importa el nuevo archivo
import 'package:uuid/uuid.dart';
import 'package:mog_flutter/pages/profile.dart';
import 'package:mog_flutter/pages/ranking.dart';

final supabase = SupabaseClient(
  'https://ngejlljkgxzpnwznpddk.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5nZWpsbGprZ3h6cG53em5wZGRrIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTY0MDY1NjMsImV4cCI6MjAxMTk4MjU2M30.nlZnIiHCjiThvu-cLj_aBPYaGE1knPFWXOhCkJQDLL4',
);

class MainActivity extends StatefulWidget {
  const MainActivity({Key? key, required this.user_id}) : super(key: key);

  final int user_id;

  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  int _currentIndex = 0;
  List<Widget> _publications = [];

  @override
  void initState() {
    super.initState();

    print(widget.user_id);
    _loadPublications();
  }

  void handleUpload(String imagePath, String description) async {
    List<int> bytes = await File(imagePath).readAsBytes();
    String imageData = base64Encode(bytes);

    final response = await supabase.from('publicaciones').insert({
      'image_data': imageData,
      "id_usuario": widget.user_id,
      'description': description,
      "likes": 0
    });

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
          int publication_id =
              publication['id_publicaciones']; // Utilizamos 'id_publicaciones' como el campo que contiene el ID de la publicación

          return ImageItem(
            imageData: imageData,
            description: description,
            likes: likes,
            logoImagePath: 'assets/images/1.png',
            Textid: user_id,
            publicationId: publication_id, // Agregamos el ID de la publicación al constructor de ImageItem
            userId: widget.user_id, // Pasamos el user_id a ImageItem
          );
        }).toList();

        // Imprimir los IDs antes de ordenar
        _publications.forEach((publication) {});

        // Ordenar la lista de publicaciones por ID de manera descendente
        _publications.sort((a, b) => (b as ImageItem).publicationId
            .compareTo((a as ImageItem).publicationId));

        // Imprimir los IDs después de ordenar
        _publications.forEach((publication) {});
      });
    } else {
      print('Error fetching publications');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: mcgpalette0.shade900,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/mogo_logo.png',
                width: 80, height: 80),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Color.fromARGB(255, 22, 29, 77),
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
                        itemBuilder: (context, index) =>
                            _publications[index],
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
              child: ProfilePage(user_id: widget.user_id),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: mcgpalette0.shade900),
          BottomNavigationBarItem(
              icon: Icon(Icons.flag),
              label: 'Top',
              backgroundColor: mcgpalette0.shade900),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: 'Upload',
              backgroundColor: mcgpalette0.shade900),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: mcgpalette0.shade900),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
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
  final int publicationId; // Agregamos el parámetro para el ID de publicación
  final int userId; // Agregamos el parámetro para el ID de usuario

  ImageItem({
    required this.imageData, // Cambiado de File a String
    required this.description,
    required this.likes,
    required this.logoImagePath,
    required this.Textid,
    required this.publicationId,
    required this.userId, // Agregamos esta línea
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
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: new BoxDecoration(
                        color: Color.fromARGB(221, 255, 0, 85),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 3)),
                  )),
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
              publicationId: publicationId, // Pasar el publicationId aquí
              userId: userId, // Pasar el userId aquí
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
  final int publicationId;
  final int userId; // Agregar este campo

  const LikeButton({
    Key? key,
    required this.initialLikeCount,
    required this.publicationId,
    required this.userId, // Agregar esta línea
  }) : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late int likeCount;
  bool isVoted = false;

  @override
  void initState() {
    super.initState();
    likeCount = widget.initialLikeCount;
    _checkIfVoted();
  }

  // Función para verificar si el usuario ya ha dado like previamente
  void _checkIfVoted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? hasLiked = prefs.getBool('${widget.userId}_${widget.publicationId}');
    setState(() {
      isVoted = hasLiked ?? false; // Si el valor es null, se establece en false
    });
  }
  void handleVote() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  setState(() {
    if (isVoted) {
      likeCount--;
      prefs.remove('${widget.userId}_${widget.publicationId}'); // Elimina el registro de like
    } else {
      likeCount++;
      prefs.setBool('${widget.userId}_${widget.publicationId}', true); // Guarda el like
    }
    isVoted = !isVoted;
  });

    // Actualizar la base de datos
    final response = await supabase
        .from('publicaciones')
        .update({'likes': likeCount})
        .eq('id_publicaciones', widget.publicationId)
        ;

    if (response.error != null) {
      print('Error updating like count: ${response.error?.message}');
      // Revertir el cambio local si falla la actualización en la base de datos
      setState(() {
        if (isVoted) {
          likeCount++;
        } else {
          likeCount--;
        }
        isVoted = !isVoted;
      });
    }
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