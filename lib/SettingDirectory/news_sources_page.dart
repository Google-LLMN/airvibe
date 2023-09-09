import 'package:flutter/material.dart';
import '../Data/airvibe_methods.dart';
import '../Data/shared_preferences_data.dart';

class NewsSourceSettingPage extends StatefulWidget {
  const NewsSourceSettingPage({super.key});

  @override
  State<NewsSourceSettingPage> createState() => _NewsSourceSettingPageState();
}

class _NewsSourceSettingPageState extends State<NewsSourceSettingPage> {
  @override
  void initState() {
    super.initState();
    _loadSavedValues();
  }

  int selectedValue = 1;
  bool isLoading = true;

  void _loadSavedValues() async {
    int? newsSource = await SavedNewsSource.getSelectedNewsSource();

    setState(() {
      selectedValue = newsSource ?? 1;
      isLoading = false; // Use 1 as the default value if newsSource is null
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading // loading screen while the getSelectedNewsSource is not yet complete
        ? const Center(
      child: SizedBox(
        width: 48,
        height: 48,
        child: CircularProgressIndicator(),
      ),
    )
        : Scaffold(
        backgroundColor: const Color.fromARGB(255, 32, 56, 100),
        appBar: const DefaultAppBar(title: "News Source"),
        body: Column(
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: Colors.white,
              ),
              child: RadioListTile<int>(
                activeColor: Colors.white,
                title: const Text('ABC News',
                    style: TextStyle(color: Colors.white)),
                value: 1,
                groupValue: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value!;
                  });
                  SavedNewsSource.saveSelectedNewsSource(selectedValue);
                },
              ),
            ),
            Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: Colors.white,
              ),
              child: RadioListTile<int>(
                activeColor: Colors.white,
                title: const Text('The Guardian',
                    style: TextStyle(color: Colors.white)),
                value: 2,
                groupValue: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value!;
                  });
                  SavedNewsSource.saveSelectedNewsSource(selectedValue);
                },
              ),
            ),
            Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: Colors.white,
              ),
              child: RadioListTile<int>(
                activeColor: Colors.white,
                title: const Text('SBS News',
                    style: TextStyle(color: Colors.white)),
                value: 3,
                groupValue: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value!;
                  });
                  SavedNewsSource.saveSelectedNewsSource(selectedValue);
                },
              ),
            ),
            Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: Colors.white,
              ),
              child: RadioListTile<int>(
                activeColor: Colors.white,
                title: const Text('9News',
                    style: TextStyle(color: Colors.white)),
                value: 4,
                groupValue: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value!;
                  });
                  SavedNewsSource.saveSelectedNewsSource(selectedValue);
                },
              ),
            ),
          ],
        ));
  }
}