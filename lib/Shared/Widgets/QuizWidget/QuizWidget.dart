import 'package:AppDown/Shared/Models/AnswerModel.dart';
import 'package:AppDown/Shared/Widgets/QuizWidget/AnswerWidget.dart';
import 'package:AppDown/Shared/Widgets/QuizWidget/QuestionWidget.dart';
import 'package:flutter/material.dart';

class QuizWidget extends StatelessWidget 
{
  final String question;
  final void Function(BuildContext, AnswerModel) responder;

  QuizWidget({
    @required this.question,
    @required this.responder
  });

  AnswerModel _crieModel(String text)
  {
    AnswerModel model = new AnswerModel();
    model.answer = text;
    model.question = this.question;

    return model;
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuestionWidget(question),
        AnswerWidget('ÓTIMO', () => responder(context, _crieModel('ÓTIMO'))), /* RESPOSTA 01 */
        AnswerWidget('BOM', () => responder(context, _crieModel('BOM'))),     /* RESPOSTA 02 */
        AnswerWidget('MAIS OU MENOS', () => responder(context, _crieModel('MAIS OU MENOS'))), /* RESPOSTA 03 */
        AnswerWidget('RUIM', () => responder(context, _crieModel('RUIM'))), /* RESPOSTA 04 */
        AnswerWidget('PÉSSIMO', () => responder(context, _crieModel('PÉSSIMO'))) /* RESPOSTA 05 */
      ],
    );
  }
}