import 'package:flutter/material.dart';

class EnhanceScreen extends StatelessWidget {
  const EnhanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enhance Image"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_fix_high, size: 100, color: Colors.blueAccent),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.filter),
              label: const Text("Apply Enhancement"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // TODO: Implement image enhancement functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
