import 'package:DownTracker/Modules/QuestionScreens/QuestionDetailScreen.dart';
import 'package:DownTracker/Providers/QuestionProvider.dart';
import 'package:DownTracker/Shared/Services/NavigatorService.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class QuestionListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questões'),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.add), 
            onPressed: () => GetIt.I<NavigatorService>().navigateToAnimated('/questionForm')
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<QuestionProvider>(context, listen: false).loadQuestions(),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
        ? Center(child: CircularProgressIndicator())
        : Consumer<QuestionProvider> (
          child: Center(child: Text('Nenhuma questão configurada!')),
          builder: (ctx, questions, ch) => questions.count == 0
          ? ch
          : ListView.builder(
            itemCount: questions.count,
            itemBuilder: (ctx, i) => ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.redAccent,
                child: Text(
                  '?',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ),
              title: Text(
                'QUESTÃO ${i+1}',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              onTap: () {
                GetIt.I<NavigatorService>().navigatorKey.currentState.push(
                  MaterialPageRoute(builder: (ctx) => QuestionDetailScreen(i+1, questions.itemByIndex(i)))
                );
              },
            )
          )
        ),
      ),
    );
  }
}