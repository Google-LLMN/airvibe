/// This file will be used to stored all the common use classes or methods
/// Note that not every class or function will store here (I tried)

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

/// This function fetchData from the website.
/// It needed the url or the website and the class name of that data you want to take
/// Also now needed a variable that you want to update.
Future<void> fetchData(
    String url, String urlClassName, Function(String) updateVariable,
    {Function(String)? onError}) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final document = parser.parse(response.body);
    final elements = document.getElementsByClassName(urlClassName);
    if (elements.isNotEmpty) {
      final value = elements.first.text.trim();
      updateVariable(value);
    } else {
      updateVariable('NA');
    }
  } else {
    updateVariable('...');
    if (onError != null) {
      onError('Error fetching data');
    }
  }
}

/// Convert anything to int
/// Accept any variable
int anythingToInt(dynamic someVariable) {
  try {
    // Replace everything except 0-9
    final number = someVariable.replaceAll(RegExp(r'[^0-9]'), '');
    int variableNumber = int.parse(number);
    return variableNumber;
  } catch (e) {
    return 0;
  }
}

/// This function get information from website's table
/// See export_page.dart for reference
Future<void> fetchDataFromTable(
  String urlDestination,
  String classDestination,
  String classSelection,
  int rowTable,
  Function(String) updateVariable, {
  Function(String)? onError,
  bool useNestedRow = false,
}) async {
  final response = await http.get(Uri.parse(urlDestination));
  if (response.statusCode == 200) {
    final document = parser.parse(response.body);
    final table = document.querySelector(classDestination);

    if (table != null) {
      final rows = table.querySelectorAll('tr');
      if (rows.isNotEmpty) {
        final withinRow = rows[rowTable];

        if (useNestedRow) {
          final pollutantNameElement = withinRow.querySelector('td');
          final tableValueElement = withinRow.querySelector(classSelection);

          if (pollutantNameElement != null && tableValueElement != null) {
            final pollutantName = pollutantNameElement.text.trim();
            final todayAQIValue = tableValueElement.text.trim();

            if (pollutantName.isNotEmpty && todayAQIValue.isNotEmpty) {
              updateVariable(todayAQIValue);
            } else {
              updateVariable('NA');
            }
          } else {
            updateVariable('NA');
          }
        } else {
          final todayAQIValueElement = withinRow.querySelector(classSelection);
          if (todayAQIValueElement != null) {
            final todayAQIValue = todayAQIValueElement.text.trim();
            if (todayAQIValue.isNotEmpty) {
              updateVariable(todayAQIValue);
            } else {
              updateVariable('NA');
            }
          } else {
            updateVariable('NA');
          }
        }
      } else {
        updateVariable('NA');
      }
    } else {
      updateVariable('NA');
    }
  } else {
    if (onError != null) {
      onError("Error: Status Code ${response.statusCode}");
    }
    updateVariable('Error');
  }
}

/// Class to create new ListTile
/// Required title and icon of the tile
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

/// Class to create a separation
/// Use this before CustomListTile to create empty space with text
class SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const SingleSection({
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

/// Class for default AppBar
/// Use mostly in setting.dart and SettingDirectory
/// Will make the AppBar transparent and text white
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

/// Will export whatever list to the app's data file as txt format
/// Future function use await
/// Require String
/// exportTextToFile(dataToExport)
/// The function return [bool, String]
Future<List> exportTextToFile(String textToExport) async {
  final result = await FilePicker.platform.pickFiles(
    dialogTitle: 'exported_text.txt',
  );

  if (result != null) {
    final file = File(result.files.single.path!);

    try {
      // if file successfully exported
      await file.writeAsString(textToExport);
      final List returnValue = [true, file.path.toString()];
      return returnValue;
    } catch (e) {
      // if file is not exported/error exporting
      final List returnValue = [false, e.toString()];
      return returnValue;
    }
  } else {
    final List returnValue = [false, 'Directory not found'];
    return returnValue; // Export failed
  }
}

/// Will export whatever list to the app's data file as csv format
/// Future function use await
/// The list must be list within list i.e.
///dataToExport = [
///                ['Name', 's', 'City'],
///                ['John', 30, 'New York'],
///                ['Alice', 25, 'Los Angeles'],
///                ['Bob', 35, 'Chicago'],
///               ];
/// exportDataToCsv(dataToExport)
/// The function return [bool, String]
Future<List> exportDataToCsv(List<List<dynamic>> data) async {
  final csv = const ListToCsvConverter().convert(data);

  final directory = await getExternalStorageDirectory();
  if (directory != null) {
    final file = File('${directory.path}/exported_data.csv');

    try {
      // if file is successfully exported
      await file.writeAsString(csv);
      final List returnValue = [true, file.path.toString()];
      return returnValue; // Export was successful
    } catch (e) {
      // if file is not exported/error exporting
      final List returnValue = [false, e.toString()];
      return returnValue; // Export failed
    }
  } else {
    // if the directory is null
    final List returnValue = [false, 'Directory not found'];
    return returnValue; // Export failed
  }
}

// Display the FloatingSnackBar on screen depend on how long you set
// showFloatingSnackBar(context, 'foo', 5)
void showFloatingSnackBar(
    BuildContext context, String message, int durationSeconds) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      duration: Duration(seconds: durationSeconds),
    ),
  );
}

/// Function to generate question
/// GenQuestion('Question', ['Choice 1', 'Choice 2', 'Choice 3']);
/// Required QuestionWidget to work
/// See carbon_emission_survey1 for reference.
class GenQuestion {
  final String text;
  final List<String> options;
  final String? correctAns;

  GenQuestion({
    required this.text,
    required this.options,
    this.correctAns,
  });
}

class QuestionWidget extends StatelessWidget {
  final GenQuestion question;
  final String? selectedAnswer;
  final ValueChanged<String?> onAnswerSelected;

  const QuestionWidget({
    required this.question,
    required this.selectedAnswer,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            question.text,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          Column(
            children: question.options.map((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: selectedAnswer,
                onChanged: onAnswerSelected,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}