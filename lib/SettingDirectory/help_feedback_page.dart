/// Help and feedback setting page.

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Data/airvibe_methods.dart';

class HelpAndFeedbackPage extends StatelessWidget {
  const HelpAndFeedbackPage({super.key});

  /// This function will redirect user to the selected website.
  /// Use with onTap().
  _launchURLout(String aLink) async {
    Uri uri = Uri.parse(aLink);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // can't launch url
      throw Exception('Could not launch $uri');
    }
  }

  // Unused for now

  /*
  _launchURLin(String aLink, ) async {
    Uri uri = Uri.parse(aLink);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } else {
      // can't launch url
      throw Exception('Could not launch $uri');
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 56, 100),
      appBar: const DefaultAppBar(title: 'Help & Feedback'),
      body: Center(
          child: ListView(
            children: [
              CustomListTile(
                title: "Contact me",
                icon: Icons.help,
                onTap: () {
                  _launchURLout(
                      'https://mail.google.com/?fs=1&tf=cm&source=mailto&to=rungritza2580@gmail.com');
                },
              ),
              CustomListTile(
                title: "Feedback",
                icon: Icons.feedback,
                onTap: () {
                  _launchURLout("https://github.com/Google-LLMN/airvibe/issues");
                },
              )
            ],
          )),
    );
  }
}