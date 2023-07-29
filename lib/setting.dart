import 'package:flutter/material.dart';
import 'Data/shared_preferences_data.dart';
import 'Data/drop_down_menu_list.dart';
import 'package:url_launcher/url_launcher.dart';

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
                ],
              ),
              const Divider(),
              _SingleSection(
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
  void initState() {
    super.initState();
    _loadSavedValues();
  }

  void _loadSavedValues() async {
    String? savedCity = await SharedPreferencesUtils.getSelectedAUState();
    String? savedUrban = await SharedPreferencesUtils.getSelectedUrban();

    setState(() {
      selectedState = savedCity;
      selectedUrban = savedUrban;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 56, 100),
      appBar: const DefaultAppBar(
        title: "My Location",
      ),
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _title("Select City"),
                Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 56, 98, 176),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: _dropDownState(
                      underline: Container(),
                      style: const TextStyle(color: Colors.white),
                      dropdownColor: const Color.fromARGB(255, 56, 98, 176),
                      iconEnabledColor: Colors.white,
                      hintStyle: const TextStyle(color: Colors.white),
                    )),
                _title("Select Town"),
                Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 56, 98, 176),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: _dropDownUrban(
                      underline: Container(),
                      style: const TextStyle(color: Colors.white),
                      dropdownColor: const Color.fromARGB(255, 56, 98, 176),
                      iconEnabledColor: Colors.white,
                      hintStyle: const TextStyle(color: Colors.white),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _title(String val) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        val,
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  // Function to switch to correct town according to the currently selected state
  List<String> getUrbanTowns(String city) {
    switch (city) {
      case 'Australian Capital Territory':
        return urbanCentersACT;
      case 'New South Wales':
        return urbanCentersNSW;
      case 'Northern Territory':
        return urbanCentersNT;
      case 'Queensland':
        return urbanCentersQLD;
      case 'South Australia':
        return urbanCentersSA;
      case 'Tasmania':
        return urbanCentersTAS;
      case 'Victoria':
        return urbanCentersVIC;
      case 'Western Australia':
        return urbanCentersWA;
      default:
        return ['Default City 1', 'Default City 2'];
    }
  }

  // Function dropdown menu for State in Australia
  Widget _dropDownState({
    Widget? underline,
    Widget? icon,
    TextStyle? style,
    TextStyle? hintStyle,
    Color? dropdownColor,
    Color? iconEnabledColor,
  }) {
    return DropdownButton<String>(
      value: selectedState,
      underline: underline,
      icon: icon,
      dropdownColor: dropdownColor,
      style: style,
      iconEnabledColor: iconEnabledColor,
      onChanged: (String? newAUState) async {
        setState(() {
          selectedState = newAUState;
          selectedUrban = null;
        });
        await SharedPreferencesUtils.saveSelectedAUState(newAUState!);
      },
      hint: Text("Select a city", style: hintStyle),
      items: stateAU
          .map((city) =>
              DropdownMenuItem<String>(value: city, child: Text(city)))
          .toList(),
    );
  }

  // Function dropdown menu for City in selected state. see getUrbanTowns()
  Widget _dropDownUrban({
    Widget? underline,
    Widget? icon,
    TextStyle? style,
    TextStyle? hintStyle,
    Color? dropdownColor,
    Color? iconEnabledColor,
  }) {
    List<String> urbanTowns =
        selectedState != null ? getUrbanTowns(selectedState!) : [];

    return DropdownButton<String>(
      value: selectedUrban,
      underline: underline,
      icon: icon,
      dropdownColor: dropdownColor,
      style: style,
      iconEnabledColor: iconEnabledColor,
      onChanged: (String? newAUUrban) async {
        setState(() {
          selectedUrban = newAUUrban;
        });
        await SharedPreferencesUtils.saveSelectedUrban(newAUUrban!);
      },
      hint: Text("Select a city", style: hintStyle),
      items: urbanTowns
          .map((city) =>
              DropdownMenuItem<String>(value: city, child: Text(city)))
          .toList(),
    );
  }
}

class HelpAndFeedbackPage extends StatelessWidget {
  const HelpAndFeedbackPage({super.key});
  _launchURLout(String aLink) async {
    Uri uri = Uri.parse(aLink);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // can't launch url
      throw Exception('Could not launch $uri');
    }
  }

  // Unused for now

  /*
  _launchURLin(String aLink, ) async {
    Uri uri = Uri.parse(aLink);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } else {
      // can't launch url
      throw Exception('Could not launch $uri');
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 56, 100),
      appBar: const DefaultAppBar(title: 'Help & Feedback'),
      body: Center(
          child: ListView(
        children: [
          CustomListTile(
            title: "Contact me",
            icon: Icons.help,
            onTap: () {
              _launchURLout('https://mail.google.com/?fs=1&tf=cm&source=mailto&to=rungritza2580@gmail.com');
            },
          ),
          CustomListTile(
            title: "Feedback",
            icon: Icons.feedback,
            onTap: () {
              _launchURLout("https://github.com/Google-LLMN/airvibe/issues");
            },
          )
        ],
      )),
    );
  }
}
