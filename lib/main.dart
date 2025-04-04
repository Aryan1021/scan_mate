import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ✅ Import provider
import 'package:scan_mate/screens/HomeScreen.dart';
import 'package:scan_mate/theme/theme_provider.dart'; // ✅ Correct ThemeProvider import

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white24,
            primaryColor: const Color(0xFF37474F),
            appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.black),
              bodyMedium: TextStyle(color: Colors.black),
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black87,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.black54),
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}
