import 'dart:io';
import 'dart:typed_data';
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

    try {
      // ✅ Read image and decode it properly
      Uint8List imageBytes = await _image!.readAsBytes();
      img.Image? image = img.decodeImage(Uint8List.fromList(imageBytes));

      if (image == null) {
        debugPrint("❌ Error: Unable to decode the image.");
        return;
      }

      // ✅ Apply contrast and brightness adjustment
      image = img.adjustColor(image, brightness: 5, contrast: 0.175);

      // ✅ Apply sharpening using a convolution kernel
      final List<int> sharpenKernel = [
        0, -1,  0,
        -1,  5, -1,
        0, -1,  0
      ];
      image = img.convolution(image, filter: sharpenKernel, div: 1, offset: 0);

      // ✅ Save the enhanced image
      final String newPath = _image!.path.replaceFirst('.jpg', '_enhanced.jpg');
      File enhancedFile = File(newPath);
      await enhancedFile.writeAsBytes(img.encodeJpg(image));

      setState(() {
        _image = enhancedFile;  // Update UI with the enhanced image
      });

      debugPrint("✅ Image enhancement complete.");
    } catch (e) {
      debugPrint("❌ Error during enhancement: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enhance Image", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? InteractiveViewer(
              child: Image.file(_image!, height: 300),
            )
                : const Icon(Icons.auto_fix_high, size: 100, color: Colors.blueAccent),
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
