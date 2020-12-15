import 'package:flutter/material.dart';

class QuestionWidget extends StatelessWidget 
{
  final String text;

  QuestionWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 50, 10, 50),
      width: double.maxFinite,
      child: Center(
        child: Card(
          elevation: 5,
          color: Colors.blue[300],
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget> [
                  Icon(Icons.question_answer,
                    color: Colors.white,
                  ),
                  SizedBox(height: 15),
                  Container(
                    child: Text(text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}