import 'package:DownTracker/Providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> 
{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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

          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    text: 'Usuário',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.red[400]
                    ),
                  )
                ),
                SizedBox(height: 5),
                Text.rich(
                  TextSpan(
                    text: Provider.of<UserProvider>(context, listen: false).itemName,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                      decoration: TextDecoration.none,
                      color: Colors.black
                    )
                  )
                ),
                SizedBox(height: 5),
                Container(
                  height: 2.0,
                  width: double.infinity,
                  color: Colors.red,
                ),
                SizedBox(height: 25),
                Text.rich(
                  TextSpan(
                    text: 'Token',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.red[400]
                    ),
                  )
                ),
                SizedBox(height: 5),
                Text.rich(
                  TextSpan(
                    text: Provider.of<UserProvider>(context, listen: false).itemuserAuthId,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                      decoration: TextDecoration.none,
                      color: Colors.black,
                    )
                  )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton.icon(
                      label: Text('Copy'),
                      icon: Icon(
                        Icons.copy
                      ),
                      onPressed: () {
                        /*ClipboardManager.copyToClipBoard(Provider.of<UserProvider>(context, listen: false).itemuserAuthId)
                          .then((result) {
                            final snackbar = SnackBar(
                                             content: Text('Token copiado'),
                                             action: SnackBarAction(label: 'Undo', onPressed: (){})
                                            );
                            Scaffold.of(context).showSnackBar(snackbar);
                          });*/
                          
                          Clipboard.setData(ClipboardData(text: Provider.of<UserProvider>(context, listen: false).itemuserAuthId))
                          .then((result) {
                            
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text('Token copiado !'),
                                backgroundColor: Theme.of(context).primaryColorDark,
                              )
                            );
                          });
                      },
                    ),
                  ],
                ),
                Container(
                  height: 2.0,
                  width: double.infinity,
                  color: Colors.red,
                ),               
              ],
            ),
          );
        }
      )
    );
  }
}