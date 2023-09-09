import 'package:flutter/material.dart';
import '../Data/airvibe_methods.dart';
import '../Data/shared_preferences_data.dart';

class ExportConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const ExportConfirmationDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 56, 98, 176),
      title: const Text('Confirmation',style: TextStyle(color: Colors.white)),
      content: const Text('Are you sure you want to export the data?',style: TextStyle(color: Colors.white)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel',style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
          child: const Text('Confirm',style: TextStyle(color: Colors.green)),
        ),
      ],
    );
  }
}

class ExportSimpleDataScreen extends StatelessWidget {
  const ExportSimpleDataScreen({super.key});

  Future<List<List<dynamic>>> _getsData() async {
    String weather = 'NA';
    String aqiTomorrow = 'NA';
    String aqi = 'NA';
    String message = 'NA';
    String dataDat = 'NA';

    String? auTown = await SavedLocation.getSelectedUrban();
    String? auState = await SavedLocation.getSelectedAUState();

    if (auState != null) {
      auState = auState.toLowerCase();
    }

    if (auTown != null) {
      auTown = auTown.toLowerCase();
    } else {
      return [
        ['Weather now', 'Average AQI', 'AQI', 'Respond', 'Information'],
        [weather, aqiTomorrow, aqi, message, dataDat],
      ];
    }

    await fetchDataFromTable(
      'https://www.iqair.com/australia/$auState/$auTown',
      'aqi-overview-detail',
      '.ng-star-inserted c',
      1,
          (newValue) {
        dataDat = newValue;
      },
      useNestedRow: true,
    );

    await fetchDataFromTable(
      'https://www.iqair.com/australia/$auState/$auTown',
      '.aqi-forecast__weekly-forecast-table',
      '.status-text b',
      5,
          (newValue) {
        aqiTomorrow = newValue;
      },
    );

    await fetchData(
      'http://www.bom.gov.au/vic/forecasts/melbourne.shtml',
      'summary',
          (newValue) {
        weather = newValue;
      },
    );

    await fetchData(
      'https://www.iqair.com/australia/$auState/$auTown',
      'aqi-value__value',
          (newValue) {
        aqi = newValue;
      },
    );

    final int aqiNumber = anythingToInt(aqi);

    try {
      if (aqiNumber < 45) {
        message = "Enjoy the fresh air today!";
      } else if (aqiNumber >= 45 && aqiNumber < 80) {
        message = "Consider wearing a mask for added protection.";
      } else if (aqiNumber >= 80 && aqiNumber < 120) {
        message = "Sensitive individuals, stay indoors if possible.";
      } else if (aqiNumber >= 120 && aqiNumber < 160) {
        message = "Don't forget your mask when outdoors.";
      } else {
        message = "It's best to stay indoors today.";
      }
    } catch (e) {
      message = "NA";
    }

    return [
      ['Weather now', 'Average AQI', 'AQI', 'Respond', 'Information'],
      [weather, aqiTomorrow, aqi, message, dataDat],
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const DefaultAppBar(title: 'Export my data'),
        backgroundColor: const Color.fromARGB(255, 32, 56, 100),
        body: ListView(
          children: [
            CustomListTile(
              title: "Export current weather data",
              icon: Icons.cloud,
              onTap: () {
                final currentContext = context;
                showDialog(
                  context: currentContext,
                  builder: (BuildContext context) {
                    return ExportConfirmationDialog(
                      onConfirm: () async {
                        // Export data to CSV
                        final dataToExport = await _getsData();
                        final exportResult = await exportDataToCsv(dataToExport);
                        if (exportResult[0] == true) {
                          // ignore: Don't use 'BuildContext's across async gaps.
                          showFloatingSnackBar(currentContext,
                              'Successfully exported to ${exportResult[1]}', 4);
                        } else if (exportResult[0] == false) {
                          showFloatingSnackBar(currentContext,
                              'Error exporting\n Reason:${exportResult[1]}', 6);
                        } else {
                          showFloatingSnackBar(currentContext, 'Unknown Error', 4);
                        }
                        ;
                      },
                    );
                  },
                );
              },
            ),
            CustomListTile(
              title: "Export my data",
              icon: Icons.account_box,
              onTap: () {

              },
            )
          ],
        )
    );
  }
}