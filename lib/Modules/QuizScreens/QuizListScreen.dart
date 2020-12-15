import 'package:AppDown/Modules/QuizScreens/QuizDetailScreen.dart';
import 'package:AppDown/Providers/AnswerProvider.dart';
import 'package:AppDown/Shared/Services/NavigatorService.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class QuizListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RESPOSTAS...'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Provider.of<AnswerProvider>(context, listen: false).loadAnswers(),        
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
        ? Center(child: CircularProgressIndicator())
        : Consumer<AnswerProvider> (
          child: Center(
            child: Text('Não foi encontrado nenhum questionário respondido!'),
          ),
          builder: (ctx, answers, ch) => answers.count == 0
          ? ch
          : ListView.builder(
            itemCount: answers.count,
            itemBuilder: (ctx, i) => ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blueGrey,
                child: Text(
                  'R',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ),
              title: Text(answers.itemByIndex(i).monitored),
              subtitle: Text(answers.itemByIndex(i).question),
              onTap: () {
                GetIt.I<NavigatorService>().navigatorKey.currentState.push(
                  MaterialPageRoute(builder: (ctx) => QuizDetailScreen(answers.itemByIndex(i)))
                );
              },
            ),
          )
        )
      ),
    );
  }
}