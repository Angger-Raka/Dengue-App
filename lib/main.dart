import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:quiz_dengue/quizBrain.dart';
import 'package:quiz_dengue/request.dart';
import 'package:http/http.dart' as http;

QuizBrain quizBrain = QuizBrain();

void main() => runApp(Quizzler());

class homePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.values[1],
              children: [
                Image.asset(
                  'images/docter_vector.jpg',
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Welcome to Quiz Dengue',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 27, 27, 27),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Try to answer as many questions as you can',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 135, 135, 135),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 24),
                  child: ElevatedButton(
                    child: Text(
                      'Lets Go',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuizPage()),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];
  List<int> mlValues = [];

  void checkAnswer(bool userAnswer) {
    setState(() {
      bool correctAnswer = quizBrain.getQuestionAnswer();
      if (quizBrain.isFinished()) {
        Future<resultML>? _futureResult;
        setState(() {
          _futureResult = createRequest(mlValues.toString());
        });

        FutureBuilder<resultML>(
          future: _futureResult,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return AlertDialog(
                title: Text('Result'),
                content: Text(
                  '${snapshot.data!.prediction}',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 27, 27, 27),
                  ),
                ),
                actions: [
                  FlatButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.pop(context);
                      quizBrain.reset();
                      scoreKeeper = [];     
                      mlValues = [];
                    },
                  )
                ],
              );
              //Text(snapshot.data!.prediction);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
        // Alert(
        //   context: context,
        //   type: AlertType.error,
        //   title: "END OF QUIZ" + mlValues.toString(),
        //   desc:
        //       "You've reach the end of the quinaz. If you wish to play again, press reset button below",
        //   //make button navigate to homPage
        //   buttons: [
        //     DialogButton(
        //       child: Text(
        //         "Reset",
        //         style: TextStyle(color: Colors.white, fontSize: 20),
        //       ),
        //       onPressed: () {
        //         Navigator.pop(context);
        //         quizBrain.reset();
        //         scoreKeeper = [];
        //         mlValues = [];
        //       },
        //       width: 120,
        //     )
        //   ],
        // ).show();
      }
      if (userAnswer == correctAnswer) {
        scoreKeeper.add(Icon(
          Icons.check,
          color: Colors.green,
        ));
      } else {
        scoreKeeper.add(Icon(
          Icons.close,
          color: Color.fromARGB(255, 212, 173, 170),
        ));
      }
      quizBrain.nextQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                //The user picked true.
                mlValues.add(1);
                checkAnswer(true);
                quizBrain.isFinished();
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                //The user picked false.
                mlValues.add(0);
                checkAnswer(false);
                quizBrain.isFinished();
              },
            ),
          ),
        ),
        Row(
          children: [
            Row(children: scoreKeeper),
            Row(
                children: new String.fromCharCodes(mlValues)
                    .split(',')
                    .map((e) => Text(e))
                    .toList()),
          ],
        )
      ],
    );
  }
}
