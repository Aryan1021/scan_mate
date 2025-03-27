import 'package:flutter/material.dart';
import 'package:scan_mate/screens/HomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white24,
        primaryColor: Color(0xFF37474F),
        appBarTheme: AppBarTheme(backgroundColor: Colors.blue),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: HomeScreen(),
    );
  }
}