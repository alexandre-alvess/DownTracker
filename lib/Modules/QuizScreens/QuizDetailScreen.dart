import 'package:DownTracker/Modules/QuizScreens/DetailImageAnswerScreen.dart';
import 'package:DownTracker/Shared/Models/AnswerModel.dart';
import 'package:DownTracker/Shared/Services/NavigatorService.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class QuizDetailScreen extends StatelessWidget {

  final AnswerModel model;

  QuizDetailScreen(this.model);

  _buildContainer(Widget child)
  {
    return Container(
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2.0,
          color: Colors.black
        ),
      ),
      child: child,
    );
  }

  _buildText(String label, String data)
  {
    return Text.rich(
      TextSpan(
        text: label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          decoration: TextDecoration.underline
        ),
        children: <TextSpan> [
          TextSpan(
            text: ' ' + data,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 20,
              decoration: TextDecoration.none
            )
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RESPOSTA...'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 22),
              _buildContainer(_buildText('Monitorado:', model.monitored)),
              SizedBox(height: 22),
              _buildContainer(_buildText('Questão:', model.question)),
              SizedBox(height: 22),
              _buildContainer(_buildText('Resposta:', model.answer)),
              SizedBox(height: 22),
              _buildContainer(_buildText('Data da resposta:', DateFormat('dd/MM/yyyy').format(DateTime.parse(model.dataInclusao)))),
              SizedBox(height: 22),
              RaisedButton(
                color: Colors.yellow[800],
                child: Text(
                  'Visualizar Imagem do Monitorado',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
                onPressed: () {
                  GetIt.I<NavigatorService>().navigatorKey.currentState.push(
                    MaterialPageRoute(builder: (ctx) => DetailImageAnswerScreen(model.imageUrl))
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}