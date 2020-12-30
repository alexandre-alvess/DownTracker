import 'package:DownTracker/Modules/HomeScreen.dart';
import 'package:DownTracker/Modules/LoginScreen.dart';
import 'package:DownTracker/Providers/AuthProvider.dart';
import 'package:DownTracker/Shared/Services/NavigatorService.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget 
{

  void _showError(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: AlertDialog(
        title: Row(
          children: <Widget>[
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 12.0),
            Text('Erro'),
          ],
        ),
        content: Column(
          children: <Widget>[
            Text('Ocorreu um erro inesperado:'),
            Text(snapshot.error),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK', style: TextStyle(color: Colors.blue)),
            onPressed: () => GetIt.I<NavigatorService>().pop(),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    
    AuthProvider auth = Provider.of<AuthProvider>(context);
    
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
        {
          return Center(child: CircularProgressIndicator());
        }
        else if (snapshot.hasError)
        {
          _showError(ctx, snapshot);
          return null;
        }
        else
        {
          return auth.isAuth ? HomeScreen() : LoginScreen();
        }
      },
    );
  }
}