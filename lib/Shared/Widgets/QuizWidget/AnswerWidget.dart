import 'package:flutter/material.dart';

class AnswerWidget extends StatelessWidget 
{
  final String text;
  final void Function() onClicked;

  AnswerWidget(this.text, this.onClicked);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        textColor: Colors.white,
        color: Colors.blue,
        child: Text(text, 
          style: TextStyle(fontSize: 16),
        ),
        onPressed: onClicked
      ),
    );
  }
}