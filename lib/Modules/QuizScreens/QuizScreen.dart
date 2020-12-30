import 'dart:io';
import 'dart:math';

import 'package:DownTracker/Providers/AnswerProvider.dart';
import 'package:DownTracker/Providers/QuestionProvider.dart';
import 'package:DownTracker/Providers/UserProvider.dart';
import 'package:DownTracker/Shared/Models/AnswerModel.dart';
import 'package:DownTracker/Shared/Models/QuestionModel.dart';
import 'package:DownTracker/Shared/Services/NavigatorService.dart';
import 'package:DownTracker/Shared/Widgets/QuizWidget/AnswerImageWidget.dart';
import 'package:DownTracker/Shared/Widgets/QuizWidget/QuizWidget.dart';
import 'package:DownTracker/Shared/Widgets/QuizWidget/ResultWidget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget 
{
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> 
{
  var _perguntaSelecionada = 0;
  List<QuestionModel> _perguntas;
  bool _isLoading = true;
  String _urlImage;
  bool _setImage = false;

  bool get temPerguntaSelecionada
  {
    return _perguntas != null && _perguntaSelecionada < _perguntas.length;
  }

  Future<void> _responder(BuildContext context, AnswerModel answerModel) async
  {
    if (temPerguntaSelecionada)
    {
      AnswerModel model = new AnswerModel();
      model.answer = answerModel.answer;
      model.question = answerModel.question;
      model.dataInclusao = DateTime.now().toIso8601String();

      var provider = Provider.of<UserProvider>(context, listen: false);
      await provider.loadUserFirebase();
      var monitoredName = provider.itemName;
      model.monitored = monitoredName;

      model.imageUrl = _urlImage;

      await Provider.of<AnswerProvider>(context, listen: false).addAnswers(model);
      
      setState(() {
        _perguntaSelecionada++;
      });
    }
  }

  Future<void> _handleSubmitImage(File image) async
  {
    if (image != null)
    {
      final ref = FirebaseStorage.instance
                  .ref()
                  .child('image' + (new Random().nextInt(999999)).toString())
                  .child('monitored_images');

      await ref.putFile(image);

      final url = await ref.getDownloadURL();

      setState(() {
        _urlImage = url;
        _setImage = true;
      });
    }
    else
    {
      print('QuizScreen - Erro ao salvar imagem...');
      print('Imagem não selecionada...');
    }
  }

  void _finalizarQuiz()
  {
    GetIt.I<NavigatorService>().navigateToAndRemove('/home');
  }

  Future<void> _initializeDates() async
  {
    final provider = Provider.of<QuestionProvider>(context, listen: false);
    await provider.loadQuestions();
    _perguntas = provider.items;
  }

  @override
  void initState() 
  {
    super.initState();
    _initializeDates().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questões'),
        centerTitle: true,
      ),
      body: _isLoading
      ? Center(child: CircularProgressIndicator())
      : _setImage
        ? Column(
            mainAxisAlignment: temPerguntaSelecionada ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: <Widget>[
              temPerguntaSelecionada
              ? QuizWidget(
                question: _perguntas[_perguntaSelecionada].question,
                responder: _responder
              )
              : Center(
                child: ResultWidget(_perguntas != null, _finalizarQuiz) // finalizacao do quiz
              )
            ],
          )
        : AnswerImageWidget(_handleSubmitImage)
    );
  }
}