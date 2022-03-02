// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:main/models/answer.dart';

class QuestionAnswerPage extends StatefulWidget {
  const QuestionAnswerPage({Key? key}) : super(key: key);

  @override
  _QuestionAnswerPageState createState() => _QuestionAnswerPageState();
}

class _QuestionAnswerPageState extends State<QuestionAnswerPage> {
//Text editing controller for question text filed
  TextEditingController questionfieldcontroller = TextEditingController();

  //To store current answer
  Answer? currentanswer;

  //Scaffold key
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

//handle the process of yes/no answer
  _handlegetanswer() async {
    String question = questionfieldcontroller.text.trim();
    print(question);
    if (question == null ||
        question.length == 0 ||
        question[question.length - 1] != '?') {
      scaffoldkey.currentState!.showSnackBar(const SnackBar(
        content: Text("please ask a valid question"),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    try {
      var url = Uri.parse("https://yesno.wtf/api");
      http.Response response = await http.get(url);
      print(response.body);
      print(response.statusCode);
      print(response.body.runtimeType);
      if (response.statusCode == 200 && response.body != null) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        Answer answer = Answer.fromMap(responseBody);
        setState(() {
          currentanswer = answer;
        });
      }
    } catch (err, stacktrace) {
      print(err);
      print(stacktrace);
    }
  }

  //handle reset
  handlereset() {
    questionfieldcontroller.text = "";
    setState(() {
      currentanswer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: const Text('Question-Answer-Page'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              width: 0.5 * MediaQuery.of(context).size.width,
              child: TextField(
                controller: questionfieldcontroller,
                decoration: InputDecoration(labelText: 'Ask a Question'),
              )),
          const SizedBox(
            height: 20,
          ),
          if (currentanswer != null) ...[
            Stack(
              children: [
                Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          image: NetworkImage(currentanswer!.image),
                          fit: BoxFit.cover)),
                ),
                Positioned.fill(
                    bottom: 20,
                    right: 20,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        currentanswer!.answer.toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ))
              ],
            ),
          ],
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: _handlegetanswer,
                child: const Text(
                  "Get Answer",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              RaisedButton(
                onPressed: handlereset,
                child: const Text(
                  "Reset",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
