import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.title}) : super(key: key);
  final String title; // Título de la página de perfil

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState(); // Crea el estado de la página de perfil
}

class _ProfilePageState extends State<ProfilePage> {
  // Variables de estado
  int publicationCount = 0; // Contador de publicaciones
  bool isEditing = false; // Indica si se está editando el perfil
  TextEditingController nameController =
      TextEditingController(); // Controlador del campo de nombre
  TextEditingController descriptionController =
      TextEditingController(); // Controlador del campo de descripción
  String savedName = ""; // Nombre guardado
  String savedDescription = ""; // Descripción guardada

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
            // Sección de perfil
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
              // Fila para las estadísticas de seguidores y seguidos
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround, // Alineación de los elementos
              children: <Widget>[
                _buildStat("Seguidores", "0"), // Estadísticas de seguidores
                _buildStat("Seguidos", "0"), // Estadísticas de seguidos
              ],
            ),
            SizedBox(height: 20), // Espacio entre elementos
            Divider(
              // Línea divisoria
              color: Color.fromARGB(255, 240, 238, 238),
              thickness: 2.0,
              height: 0.0,
            ),
            _buildProfileSection(screenWidth), // Sección de perfil
            SizedBox(height: 20), // Espacio entre elementos
            ElevatedButton(
              // Botón para editar perfil
              onPressed: () {
                _showEditProfileDialog(); // Mostrar el diálogo de edición de perfil
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
              child: Text(
                isEditing ? "Guardar" : "Editar perfil",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20), // Espacio entre elementos
            Divider(
              // Otra línea divisoria
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

  // Sección de perfil
  Widget _buildProfileSection(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isEditing
            ? Container(
                // Contenedor para campos de texto de edición
                width: screenWidth,
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      // Campo de texto para nombre
                      controller: nameController,
                      labelText: "Nombre",
                      maxLength: 20,
                    ),
                    _buildTextField(
                      // Campo de texto para descripción
                      controller: descriptionController,
                      labelText: "Descripción",
                      maxLength: 100,
                    ),
                    SizedBox(height: 50), // Espacio entre elementos
                  ],
                ),
              )
            : savedName.isNotEmpty || savedDescription.isNotEmpty
                ? Column(
                    // Mostrar nombre y descripción guardados
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildListTile("Nombre", savedName),
                      _buildListTile("Descripción", savedDescription),
                    ],
                  )
                : Container(), // No mostrar nada si no hay información guardada
      ],
    );
  }

  // Construcción de etiqueta
  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 5),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Construcción de campo de texto
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required int maxLength,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white, fontSize: 18),
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  // Construcción de elemento de lista
  Widget _buildListTile(String title, String value) {
    return ListTileTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  // Construcción de cuadrícula de publicaciones
  Widget _buildGridView() {
    List<String> userPublications = []; // Lista de publicaciones del usuario

    return userPublications.isEmpty // Verificar si no hay publicaciones
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

  // Mostrar el diálogo de edición de perfil
  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          child: Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Editar perfil",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(height: 20), // Espacio entre elementos
                _buildTextField(
                  controller: nameController,
                  labelText: "Nombre",
                  maxLength: 20,
                ),
                SizedBox(height: 20), // Espacio entre elementos
                _buildTextField(
                  controller: descriptionController,
                  labelText: "Descripción",
                  maxLength: 100,
                ),
                SizedBox(height: 20), // Espacio entre elementos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      ),
                      child: Text(
                        "Cancelar",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        savedName =
                            nameController.text; // Guardar el nombre editado
                        savedDescription = descriptionController
                            .text; // Guardar la descripción editada
                        Navigator.pop(context); // Cerrar el diálogo
                        setState(() {
                          isEditing = false; // Cambiar el estado de edición
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      child: Text(
                        "Guardar",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
