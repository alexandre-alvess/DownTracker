import 'package:DownTracker/Providers/QuestionProvider.dart';
import 'package:DownTracker/Shared/Models/QuestionModel.dart';
import 'package:DownTracker/Shared/Services/NavigatorService.dart';
import 'package:DownTracker/Shared/Utils/EnumValidates.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class QuestionFormScreen extends StatefulWidget {

  final QuestionModel modelInit;

  QuestionFormScreen({this.modelInit});

  @override
  _QuestionFormScreenState createState() => _QuestionFormScreenState();
}

class _QuestionFormScreenState extends State<QuestionFormScreen> {

  final _questionController = TextEditingController();
  final _titleController = TextEditingController();

  EnumValidates _isValidForm()
  {
    if (_questionController.text.isEmpty || _titleController.text.isEmpty)
      return EnumValidates.Failed;

    return EnumValidates.Ok;
  }

  Future<void> _submitForm(BuildContext context) async
  {
    var validate = _isValidForm();
    if (validate == EnumValidates.Failed)
    {
      String messageError = 'Cadatro inválido ! Preencha todos os campos obrigatórios.';

      showDialog(context: context,
        barrierDismissible: false, /* configurado para fechar o dialog somente quando clicar no botao da box */
        builder: (context) {
          return AlertDialog(
            title: Text(messageError),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  GetIt.I<NavigatorService>().pop();
                },
              )
            ],
          );
        }
      );
      return;
    }

    /* salvando formulario */
    QuestionModel model = new QuestionModel();
    model.question = _questionController.text;
    model.title = _titleController.text;

    if (_isValidModelInit())
      model.id = widget.modelInit.id;

    if (_isValidModelInit())
    {
      await Provider.of<QuestionProvider>(context, listen: false).updateQuestion(model);
      GetIt.I<NavigatorService>().navigatorKey.currentState.pop(model);
    }
    else
    {
      await Provider.of<QuestionProvider>(context, listen: false).addQuestion(model);
      GetIt.I<NavigatorService>().pop();
    }
  }

  bool _isValidModelInit()
  {
    return widget.modelInit != null;
  }

  void _initForm()
  {
    if (_isValidModelInit())
    {
      setState(() {
        _questionController.text = widget.modelInit.question;
        _titleController.text = widget.modelInit.title;
      });
    }
  }

  @override
  void initState()
  {
    super.initState();
    _initForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_isValidModelInit()
        ? Text('Nova Questão')
        : Text('Alterando Questão'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget> [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget> [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Título'
                      ),
                    ),
                    TextField(
                      controller: _questionController,
                      decoration: InputDecoration(
                        labelText: 'Questão'
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          RaisedButton.icon(
            icon: Icon(!_isValidModelInit()
            ? Icons.add
            : Icons.check_circle_outline,
            size: 32
            ),
            label: !_isValidModelInit()
            ? Text('Adicionar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            )
            : Text('Confirmar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            color: Colors.yellow[800],
            elevation: 0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () => _submitForm(context), /* submissao do formulario */
          )
        ],
      ),
    );
  }
}