import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiveUserEmail;
  final String receiveUserID;

  const ChatPage(
      {super.key, required this.receiveUserEmail, required this.receiveUserID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiveUserEmail),),
      body: Text('Chat page'),
    );
  }
}
