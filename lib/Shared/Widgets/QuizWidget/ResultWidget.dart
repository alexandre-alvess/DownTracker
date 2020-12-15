import 'package:flutter/material.dart';

class ResultWidget extends StatelessWidget 
{
  final bool quizFinalizado;
  final void Function() finalizar;

  ResultWidget(this.quizFinalizado, this.finalizar);

  String _textResult()
  {
    return quizFinalizado 
    ? 'PARABÉNS QUESTIONÁRIO RESPONDIDO COM SUCESSO !'
    : 'NENHUMA QUESTÃO FOI ADICIONADA AO QUESTIONÁRIO !';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Padding(
          padding: EdgeInsets.all(30),
            child: Center(
              child: Text(
                _textResult(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ),
        ),
        FlatButton(
          child: Column(
            children: [
              Icon(Icons.beenhere),
              Text('Continuar',
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
          textColor: Colors.redAccent,
          onPressed: finalizar,
          padding: EdgeInsets.all(20),
        )
      ],
    );
  }
}