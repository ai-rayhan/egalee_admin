import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  final List<Map<String, String>> questions;

  const QuizScreen({Key? key, required this.questions}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Map<int, String> selectedAnswers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: ListView.builder(
        itemCount: widget.questions.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question ${index + 1}: ${widget.questions[index]['question']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildOptions(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _checkAnswers();
        },
        child: Icon(Icons.check),
      ),
    );
  }

  List<Widget> _buildOptions(int index) {
    List<String> options =
        widget.questions[index]['options']!.split(',').map((e) => e.trim()).toList();

    return options.map((option) {
      return ListTile(
        title: Text(option),
        leading: Radio<String>(
          value: option,
          groupValue: selectedAnswers[index],
          onChanged: (value) {
            setState(() {
              selectedAnswers[index] = value!;
            });
          },
        ),
      );
    }).toList();
  }

  void _checkAnswers() {
    int correctAnswersCount = 0;
    for (int i = 0; i < widget.questions.length; i++) {
      String correctAnswer = widget.questions[i]['correctAnswer']!;
      String? userAnswer = selectedAnswers[i];

      if (correctAnswer == userAnswer) {
        correctAnswersCount++;
      }
    }

    // Display the result in a dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quiz Result'),
          content: Text(
            'You got $correctAnswersCount out of ${widget.questions.length} questions correct!',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }


}
