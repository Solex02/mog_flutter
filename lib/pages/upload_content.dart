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
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(255, 54, 62, 116),
      body: Center(
  
        child: Container(
          
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            
            color: Color.fromARGB(255, 37, 45, 95),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  icon: Icon(Icons.image, color: const Color.fromARGB(255, 37, 45, 95)),
                  label: Text(
                    'Seleccionar Imagen',
                    style: TextStyle(color: const Color.fromARGB(255, 37, 45, 95)),
                  ),
                ),
                SizedBox(height: 20),
                imagePath.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.file(
                          File(imagePath),
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(),
                SizedBox(height: 20),
                TextField(
                  controller: descriptionController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: handleUpload,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Subir',
                    style: TextStyle(color: const Color.fromARGB(255, 37, 45, 95)),
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