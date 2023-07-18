import 'dart:ui';

import 'package:flutter/material.dart';

// Run the Application
void main() {
  runApp(const MainWindow());
}

// Main Window Class
class MainWindow extends StatelessWidget {
  const MainWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
        body: Text("Body"),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.newspaper_outlined), label: 'Document')
          ],
        ),
      ),
    );
  }
}
