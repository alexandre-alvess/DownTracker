import 'package:AppDown/Providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> 
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('USUÁRIO'),
      ),
      body: FutureBuilder(
        future: Provider.of<UserProvider>(context, listen: false).loadUserFirebase(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting)
          {
            return Center(child: CircularProgressIndicator());
          }

          return Center(
            child: Container(
              child: Text(
                Provider.of<UserProvider>(context, listen: false).itemName,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              )
            ),
          );
        }
      )
    );
  }
}