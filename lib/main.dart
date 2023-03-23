import 'package:flutter/material.dart';
import 'game.dart' as model;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Question(
              question: model.Question(
            title: '11 + 4',
            answers: [
              model.Answer(title: '15', isCorrect: true),
              model.Answer(title: '14', isCorrect: false),
              model.Answer(title: '13', isCorrect: false),
            ],
          )),
        ),
      ),
    );
  }
}

class Question extends StatelessWidget {
  final model.Question question;
  const Question({super.key, required this.question});
  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  question.title,
                  style: const TextStyle(fontSize: 190),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final answer in question.answers)
                  TextButton(
                    onPressed: () {},
                    child: Text(answer.title,
                        style: const TextStyle(
                          fontSize: 120,
                        )),
                  )
              ],
            )
          ],
        ),
      );
}
