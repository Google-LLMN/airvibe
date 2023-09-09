/// Fist ever survey page
/// You will be able answer some survey questions here

import 'package:flutter/material.dart';
import '../Data/airvibe_methods.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  SurveyPageState createState() => SurveyPageState();
}

class SurveyPageState extends State<SurveyPage> {
  List<GenQuestion> questions = [
    GenQuestion(
      text:
          "What do you think is the primary source of carbon emissions contributing to air pollution in urban areas?",
      options: [
        "Industrial activities",
        "Transportation (vehicles)",
        "Agricultural practices",
        "Residential heating and cooking"
      ],
    ),
    GenQuestion(
      text: "How concerned are you about the impact of carbon emissions on air quality and the environment?",
      options: [
        "Very concerned",
        "Maybe",
        "Neutral",
        "Not very concerned",
        "Not a problem"
      ],
    ),
    GenQuestion(text: "Which of the following actions do you think can have the most significant positive impact on reducing carbon emissions and improving air quality?",
        options: [
          "Transitioning to electric or hybrid vehicles",
          "Investing in renewable energy sources like solar and wind",
          "Implementing stricter emissions regulations for industries",
          "Promoting public transportation and carpooling",
          "Planting more trees and green spaces",
          "Not sure"
        ]
    ),
    GenQuestion(text: "Do you believe that government policies and regulations play a significant role in reducing carbon emissions and improving air quality?",
        options: [
          "Yes, they are crucial",
          "Yes, to some extent",
          "No, they have little impact.",
          "No, they don't make a difference."
        ]
    ),
    GenQuestion(text: 'How often do you use public transportation or carpool to reduce your own carbon footprint?',
        options: [
          'Frequently',
          'Occasionally',
          'Rarely',
          'Never',
          'Inaccessible'
        ]
    ),
    GenQuestion(text: 'Which of the following renewable energy sources do you think should be prioritized to reduce reliance on fossil fuels and lower carbon emissions?',
        options: [
          'Solar power',
          'Wind power',
          'Hydroelectric power',
          'Geothermal energy',
          'None of above'
        ]
    ),
    GenQuestion(text: 'In your opinion, what is the main barriers to widespread adoption of electric vehicles as a means to reduce carbon emissions?',
        options: [
          'High initial cost',
          'Limited charging station',
          'Fear of running out of battery',
          'Lack of government incentives'
        ]
    )

    // TODO: Add more questions
  ];

  Map<int, String?> answers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Page', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 32, 56, 100),
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          return QuestionWidget(
            question: question,
            selectedAnswer: answers[index],
            onAnswerSelected: (answer) {
              setState(() {
                answers[index] = answer;
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          if (answers.isEmpty) {
            showFloatingSnackBar(context, 'Please answer a question before a submission.', 1);
          } else {
            showFloatingSnackBar(context, 'Thank you for your responds', 1);
            print(answers);
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
