import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'dart:async';

// This function fetchData from the website.
// It needed the url or the website and the class name of that data you want to take
// Also now needed a variable that you want to update.
// Changed to make it more generic and reusable.
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

int anythingToInt(dynamic someVariable) {
  try {
    final number = someVariable.replaceAll(RegExp(r'[^0-9]'), '');
    int variableNumber = int.parse(number);
    return variableNumber;
  } catch (e) {
    return 0;
  }
}

Future<void> fetchDataFromTable(
    String urlDestination,
    String classDestination,
    int rowTable,
    Function(String) updateVariable,
    {Function(String)? onError}) async {
  final response = await http.get(Uri.parse(urlDestination));
  if (response.statusCode == 200) {
    final document = parser.parse(response.body);
    final table = document.querySelector(classDestination);

    if (table != null) {
      final rows = table.querySelectorAll('tr');
      if (rows.length >= 4) {
        final todayRow = rows[rowTable]; // Today's AQI row

        final todayAQIValueElement = todayRow.querySelector('.status-text b');
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

