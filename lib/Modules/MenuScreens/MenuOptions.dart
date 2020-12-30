import 'package:DownTracker/Modules/MenuScreens/MenuOptionsItem.dart';
import 'package:DownTracker/Providers/AnswerProvider.dart';
import 'package:DownTracker/Providers/AuthProvider.dart';
import 'package:DownTracker/Shared/Services/NavigatorService.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class MenuOptions extends StatelessWidget {

  void _exitApp(BuildContext context) async {
    final willExit = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context){
        return AlertDialog(
          title: Text('Sair do App?'),
          content: Row(
            children: [
              Expanded(child: Text('Deseja realmente sair da aplicação?')),
            ],
          ),
          actions: [
            FlatButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancelar',
                style: TextStyle(
                  color: Colors.blue
                ),
              ),
            ),
            FlatButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Sair', 
                style: TextStyle(
                  color: Colors.red
                ),
              ),
            )
          ],
        );
      }
    );

    if (willExit)
    {
      Provider.of<AuthProvider>(context, listen: false).logout();
      GetIt.I<NavigatorService>().pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: ListView(
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            MenuOptionsItem(
              leading: Icon(
                Icons.add_location,
                color: Colors.blue,
              ),
              title: 'LOCALIZAÇÃO',
              subtitle: 'Serviço de localização',
              onTrap: () => GetIt.I<NavigatorService>().navigateToAnimated('/location')
            ),
            Divider(),
            MenuOptionsItem(
              leading: Icon(
                Icons.adjust,
                color: Colors.red,
              ),
              title: 'CONFIGURAR ZONAS DE RASTREIO',
              subtitle: 'Serviço de configuração de localização',
              onTrap: () => GetIt.I<NavigatorService>().navigateToAnimated('/zoneList')
            ),
            Divider(),
            MenuOptionsItem(
              leading: Icon(
                Icons.question_answer,
                color: Colors.orange[400]
              ),
              title: 'CONFIGURAR PERGUNTAS',
              subtitle: 'Serviço de configuração de perguntas',
              onTrap: () => GetIt.I<NavigatorService>().navigateToAnimated('/questionList')
            ),
            Divider(),
            MenuOptionsItem(
              leading: Icon(
                Icons.confirmation_num,
                color: Colors.greenAccent
              ),
              title: 'QUESTIONÁRIO',
              subtitle: 'Entrar para responder questionário',
              onTrap: () => GetIt.I<NavigatorService>().navigateToAnimated('/quiz'),
            ),
            Divider(),
            MenuOptionsItem(
              leading: Icon(
                Icons.text_snippet,
                color: Colors.pinkAccent,
              ),
              title: 'AVALIAR QUESTIONÁRIO',
              subtitle: 'Visualização de perguntas respondidas',
              onTrap: () => GetIt.I<NavigatorService>().navigateToAnimated('/quizList'),
            ),
            /*Divider(),
            MenuOptionsItem(
              leading: Icon(Icons.fingerprint),
              title: 'Teste 03',
              subtitle: 'Subtítulo teste 03',
              onTrap: ()  {

                print('precionou botao teste 03');

                var list = Provider.of<AnswerProvider>(context, listen: false).loadAnswers();
                print(list.toString());

              },
            ),*/
            Divider(),
            MenuOptionsItem(
              leading: Icon(Icons.exit_to_app),
              title: 'SAIR',
              subtitle: '',
              onTrap: () => this._exitApp(context)
            ),
          ],
        ),
      )
    );
  }
}