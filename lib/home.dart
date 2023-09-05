// For the home page. When you clicked the 'Home' at the bottom of the app
// contains everything that you can see when you click home button
// TODO: Finish home page

import 'package:flutter/material.dart';
import 'Data/shared_preferences_data.dart';
import 'Data/airvibe_methods.dart';
import 'setting.dart' show SettingsPage;
import 'dart:async';

class AQIRipper extends StatefulWidget {
  const AQIRipper({super.key});

  @override
  AQIWidgetState createState() => AQIWidgetState();
}

class AQIWidgetState extends State<AQIRipper> {
  // A SnackBar to use with _refreshDataWithDebounce()
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // A waiting timer between each click of the reload button
  bool isButtonDisabled = false;
  void _refreshDataWithDebounce() {
    if (!isButtonDisabled) {
      setState(() {
        isButtonDisabled = true;
      });

      _showSnackBar("Please wait...");
      _refreshData();

      // Time delay between the reloading
      Timer(const Duration(seconds: 4), () {
        setState(() {
          isButtonDisabled = false;
        });
      });
    }
  }

  // I duplicated this and the bottom one
  // This one is used for refresh data
  // Tell me if you come up with a better solution
  Future<void> _refreshData() async {
    setState(() {
      _aqi = '...';
      _message = 'Loading..';
      _weatherScale = 'Loading..';
    });


    await fetchData(
      'http://www.bom.gov.au/vic/forecasts/melbourne.shtml',
      'summary',
      (newValue) {
        setState(() {
          _weatherScale = '•   $newValue';
        });
      },
    );
    String? auTown = await SavedLocation.getSelectedUrban();
    String? auState = await SavedLocation.getSelectedAUState();
    if (auState != null) {
      auState = auState.toLowerCase();
    }

    if (auTown != null) {
      auTown = auTown.toLowerCase();
    } else {
      // Keep an eye on this if there is a bug!
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Please select your location inside the setting page"),
        duration: Duration(seconds: 4),
        backgroundColor: Colors.redAccent,
      ));
    }

    await fetchData(
      'https://www.iqair.com/australia/$auState/$auTown',
      'aqi-value__value',
      (newValue) {
        setState(() {
          _aqi = newValue;
        });
      },
    );
    textFeedback(anythingToInt(_aqi));
    if (!mounted) return;
  }

  String _aqi = '...';
  String _message = 'Loading..';
  String _weatherScale = 'Loading..';

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  // This function check the aqi scale and find out that you should go outside or not
  // Required string number and it changes the _message variable.
  Future<void> textFeedback(int aqiNumber) async {

    if (mounted) {
      try {
        if (aqiNumber < 45) {
          setState(() {
            _message = "•   Enjoy the fresh air today!";
          });
        } else if (aqiNumber >= 45 && aqiNumber < 80) {
          setState(() {
            _message = "•   Consider wearing a mask for added protection.";
          });
        } else if (aqiNumber >= 80 && aqiNumber < 120) {
          setState(() {
            _message = "•   Sensitive individuals, stay indoors if possible.";
          });
        } else if (aqiNumber >= 120 && aqiNumber < 160) {
          setState(() {
            _message = "•   Don't forget your mask when outdoors.";
          });
        } else {
          setState(() {
            _message = "•   It's best to stay indoors today.";
          });
        }
      } catch (e) {
        setState(() {
          _message = "Loading...";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const theAQINumberTextStyle = TextStyle(fontSize: 70, color: Colors.white);
    const theAQITextStyle = TextStyle(fontSize: 10, color: Colors.white);
    const messageTextStyle = TextStyle(fontSize: 18, color: Colors.white);

    return Column(
      children: [
        Row(
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
            Expanded(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: SizedBox(
                      width: 15,
                      height: 15,
                      child: FloatingActionButton(
                        onPressed: _refreshDataWithDebounce,
                        backgroundColor: const Color(0x00000000),
                        elevation: 0,
                        child: const Icon(Icons.refresh,
                            size: 15, color: Colors.white),
                      )),
                )),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        _PM25ScaleBar(percentage: anythingToInt(_aqi)),
      ],
    );
  }
}

// Class for show the bar in colours
class _PM25ScaleBar extends StatefulWidget {
  final int percentage;
  const _PM25ScaleBar({required this.percentage});

  @override
  _PM25ScaleBarState createState() => _PM25ScaleBarState();
}

class _PM25ScaleBarState extends State<_PM25ScaleBar> {
  late double _animatedWidth;

  @override
  void initState() {
    super.initState();
    _animatedWidth = 0;
    animateBar(widget.percentage);
  }

  void animateBar(int targetPercentage) {
    final newWidth = (targetPercentage / 100) * 300;
    setState(() {
      _animatedWidth = newWidth;
    });
  }

  @override
  void didUpdateWidget(_PM25ScaleBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    animateBar(widget.percentage);
  }

  Color _getColorByPercentage(int percentage) {
    if (percentage >= 0 && percentage < 20) {
      return Colors.green;
    } else if (percentage >= 20 && percentage < 30) {
      return Colors.lightGreen;
    } else if (percentage >= 30 && percentage < 40) {
      return Colors.yellow;
    } else if (percentage >= 40 && percentage < 50) {
      return Colors.orangeAccent;
    } else if (percentage >= 50 && percentage < 60) {
      return Colors.deepOrangeAccent;
    } else if (percentage >= 60 && percentage < 70) {
      return Colors.deepOrange;
    } else if (percentage >= 70 && percentage < 80) {
      return Colors.red;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 10,
            width: 300,
            child: Stack(
              children: [
                Container(
                  color:
                      _getColorByPercentage(widget.percentage).withAlpha(100),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 450),
                  width: _animatedWidth,
                  color: _getColorByPercentage(widget.percentage),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 300,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(widget.percentage > 100 ? 'Too High' : 'Acceptable',
                style: const TextStyle(color: Colors.white)),
          ),
        )
      ],
    );
  }
}

class AQIForeCast extends StatefulWidget {
  const AQIForeCast({super.key});

  @override
  State<AQIForeCast> createState() => _AQIForeCastState();
}

class _AQIForeCastState extends State<AQIForeCast>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _selectedColor = const Color.fromARGB(255, 15, 27, 48);
  final _tabs = [
    const Tab(
      icon: Icon(Icons.keyboard_double_arrow_left),
    ),
    const Tab(
      icon: Icon(Icons.keyboard_arrow_left),
    ),
    const Tab(
      icon: Icon(Icons.circle),
    ),
    const Tab(
      icon: Icon(Icons.keyboard_arrow_right),
    ),
    const Tab(
      icon: Icon(Icons.keyboard_double_arrow_right),
    ),
  ];

  @override
  void initState() {
    _tabController =
        TabController(length: _tabs.length, vsync: this, initialIndex: 2);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 56, 100),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: _selectedColor),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white24,
              tabs: _tabs,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.0), // Adjust the radius
              ),
              child: TabBarView(
                controller: _tabController,
                children: const [
                  TwoDaysAgoScreen(),
                  YesterdayScreen(),
                  TodayScreen(),
                  TomorrowScreen(),
                  NextTwoDaysScreen(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AQIReportScreen extends StatefulWidget {
  final String title;
  final String urlSegment;
  final int rowTable;

  const AQIReportScreen({
    Key? key,
    required this.title,
    required this.urlSegment,
    required this.rowTable,
  }) : super(key: key);

  @override
  State<AQIReportScreen> createState() => _AQIReportScreenState();
}

class _AQIReportScreenState extends State<AQIReportScreen> {
  Future<void> _refreshData() async {
    setState(() {
      _aqi = '...';
    });
    String? auTown = await SavedLocation.getSelectedUrban();
    String? auState = await SavedLocation.getSelectedAUState();
    if (auState != null) {
      auState = auState.toLowerCase();
    }

    if (auTown != null) {
      auTown = auTown.toLowerCase();
    } else {
      // Keep an eye on this if there is a bug!
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Please select your location inside the setting page"),
        duration: Duration(seconds: 4),
        backgroundColor: Colors.redAccent,
      ));
    }

    await fetchDataFromTable(
      'https://www.iqair.com/australia/$auState/$auTown',
      '.aqi-forecast__weekly-forecast-table',
      widget.rowTable,
      (newValue) {
        setState(() {
          _aqi = newValue;
        });
      },
    );
  }

  String _aqi = '...';

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      color: const Color.fromARGB(255, 58, 101, 183),
    );
  }
}

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color.fromARGB(255, 58, 101, 183)),
      width: double.infinity,
      height: 150,

    );
  }
}


class TomorrowScreen extends AQIReportScreen {
  const TomorrowScreen({super.key})
      : super(
          title: 'Tomorrow',
          urlSegment: 'australia',
          rowTable: 5,
        );
}

class YesterdayScreen extends AQIReportScreen {
  const YesterdayScreen({super.key})
      : super(
          title: 'Yesterday',
          urlSegment: 'australia',
          rowTable: 3,
        );
}

class TwoDaysAgoScreen extends AQIReportScreen {
  const TwoDaysAgoScreen({super.key})
      : super(
          title: 'Two Days Ago',
          urlSegment: 'australia',
          rowTable: 2,
        );
}

class NextTwoDaysScreen extends AQIReportScreen {
  const NextTwoDaysScreen({super.key})
      : super(
          title: 'Next Two Days',
          urlSegment: 'australia',
          rowTable: 6,
        );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage()));
                },
                icon: const Icon(Icons.settings))
          ],
          title: const Text(
            'Home',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
            height: double.infinity,
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
            color: const Color.fromARGB(
                0, 46, 92, 154), // Set the background color directly
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AQIRipper(),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 330,
                  height: 150,
                  child: AQIForeCast(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
