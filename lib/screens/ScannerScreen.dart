import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  File? scannedImage;

  Future<void> saveImage(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/scanned_document.png';
    await image.copy(path);
    setState(() {
      scannedImage = File(path);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Image saved successfully!")),
    );
  }

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
      appBar: AppBar(title: const Text("Scanner")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            scannedImage != null
                ? Image.file(scannedImage!)
                : const Text("No image scanned yet"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Simulate image scan (Replace with actual scanning logic)
                saveImage(File("assets/sample_scan.png"));
              },
              child: const Text("Scan & Save"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: shareImage,
              child: const Text("Share"),
            ),
          ],
        ),
      ),
    );
  }
}
