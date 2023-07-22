// For the home page. When you clicked the 'Home' at the bottom of the app
// contains everything that you can see when you click home button
// TODO: Finish home page
// TODO: Implement location searching using dropdown menu

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Required to get data from website
import 'package:html/parser.dart' as parser; // Also required

class AQIRipper extends StatefulWidget {
  const AQIRipper({super.key});

  @override
  AQIWidgetState createState() => AQIWidgetState();
}

class AQIWidgetState extends State<AQIRipper> {
  String _aqi = '...';
  String _message = 'Loading..';
  String _weatherScale = 'Loading..'; // TODO Implement proper weather system

  @override
  
  void initState() {
    super.initState();
    fetchData('http://www.bom.gov.au/vic/forecasts/melbourne.shtml',
        'summary',
            (newValue) {
              setState(() {
                _weatherScale = '•   $newValue';
              });
            },);
    fetchData(
      'https://www.iqair.com/australia',
      'aqi-box-green description__header__number iqair-aqi-pill',
      (newValue) {
        setState(() {
          _aqi = newValue;
        });
      },
    );
  }

  // This function fetchData from the website.
  // It needed the url or the website and the class name of that data you want to take
  // Also now needed a variable that you want to update.
  // Changed to make it more generic and reusable.
  Future<void> fetchData(
      String url, String urlClassName, Function(String) updateVariable) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Get the content from the website you want
      final document = parser.parse(response.body);
      // Find the specific element that contains the value then take it :)
      final elements = document.getElementsByClassName(urlClassName);
      if (elements.isNotEmpty) {
        final value = elements.first.text.trim();
        setState(() {
          updateVariable(value);
        });
        textFeedback(value); // Call textFeedback after it got the value
      } else {
        setState(() {
          updateVariable('NA');
        });
      }
    } else {
      setState(() {
        updateVariable(':(');
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
          _message = "•   Nothing to worry";
        });
      } else if (aqi >= 35 && aqi < 60) {
        setState(() {
          _message = "•   Recommended to wear a mask";
        });
      } else if (aqi >= 60 && aqi < 100) {
        setState(() {
          _message = "•   Sensitive people should avoid going outside";
        });
      } else if (aqi >= 100 && aqi < 160) {
        setState(() {
          _message = "•   Wear a mask if you can";
        });
      } else {
        setState(() {
          _message = "•   You should avoid going outside today";
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
    const theAQINumberTextStyle = TextStyle(fontSize: 70, color: Colors.white);
    const theAQITextStyle = TextStyle(fontSize: 10, color: Colors.white);
    const messageTextStyle = TextStyle(fontSize: 18, color: Colors.white);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _aqi,
                style: theAQINumberTextStyle,
                textAlign: TextAlign.center,
              ),
              const Text(
                'AQI',
                style: theAQITextStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            '$_message\n$_weatherScale',
            style: messageTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(fontSize: 30),
          ),
          backgroundColor: const Color.fromARGB(0, 0, 0, 0),
          elevation: 0,

          centerTitle: true,
        ),
        backgroundColor: const Color.fromARGB(0, 32, 56, 100),
        body: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
            height: 100,
            color: const Color.fromARGB(0, 46, 92, 154), // Set the background color directly
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AQIRipper(),
              ],
            ),
          ),
        ),

      ),
    );
  }
}
