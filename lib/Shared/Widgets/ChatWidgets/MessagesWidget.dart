import 'package:DownTracker/Providers/AuthProvider.dart';
import 'package:DownTracker/Shared/Widgets/ChatWidgets/MessageBubbleWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessagesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
        .collection('chat')
        .orderBy('createdAt', descending: true)
        .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final chatDocs = chatSnapshot.data.documents;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, i) => MessageBubbleWidget(
            chatDocs[i].get('text'),
            chatDocs[i].get('userId') == Provider.of<AuthProvider>(context, listen: false).userId,
            key: ValueKey(chatDocs[i].documentID),
          )
        );
      }
    );
  }
}