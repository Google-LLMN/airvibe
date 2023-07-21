import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class AQIRipper extends StatefulWidget {
  const AQIRipper({super.key});

  @override
  _AQIWidgetState createState() => _AQIWidgetState();
}

class _AQIWidgetState extends State<AQIRipper> {
  String _aqi = 'Calculating...';

  @override
  void initState() {
    super.initState();
    fetchData('https://www.iqair.com/australia',
        'aqi-box-green description__header__number iqair-aqi-pill');
  }

  // This function fetchData from the website.
  // It needed the url or the website and the class name of that data you want to take
  Future<void> fetchData(url, urlclassName) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Get the content from iqair.com
      final document = parser.parse(response.body);
      // Find the specific element that contains the AQI number then take it :)
      // Illegal? I think not
      final elements = document.getElementsByClassName(urlclassName);
      if (elements.isNotEmpty) {
        final aqiNumber = elements.first.text.trim();
        setState(() {
          _aqi = aqiNumber;
        });
      } else {
        setState(() {
          _aqi = 'Data not found!';
        });
      }
    } else {
      setState(() {
        _aqi = 'Error calculate data!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'AQI: $_aqi',
          style: const TextStyle(fontSize: 30, color: Colors.white),
        )
      ],
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 56, 100),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
          height: 100,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 46, 92, 154),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                // TODO: Don't forget this!!!
                child: Text('',
                    style: TextStyle(color: Colors.white, fontSize: 10)),
              ),
              AQIRipper()
            ],
          ),
        ),
      ),
    );
  }
}
