import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.title});
  final String title;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    // Obtén el ancho de la pantalla
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        width: screenWidth,
        // Establece el color de fondo del contenedor
        decoration: BoxDecoration(color: Color.fromARGB(255, 22, 29, 77)),
        child: Column(
          children: <Widget>[
            // Añade un espacio en blanco en la parte superior
            SizedBox(height: 40),
            Container(
              // Establece un margen en el lado izquierdo del contenedor
              margin: EdgeInsets.only(
                  left: 10), // Ajusta el margen izquierdo según tus necesidades
              child: Row(
                // Alinea los elementos al inicio del Row (a la izquierda)
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // Añade un icono de perfil
                  Icon(
                    Icons.account_circle,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 80, // Tamaño del icono aumentado
                  ),
                  SizedBox(
                      width: screenWidth *
                          0.04), // Añade espacio entre el icono y el texto "Publicaciones"
                  // Añade el texto "Publicaciones" con un padding uniforme
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        Text(
                          "Publicaciones",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18, // Tamaño del texto aumentado
                            fontFamily: 'Roboto',
                          ),
                        ),
                        Text(
                          "0",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18, // Tamaño del texto aumentado
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      width: screenWidth *
                          0.04), // Añade espacio entre "Publicaciones" y "Seguidores"
                  // Añade el texto "Seguidores" con un padding uniforme
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        Text(
                          "Seguidores",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18, // Tamaño del texto aumentado
                            fontFamily: 'Roboto',
                          ),
                        ),
                        Text(
                          "0",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18, // Tamaño del texto aumentado
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      width: screenWidth *
                          0.04), // Añade espacio entre "Seguidores" y "Seguidos"
                  // Añade el texto "Seguidos" con un padding uniforme
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        Text(
                          "Seguidos",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18, // Tamaño del texto aumentado
                            fontFamily: 'Roboto',
                          ),
                        ),
                        Text(
                          "0",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18, // Tamaño del texto aumentado
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
