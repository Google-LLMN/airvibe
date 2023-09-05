// For the add page. When you clicked the big plus green button
// TODO: Finish add page

import 'package:flutter/material.dart';
import 'Data/airvibe_methods.dart';

class ScreenTabBar extends StatefulWidget {
  const ScreenTabBar({Key? key}) : super(key: key);

  @override
  State<ScreenTabBar> createState() => _ScreenTabBarState();
}

class _ScreenTabBarState extends State<ScreenTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _selectedColor = const Color.fromARGB(255, 15, 27, 48);
  final _tabs = [
    const Tab(text: 'Surveys'),
    const Tab(text: 'Result'),
    const Tab(text: 'Create'),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Survey"),
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 32, 56, 100),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              height: kToolbarHeight - 8.0,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(35.0),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(35.0),
                    color: _selectedColor),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white24,
                tabs: _tabs,
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  SurveyScreen(),
                  ResultScreen(),
                  CreateScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SurveyScreen extends StatelessWidget {
  const SurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 56, 100),
      body: ListView(
        children: const [
          Divider(height: 30),
          SingleSection(
            title: "Environment",
              children: [
            CustomListTile(title: 'First', icon: Icons.find_in_page_rounded)
          ])
        ],
      )
    );
  }
}

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Result Screen. Coming Soon...', style: TextStyle(color: Colors.white)),
    );
  }
}

// Create survey screen. Unused for now
// TODO: Make use of it
class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100)),
        tooltip: 'Create',
        heroTag: 'Create',
        backgroundColor: Colors.green[400],
        child: const Icon(Icons.add_circle, size: 40, color: Colors.white),
        onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("You do not have a permission to do that"),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
        ));
        },
      ),
    );
  }
}
