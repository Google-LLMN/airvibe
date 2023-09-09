import 'package:flutter/material.dart';
import 'SettingDirectory/export_page.dart';
import 'SettingDirectory/location_page.dart';
import 'SettingDirectory/help_feedback_page.dart';
import 'SettingDirectory/news_sources_page.dart';
import 'Data/airvibe_methods.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

// Lists of all available settings. Can be added more with CustomListTile() class
// _SingleSection to separate them.
class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 56, 100),
      appBar: const DefaultAppBar(title: "Settings"),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: double.infinity),
          child: ListView(
            children: [
              SingleSection(
                title: "General",
                children: [
                  CustomListTile(
                    title: "My Location",
                    icon: Icons.location_on_outlined,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const LocationSettingPage()));
                    },
                  ),
                  CustomListTile(
                    title: "News Source",
                    icon: Icons.location_on_outlined,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const NewsSourceSettingPage()));
                    },
                  ),
                ],
              ),
              const Divider(),
              SingleSection(
                title: "Other",
                children: [
                  CustomListTile(
                      title: "Account",
                      icon: Icons.account_circle_outlined,
                      onTap: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            "Coming Soon...",
                            style: TextStyle(color: Colors.black),
                          ),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.white,
                        ));
                      }),
                  CustomListTile(
                      title: "Help & Feedback",
                      icon: Icons.help_outline_rounded,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const HelpAndFeedbackPage()));
                      }),
                  CustomListTile(
                      title: "About",
                      icon: Icons.info_outline_rounded,
                      onTap: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text("Coming Soon...",
                              style: TextStyle(color: Colors.black)),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.white,
                        ));
                      }),
                ],
              ),
              const Divider(),
              SingleSection(title: 'Data', children: [
                CustomListTile(
                    title: "Export my data",
                    icon: Icons.exit_to_app,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ExportSimpleDataScreen()));
                    })
              ])
            ],
          ),
        ),
      ),
    );
  }
}