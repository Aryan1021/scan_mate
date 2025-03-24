import 'package:flutter/material.dart';

class RecognizeScreen extends StatelessWidget {
  const RecognizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recognize Text"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.text_fields, size: 100, color: Colors.blueAccent),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.file_upload),
              label: const Text("Upload Image"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // TODO: Implement OCR functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
