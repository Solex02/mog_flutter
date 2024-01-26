import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadContent extends StatefulWidget {
  // Función de devolución de llamada para manejar la subida de contenido
  final Function(String, String) onUpload;

  // Constructor que recibe la función de devolución de llamada como parámetro
  UploadContent({required this.onUpload});

  @override
  _UploadContentState createState() => _UploadContentState();
}

class _UploadContentState extends State<UploadContent> {
  // Controlador de texto para la descripción
  late TextEditingController descriptionController;

  // Ruta de la imagen seleccionada
  late String imagePath;

  @override
  void initState() {
    super.initState();

    // Inicializa el controlador de texto y la ruta de la imagen
    descriptionController = TextEditingController();
    imagePath = '';
  }

  // Método asincrónico para seleccionar una imagen de la galería
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      // Actualiza el estado con la ruta de la imagen seleccionada
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  // Método para manejar la subida de contenido
  void handleUpload() {
    // Obtiene la descripción del controlador de texto
    String description = descriptionController.text;

    // Llama a la función de devolución de llamada con la ruta de la imagen y la descripción
    widget.onUpload(imagePath, description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subir Foto', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 37, 45, 95),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height - kToolbarHeight,
          color: Color.fromARGB(255, 37, 45, 95),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Botón para seleccionar imágenes
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                      ),
                      child: Text(
                        'Seleccionar Imagen',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    SizedBox(width: 50),
                    // Vista previa de la imagen seleccionada (si existe)
                    imagePath.isNotEmpty
                        ? Image.file(
                            File(imagePath),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          )
                        : Container(),
                  ],
                ),
                SizedBox(height: 16),
                // Campo de texto para la descripción
                TextField(
                  controller: descriptionController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 16),
                // Botón para subir contenido
                ElevatedButton(
                  onPressed: handleUpload,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                  ),
                  child: Text(
                    'Subir',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
