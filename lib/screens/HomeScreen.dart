import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ScannerScreen.dart';
import 'RecognizeScreen.dart';
import 'EnhanceScreen.dart';
import '../widgets/CustomButton.dart';
import '../theme/theme_provider.dart'; // Import ThemeProvider
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // Access ThemeProvider

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Scan Mate",
          style: TextStyle(fontSize: 30.0, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                themeProvider.toggleTheme(); // Toggle theme
              },
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2), // Semi-transparent background
                ),
                child: Icon(
                  themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
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
                MaterialPageRoute(builder: (context) => EnhanceScreen()),
              ),
            ).animate().fadeIn(duration: 700.ms),
          ],
        ),
      ),
    );
  }
}
