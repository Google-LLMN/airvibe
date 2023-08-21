import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'dart:async';

// This function fetchData from the website.
// It needed the url or the website and the class name of that data you want to take
// Also now needed a variable that you want to update.
// Changed to make it more generic and reusable.
Future<void> fetchData(
    String url,
    String urlClassName,
    Function(String) updateVariable,
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
