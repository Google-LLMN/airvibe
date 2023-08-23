import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'Data/shared_preferences_data.dart';

// Source: https://codelabs.developers.google.com/codelabs/flutter-webview
class WebViewStack extends StatefulWidget {
  const WebViewStack({required this.controller, super.key});

  final WebViewController controller;

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  var loadingPercentage = 0;
  // REMOVE the controller that was here

  @override
  void initState() {
    super.initState();
    // Modify from here...
    widget.controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ),
    );
    // ...to here.
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(
          controller: widget.controller,
        ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100.0,
          ),
      ],
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls({required this.controller, super.key});

  final WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            if (await controller.canGoBack()) {
              await controller.goBack();
            } else {
              messenger.showSnackBar(
                const SnackBar(
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                    content: Text("You can't go back anymore")),
              );
              return;
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: () {
            controller.reload();
          },
        ),
      ],
    );
  }
}

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late WebViewController controller = WebViewController();
  int? currentNewsSource; // Store the current news source

  @override
  void initState() {
    super.initState();
    _loadWebUrl();
  }

  @override
  // This will call _loadWebUrl() when the news source changes
  void didUpdateWidget(NewsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (currentNewsSource != null) {
      _loadWebUrl();
    }
  }
  // Load the news sources based on what the user setting is.
  Future<void> _loadWebUrl() async {
    currentNewsSource = await SavedNewsSource.getSelectedNewsSource();
    String webUrl = '';

    if (currentNewsSource == 1) {
      webUrl = 'https://www.abc.net.au/news/environment';
    } else if (currentNewsSource == 2) {
      webUrl = 'https://www.theguardian.com/au/environment';
    } else if (currentNewsSource == 3) {
      webUrl = 'https://www.sbs.com.au/news/topic/environment';
    } else if (currentNewsSource == 4) {
      webUrl = 'https://www.9news.com.au/environment';
    }

    setState(() {
      controller.loadRequest(Uri.parse(webUrl));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 56, 100),
      appBar: AppBar(
        title: const Text(
          'News',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        elevation: 0,
        centerTitle: true,
        actions: [
          NavigationControls(controller: controller),
        ],
      ),
      body: WebViewStack(controller: controller),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
    );
  }
}