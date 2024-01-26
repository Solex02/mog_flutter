import 'package:flutter/material.dart';

class OtherProfilePage extends StatefulWidget {
  const OtherProfilePage({Key? key, required this.title}) : super(key: key);
  final String title; // Título de la página de perfil de otro usuario

  @override
  State<OtherProfilePage> createState() =>
      _OtherProfilePageState(); // Crea el estado de la página de perfil de otro usuario
}

class _OtherProfilePageState extends State<OtherProfilePage> {
  // Variables de estado
  int publicationCount = 0; // Contador de publicaciones
  bool isEditing = false; // Indica si se está editando el perfil
  TextEditingController nameController =
      TextEditingController(); // Controlador del campo de nombre
  TextEditingController descriptionController =
      TextEditingController(); // Controlador del campo de descripción
  String savedName = ""; // Nombre guardado
  String savedDescription = ""; // Descripción guardada
  int followersCount = 0; // Contador de seguidores
  bool isFollowing = false; // Indica si se está siguiendo al usuario

  @override
  Widget build(BuildContext context) {
    double screenWidth =
        MediaQuery.of(context).size.width; // Ancho de la pantalla

    return Scaffold(
      // Estructura básica de la página
      body: Container(
        // Contenedor principal
        padding: EdgeInsets.all(20), // Relleno alrededor del contenedor
        width:
            screenWidth, // Ancho del contenedor igual al ancho de la pantalla
        decoration: BoxDecoration(
            color:
                Color.fromARGB(255, 22, 29, 77)), // Decoración del contenedor
        child: Column(
          // Columna que contiene los elementos
          children: <Widget>[
            SizedBox(height: 20), // Espacio entre elementos
            Icon(
              // Icono del perfil
              Icons.account_circle,
              size: 120,
              color: Colors.white,
            ),
            SizedBox(height: 10), // Espacio entre elementos
            Text(
              // Nombre del perfil
              "Mario Barea",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20), // Espacio entre elementos
            Row(
              // Fila para las estadísticas de seguidores, seguidos y botón de seguir
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround, // Alineación de los elementos
              children: <Widget>[
                _buildStat("Seguidores",
                    followersCount.toString()), // Estadísticas de seguidores
                _buildStat("Seguidos", "0"), // Estadísticas de seguidos
                _buildFollowButton(), // Botón para seguir o dejar de seguir
              ],
            ),
            SizedBox(height: 20), // Espacio entre elementos
            Divider(
              // Línea divisoria
              color: Color.fromARGB(255, 240, 238, 238),
              thickness: 2.0,
              height: 0.0,
            ),
            _buildGridView(), // Cuadrícula de publicaciones
          ],
        ),
      ),
    );
  }

  // Construcción de estadísticas
  Widget _buildStat(String title, String value) {
    return Column(
      children: [
        Text(
          // Título de la estadística
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Roboto',
          ),
        ),
        Text(
          // Valor de la estadística
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }

  // Construcción del botón de seguir/dejar de seguir
  Widget _buildFollowButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (isFollowing) {
            followersCount--; // Disminuye el contador si se deja de seguir
          } else {
            followersCount++; // Incrementa el contador si se sigue
          }
          isFollowing = !isFollowing; // Cambia el estado de seguir/no seguir
        });
      },
      style: ElevatedButton.styleFrom(
        primary: isFollowing
            ? Colors.grey
            : Colors.blue, // Color del botón según si se está siguiendo o no
      ),
      child: Text(
        isFollowing
            ? "Siguiendo"
            : "Seguir", // Texto del botón según si se está siguiendo o no
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }

  // Construcción de la cuadrícula de publicaciones
  Widget _buildGridView() {
    List<String> userPublications =
        []; // Supongamos que userPublications contiene las rutas de las imágenes.

    return userPublications.isEmpty
        ? Center(
            child: Container(
              margin: EdgeInsets.only(top: 200),
              child: Text(
                "Aun no hay publicaciones :(", // Mensaje de no hay publicaciones
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        : SizedBox(
            height: 300, // Altura de la cuadrícula de publicaciones
            child: GridView.builder(
              primary: false,
              padding: const EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: determineCrossAxisCount(userPublications
                    .length), // Determinar el número de columnas en función del número de publicaciones
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: userPublications.length,
              itemBuilder: (context, index) {
                publicationCount++;
                return Container(
                  child: InkWell(
                    onTap: () {
                      // Handle your callback.
                    },
                    splashColor: Colors.brown.withOpacity(0.5),
                    child: Image(
                      image: AssetImage(userPublications[index]),
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          );
  }

  // Determinar el número de columnas en la cuadrícula
  int determineCrossAxisCount(int itemCount) {
    if (itemCount == 1) {
      return 1;
    } else if (itemCount == 2) {
      return 2;
    } else if (itemCount == 3) {
      return 3;
    } else {
      return 2;
    }
  }
}
