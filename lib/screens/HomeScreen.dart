import 'package:flutter/material.dart';
import 'ScannerScreen.dart';
import 'RecognizeScreen.dart';
import 'EnhanceScreen.dart';
import '../widgets/CustomButton.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Mate"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/scan_animation.json', height: 150, width: 150),
            CustomButton(
              text: "Scan Document",
              icon: Icons.camera_alt,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ScannerScreen()),
              ),
            ).animate().scale(duration: 500.ms).fadeIn(),
            CustomButton(
              text: "Recognize Text",
              icon: Icons.text_fields,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RecognizeScreen()),
              ),
            ).animate().slideX(),
            CustomButton(
              text: "Enhance Image",
              icon: Icons.auto_fix_high,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EnhanceScreen()),
              ),
            ).animate().fadeIn(duration: 700.ms),
          ],
        ),
      ),
    );
  }
}
