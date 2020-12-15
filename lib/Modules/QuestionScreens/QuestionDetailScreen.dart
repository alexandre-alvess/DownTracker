import 'package:AppDown/Modules/QuestionScreens/QuestionFormScreen.dart';
import 'package:AppDown/Shared/Models/QuestionModel.dart';
import 'package:AppDown/Shared/Services/NavigatorService.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class QuestionDetailScreen extends StatefulWidget {

  final QuestionModel model;
  final int numQuestion;

  QuestionDetailScreen(this.numQuestion, this.model);

  @override
  _QuestionDetailScreenState createState() => _QuestionDetailScreenState();
}

class _QuestionDetailScreenState extends State<QuestionDetailScreen> {

  QuestionModel _modelForm;

  _updateModelForm(QuestionModel model)
  {
    setState(() {
      _modelForm = QuestionModel.getModel(model);
    });
  }

  void _updateEditData() async
  {
    final QuestionModel result = await GetIt.I<NavigatorService>().navigatorKey.currentState.push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => QuestionFormScreen(modelInit: _modelForm)
      )
    );

    if (result == null) return;

    _updateModelForm(result);
  }

  @override
  void initState() 
  {
    super.initState();
    _updateModelForm(widget.model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QUESTÃO ${widget.numQuestion.toString()}'),
        centerTitle: true
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 50, 10, 50),
        width: double.maxFinite,
        child: Center(
          child: Card(
            elevation: 5,
            color: Colors.red,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () => _updateEditData(),
              child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Icon(Icons.question_answer,
                          color: Colors.white
                        ),
                        SizedBox(height: 15),
                        Container(
                          child: Text(_modelForm.question,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30
                            ),
                          ),
                        ),
                      ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}