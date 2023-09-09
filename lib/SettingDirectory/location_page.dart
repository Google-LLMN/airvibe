import 'package:flutter/material.dart';
import '../Data/airvibe_methods.dart';
import '../Data/shared_preferences_data.dart';
import '../Data/drop_down_menu_list.dart';

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
    String? savedCity = await SavedLocation.getSelectedAUState();
    String? savedUrban = await SavedLocation.getSelectedUrban();

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
        await SavedLocation.saveSelectedAUState(newAUState!);
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
        await SavedLocation.saveSelectedUrban(newAUUrban!);
      },
      hint: Text("Select a city", style: hintStyle),
      items: urbanTowns
          .map((city) =>
          DropdownMenuItem<String>(value: city, child: Text(city)))
          .toList(),
    );
  }
}