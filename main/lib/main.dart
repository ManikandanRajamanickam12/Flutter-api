import 'package:flutter/material.dart';
import 'package:main/pages/Quesion_answer.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter-Demo',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const QuestionAnswerPage(),
    );
  }
}
