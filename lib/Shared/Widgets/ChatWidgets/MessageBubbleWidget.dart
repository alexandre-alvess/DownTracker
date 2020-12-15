import 'package:AppDown/Providers/UserProvider.dart';
import 'package:AppDown/Shared/Models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageBubbleWidget extends StatelessWidget 
{
  
  final Key key;
  final String message;
  final bool belongsToMe;

  MessageBubbleWidget(this.message, this.belongsToMe, {this.key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:  Provider.of<UserProvider>(context, listen: false).loadUserFirebase(),
      builder: (ctx, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting)
        {
          return Center(child: CircularProgressIndicator());
        }

        return Row(
          mainAxisAlignment: belongsToMe 
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,

          children: [
            Container(
              decoration: BoxDecoration(
                color: belongsToMe 
                      ? Colors.grey[300]
                      : Colors.indigoAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: belongsToMe
                              ? Radius.circular(12)
                              : Radius.circular(0),
                  bottomRight: belongsToMe
                              ? Radius.circular(0)
                              : Radius.circular(12)
                )
              ),
              width: 140,
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16
              ),
              margin: EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 8
              ),
              child: Column(
                crossAxisAlignment: belongsToMe
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                  children: [
                    Text(
                      Provider.of<UserProvider>(context, listen: false).tipoUser == TipoUser.Monitor 
                      ? belongsToMe ? '' : 'Monitorado'
                      : belongsToMe ? '' : 'Monitor',
                      style: TextStyle(
                        color: belongsToMe
                              ? Colors.black
                              : Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ), 
                    Text(
                      message,
                      style: TextStyle(
                        color: belongsToMe
                              ? Colors.black
                              : Colors.white
                      ),
                      textAlign: belongsToMe
                                ? TextAlign.end
                                : TextAlign.start,
                    ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}