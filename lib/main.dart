// Code in dart language using flutter
// AirVibe - An Android app to make the world better
// Author: Rungrit P. Year 12
// Coded using Flutter 3.0.3
// This code can be use without any of my permission

// Main file to run the app doesn't have much other than navigator to other page within the application
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart' show HomeScreen; // import home screen
import 'news.dart' show NewsScreen; // import news screen
import 'add.dart' show ScreenTabBar; // import add screen

// Main method used to run an app. Very important!!!!111
void main() => runApp(const MainStuff());

// A class for Welcome Page. (Used to)
// It contains the style of top bar (Where the time, battery, and wifi are )
// Also a house for Welcome Page.
class MainStuff extends StatelessWidget {
  final SystemUiOverlayStyle _style = const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 32, 56, 100));

  const MainStuff({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(_style);
    return const MaterialApp(
      home: MainStateFullWidget(),
    );
  }
}

// Called by the Welcome Page
// This is a scaffold where it provide various widget such as bottomAppBar
class MainStateFullWidget extends StatefulWidget {
  const MainStateFullWidget({super.key});

  @override
  State<MainStateFullWidget> createState() => _MainStateFullWidgetState();
}

class _MainStateFullWidgetState extends State<MainStateFullWidget> {
  int _selectedIndex = 0;

  // Define the pages and screens that correspond to each BottomNavigationBarItem.
  // i.e. When pressed the first button (from left), it will go to HomeScreen()
  final List<Widget> _pages = [
    const HomeScreen(),
    const NewsScreen(),
  ];

  // Function to handle the tap event of the BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Scaffold contains 2 BottomNavigationBars: Home and News
  // It also has big green circle FloatingActionButton at the bottom center of the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      backgroundColor: const Color.fromARGB(255, 32, 56, 100),

      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: "News")
        ],
      ),

      // I don't know if this an intended way to do it
      // I moved button down using Padding!
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: SizedBox(
          width: 100,
          height: 100,
          child: FloatingActionButton(
            tooltip: 'Add',
            heroTag: 'AddScreenTag',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ScreenTabBar()));
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
                backgroundColor: Colors.green,
                child: const Icon(Icons.add, size: 50, color: Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
