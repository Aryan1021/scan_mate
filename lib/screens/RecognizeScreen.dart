import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class RecognizeScreen extends StatefulWidget {
  const RecognizeScreen({super.key});

  @override
  _RecognizeScreenState createState() => _RecognizeScreenState();
}

class _RecognizeScreenState extends State<RecognizeScreen> {
  File? _image;
  String _recognizedText = "No text recognized";
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
    });

    await _recognizeText();
  }

  Future<void> _recognizeText() async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final inputImage = InputImage.fromFile(_image!);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    setState(() {
      _recognizedText = recognizedText.text.isNotEmpty ? recognizedText.text : "No text detected";
    });

    textRecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recognize Text", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white), // Change back arrow color to white
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null ? Image.file(_image!, height: 200) : const Icon(Icons.text_fields, size: 100, color: Colors.blueAccent),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.file_upload),
              label: const Text("Upload Image"),
              onPressed: _pickImage,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200, // Fixed height for scroll area
              child: SingleChildScrollView(
                child: Text(
                  _recognizedText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
