import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class EnhanceScreen extends StatefulWidget {
  const EnhanceScreen({super.key});

  @override
  _EnhanceScreenState createState() => _EnhanceScreenState();
}

class _EnhanceScreenState extends State<EnhanceScreen> {
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future<void> _enhanceImage() async {
    if (_image == null) return;

    img.Image? image = img.decodeImage(await _image!.readAsBytes());
    if (image == null) return;

    img.Image enhanced = img.adjustColor(image, contrast: 1.5, brightness: 20);
    File enhancedFile = File(_image!.path)..writeAsBytesSync(img.encodeJpg(enhanced));

    setState(() {
      _image = enhancedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enhance Image", style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.blueAccent
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null ? Image.file(_image!, height: 200) : const Icon(Icons.auto_fix_high, size: 100, color: Colors.blueAccent),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.file_upload),
              label: const Text("Upload Image"),
              onPressed: _pickImage,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.auto_fix_normal),
              label: const Text("Enhance Image"),
              onPressed: _enhanceImage,
            ),
          ],
        ),
      ),
    );
  }
}
