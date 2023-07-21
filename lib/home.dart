// For the home page. When you clicked the 'Home' at the bottom of the app
// contains everything that you can see when you click home button
// TODO: Finish home page

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Required to get data from website
import 'package:html/parser.dart' as parser; // Also required

class AQIRipper extends StatefulWidget {
  const AQIRipper({super.key});

  @override
  _AQIWidgetState createState() => _AQIWidgetState();
}

class _AQIWidgetState extends State<AQIRipper> {
  String _aqi = 'Calculating...';
  String _message = 'Loading..';

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
      // Get the content from the website you want
      final document = parser.parse(response.body);
      // Find the specific element that contains the AQI number then take it :)
      final elements = document.getElementsByClassName(urlclassName);
      if (elements.isNotEmpty) {
        final aqiNumber = elements.first.text.trim();
        setState(() {
          _aqi = aqiNumber;
        });
        textFeedback(
            aqiNumber); // Call textFeedback after it got the AQI number
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

  // This function check the aqi scale and find out that you should go outside or not
  // Required string number and it changes the _message variable.
  Future<void> textFeedback(String number) async {
    try {
      int aqi = int.parse(number);
      if (aqi < 35) {
        setState(() {
          _message = "It's a good day to go outside";
        });
      } else if (aqi >= 35 && aqi < 60) {
        setState(() {
          _message = "Recommended to wear a mask";
        });
      } else if (aqi >= 60 && aqi < 100) {
        setState(() {
          _message = "Sensitive people should avoid going outside";
        });
      } else if (aqi >= 100 && aqi < 160) {
        setState(() {
          _message = "Wear a mask if you can";
        });
      } else {
        setState(() {
          _message = "You should avoid going outside today";
        });
      }
    } catch (e) {
      setState(() {
        _message = "Loading...";
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
          'AQI: $_aqi ',
          style: const TextStyle(fontSize: 30, color: Colors.white),
        ),
        Text(
          '$_message',
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
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
              AQIRipper(),
              Align(
                alignment: Alignment.centerLeft,
                // TODO: Don't forget this!!!
                child: Text('',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
