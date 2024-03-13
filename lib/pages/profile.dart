import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

// Inicialización de SupabaseClient con la URL y la clave de la API.
final supabase = SupabaseClient('https://ngejlljkgxzpnwznpddk.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5nZWpsbGprZ3h6cG53em5wZGRrIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTY0MDY1NjMsImV4cCI6MjAxMTk4MjU2M30.nlZnIiHCjiThvu-cLj_aBPYaGE1knPFWXOhCkJQDLL4');

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.user_id}) : super(key: key);

  final int user_id;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Declaración de variables y controladores necesarios.
  int publicationCount = 0;
  int segidores = 0;
  int seguidos = 0;
  String image_data = "";
  String nombre = "";
  String nombre_perfil = "";
  String descripcion = "";
  bool isEditing = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String savedName = "";
  String savedDescription = "";
  List<String> userPublications = [];

  @override
  void initState() {
    super.initState();
    getUser(widget.user_id);
    getBio(widget.user_id);
    _loadUserPublications(widget.user_id);
  }

  Future<void> getUser(int id_usuario) async {
    final data =
        await supabase.from('usuarios').select().eq("id_usuarios", id_usuario);

    setState(() {
      segidores = data[0]["seguidores"];
      seguidos = data[0]["seguidos"];
      nombre = data[0]["nombre"];
    });
  }

  Future<void> getBio(int id_usuario) async {
    final data =
        await supabase.from('usuarios').select().eq("id_usuarios", id_usuario);

    setState(() {
      nombre_perfil = data[0]["nombre_perfil"] ?? ""; // Manejo de valor nulo
      descripcion = data[0]["descripcion"] ?? ""; // Manejo de valor nulo
    });
  }

  Future<void> _loadUserPublications(int userId) async {
    final response =
        await supabase.from('publicaciones').select().eq("id_usuario", userId);

    final List<Map<String, dynamic>> publications =
        (response as List).cast<Map<String, dynamic>>();
    setState(() {
      userPublications = publications
          .map<String>((publication) => publication['image_data'] as String)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          width: screenWidth,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 22, 29, 77),
          ),
          child: Column(
            children: <Widget>[
              // Sección de la imagen del perfil y botón de edición.
              // Muestra la imagen y un botón para editar la imagen del perfil.
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: new BoxDecoration(
                        color: Color.fromARGB(221, 255, 0, 85),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 10)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      padding: EdgeInsets.all(1),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _showEditProfileDialog(); // Método para mostrar el diálogo de edición.
                        },
                      ),
                    ),
                  ),
                ],
              ),
              // Sección del nombre del usuario.
              Text(
                nombre,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Sección de estadísticas como seguidores y seguidos.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: [
                      Text(
                        "Seguidores",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      Text(
                        segidores.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Seguidos",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      Text(
                        seguidos.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  )
                ],
              ),
              // Divisores entre secciones.
              Divider(
                color: Color.fromARGB(255, 240, 238, 238),
                thickness: 2.0,
                height: 0.0,
              ),
              // Sección de perfil, incluyendo nombre y descripción.
              _buildProfileSection(screenWidth),
              // Divisor entre secciones.
              Divider(
                color: Color.fromARGB(255, 240, 238, 238),
                thickness: 2.0,
                height: 0.0,
              ),
              // Sección de publicaciones del usuario.
              _buildGridView(userPublications),
            ],
          ),
        ),
      ),
    );
  }

  // Construcción de la sección de perfil, incluyendo nombre y descripción.
  Widget _buildProfileSection(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isEditing
            ? Container(
                width: screenWidth,
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: nameController,
                      labelText: "Nombre",
                      maxLength: 20,
                    ),
                    _buildTextField(
                      controller: descriptionController,
                      labelText: "Descripción",
                      maxLength: 100,
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              )
            : nombre_perfil.isNotEmpty || descripcion.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildListTile("Nombre", nombre_perfil),
                      _buildListTile("Descripción", descripcion),
                    ],
                  )
                : Container(), // Si no hay datos guardados, muestra un contenedor vacío.
      ],
    );
  }

  // Construcción de un label de texto.
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

  // Construcción de un campo de texto.
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

  // Construcción de un elemento de lista.
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

  // Construcción de la cuadrícula de publicaciones del usuario.
  Widget _buildGridView(List<String> userPublications) {
    return userPublications.isEmpty
        ? Center(
            child: Container(
              margin: EdgeInsets.only(top: 100),
              child: Text(
                "Aun no hay publicaciones :(",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        : SizedBox(
            height: 500, // PUBLICACIONES GRINDVIEW //
            child: GridView.builder(
              primary: false,
              padding: const EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: userPublications.length,
              itemBuilder: (context, index) {
                publicationCount++;
                return Container(
                  child: InkWell(
                    onTap: () {},
                    splashColor: Colors.brown.withOpacity(0.5),
                    child: Image.memory(
                      base64.decode(userPublications[index]),
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

  // Muestra el diálogo de edición del perfil.
  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          child: Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * 0.8,
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
                SizedBox(height: 10),
                _buildTextField(
                  controller: nameController,
                  labelText: "Nombre",
                  maxLength: 20,
                ),
                SizedBox(height: 10),
                _buildTextField(
                  controller: descriptionController,
                  labelText: "Descripción",
                  maxLength: 100,
                ),
                SizedBox(height: 20),
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
                      onPressed: () async {
                        // Realizar la actualización en la base de datos
                        await updateProfile();
                        // Cerrar el diálogo
                        Navigator.pop(context);
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

  // Actualiza los datos del perfil en la base de datos
  Future<void> updateProfile() async {
    // Obtener los datos ingresados
    String newName = nameController.text;
    String newDescription = descriptionController.text;
    // Realizar la actualización en la base de datos
    final response = await supabase
        .from('usuarios')
        .update({'nombre_perfil': newName, 'descripcion': newDescription}).eq(
            "id_usuarios", widget.user_id);

    if (response.error == null) {
      // Actualizar los datos locales si la operación fue exitosa
      setState(() {
        nombre_perfil = newName;
        descripcion = newDescription;
      });
    }
  }
}
