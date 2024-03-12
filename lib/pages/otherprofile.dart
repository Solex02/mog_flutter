import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

final supabase = SupabaseClient('https://ngejlljkgxzpnwznpddk.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5nZWpsbGprZ3h6cG53em5wZGRrIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTY0MDY1NjMsImV4cCI6MjAxMTk4MjU2M30.nlZnIiHCjiThvu-cLj_aBPYaGE1knPFWXOhCkJQDLL4');

class OtherProfilePage extends StatefulWidget {
  const OtherProfilePage({Key? key, required this.user_id}) : super(key: key);

  final int user_id;

  @override
  State<OtherProfilePage> createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {
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
  List<String> userPublications = [
    'assets/images/ferrari.png',
    'assets/images/honda.png',
    'assets/images/koenigsegg.png',
    'assets/images/regera.png',
  ];

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

  Future<void> getPublicaciones(String id_publicaciones) async {
    final data = await supabase
        .from('publicaciones')
        .select()
        .eq("id_publicaciones", id_publicaciones);

    setState(() {
      image_data = data[0]["image_data"];
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
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            width: screenWidth,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 22, 29, 77),
            ),
            child: Column(
              children: <Widget>[
                Stack(
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 120,
                      color: Colors.white,
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
                      ),
                    ),
                  ],
                ),
                Text(
                  nombre,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                Divider(
                  color: Color.fromARGB(255, 240, 238, 238),
                  thickness: 2.0,
                  height: 0.0,
                ),
                _buildProfileSection(screenWidth),
                Divider(
                  color: Color.fromARGB(255, 240, 238, 238),
                  thickness: 2.0,
                  height: 0.0,
                ),
                _buildGridView(userPublications),
              ],
            ),
          ),
          Positioned(
            top: 25,
            left: 10,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

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
                : Container(),
      ],
    );
  }

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
}
