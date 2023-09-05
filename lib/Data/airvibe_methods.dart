// This file will be used to stored all the classes or methods

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'dart:async';
import 'package:flutter/material.dart';

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
    // Replace everything except 0-9
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

// Class to create a separation. Use this before CustomListTile
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