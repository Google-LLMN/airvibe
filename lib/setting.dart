import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      appBar: DefaultAppBar(title: "Settings"),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: double.infinity),
          child: ListView(
            children: [
              _SingleSection(
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
                      title: "Security Status",
                      icon: CupertinoIcons.lock_shield,
                      onTap: () {}),
                ],
              ),
              const Divider(),
              _SingleSection(
                title: "Manage",
                children: [
                  CustomListTile(
                      title: "Account",
                      icon: Icons.account_circle_outlined,
                      onTap: () {}),
                  CustomListTile(
                      title: "Help & Feedback",
                      icon: Icons.help_outline_rounded,
                      onTap: () {}),
                  CustomListTile(
                      title: "About",
                      icon: Icons.info_outline_rounded,
                      onTap: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Class to create new ListTile
class CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  const CustomListTile({
    Key? key,
    required this.title,
    required this.icon,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      textColor: Colors.white,
      iconColor: Colors.white,
      onTap: onTap,
    );
  }
}

// Class to create a separation.
class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SingleSection({
    Key? key,
    this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}

// Class for default AppBar
class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const DefaultAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      elevation: 0,
      backgroundColor: const Color(0x00000000),
    );
  }
}

// Setting page for 'My Location'
class LocationSettingPage extends StatefulWidget {
  const LocationSettingPage({super.key});

  @override
  State<LocationSettingPage> createState() => _LocationSettingPageState();
}

class _LocationSettingPageState extends State<LocationSettingPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Color.fromARGB(255, 32, 56, 100),
        appBar: DefaultAppBar(
          title: "My Location",
        ));
  }
}
