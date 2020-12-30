import 'package:DownTracker/Shared/Widgets/ChatWidgets/MessagesWidget.dart';
import 'package:DownTracker/Shared/Widgets/ChatWidgets/NewMessageWidget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> 
{

  @override
  void initState()
  {
    super.initState();

    /* configuracao dos push notifications */
    final fbm = FirebaseMessaging();
    fbm.configure(
      onMessage: (msg) { // quando a aplicacao esta executando
        print('onMessage...');
        print(msg);
        return;
      },
      onResume: (msg) { // quando a aplicacao esta em background
        print('onResume...');
        print(msg);
        return;
      },
      onLaunch: (msg) { // quando a aplicacao esta terminada
        print('onLaunch...');
        print(msg);
        return;
      }
    );
    fbm.subscribeToTopic('chat');
    fbm.requestNotificationPermissions();
  }

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        centerTitle: true,
        title: Text('CHAT'),
      ),
      body: Container(
        child: Column(
          children: <Widget> [
            Expanded(child: MessagesWidget()),
            NewMessageWidget()
          ],
        )
      ),
    );
  }
}