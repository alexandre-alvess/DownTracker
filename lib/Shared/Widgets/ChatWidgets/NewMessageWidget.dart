import 'package:AppDown/Providers/AuthProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewMessageWidget extends StatefulWidget {
  @override
  _NewMessageWidgetState createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget>
{
  final _controllerEnteredMessage = TextEditingController();
  String _enteredMessage = '';

  void _sendMessage() 
  {
    FocusScope.of(context).unfocus();

    final userId = Provider.of<AuthProvider>(context, listen: false).userId;

    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': userId
    });

    _controllerEnteredMessage.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget> [
          Expanded(
            child: TextField(
              controller: _controllerEnteredMessage,
              decoration: InputDecoration(
                labelText: 'Enviar mensagem...'
            ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _enteredMessage.trim().isEmpty 
            ? null
            : _sendMessage,
          )
        ],
      ),
    );
  }
}