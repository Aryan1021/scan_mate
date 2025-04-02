import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  File? scannedImage;

  /// Function to pick an image from camera or gallery
  Future<void> scanImage(ImageSource source) async {
    final XFile? image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      setState(() {
        scannedImage = File(image.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No image selected!")),
      );
    }
  }

  /// Function to save scanned image to local storage
  Future<void> saveImage() async {
    if (scannedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No scanned image to save!")),
      );
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/scanned_document.png';
    await scannedImage!.copy(path);

    setState(() {
      scannedImage = File(path);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Image saved successfully!")),
    );
  }

  /// Function to share the saved image
  void shareImage() async {
    if (scannedImage != null && await scannedImage!.exists()) {
      Share.shareXFiles([XFile(scannedImage!.path)], text: "Scanned Document from Scan Mate");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No scanned image found!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanner", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: scannedImage != null
                ? InteractiveViewer(
              panEnabled: true, // Allows panning when zoomed
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 1.0, // Default scale (no zoom initially)
              maxScale: 3.0, // Allows zoom up to 3x
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Image.file(
                  scannedImage!,
                  fit: BoxFit.contain, // Ensures full visibility initially
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            )
                : const Center(child: Text("No image scanned yet")),
          ),

          // Action Buttons
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.black87,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => scanImage(ImageSource.camera),
                      child: const Text("Scan (Camera)"),
                    ),
                    ElevatedButton(
                      onPressed: () => scanImage(ImageSource.gallery),
                      child: const Text("Scan (Gallery)"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: saveImage,
                  child: const Text("Save Image"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: shareImage,
                  child: const Text("Share"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}