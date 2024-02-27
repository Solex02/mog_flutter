import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class UploadContent extends StatefulWidget {
  final Function(String, String) onUpload;

  UploadContent({required this.onUpload});

  @override
  _UploadContentState createState() => _UploadContentState();
}

class _UploadContentState extends State<UploadContent> {
  late TextEditingController descriptionController;
  late String imagePath;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController();
    imagePath = '';
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  void handleUpload() {
    String description = descriptionController.text;
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
          // Reduzco la altura del Container
          height: MediaQuery.of(context).size.height - kToolbarHeight,
          color: Color.fromARGB(255, 37, 45, 95),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                TextField(
                  controller: descriptionController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 16),
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
