// For the add page. When you clicked the big plus green button
// TODO: Finish add page

import 'package:flutter/material.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 44, 77, 138),
      ),
      backgroundColor: const Color.fromARGB(255, 32, 56, 100),
      body: const Center(
        child: Text('Coming Soon...', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
