import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/chat/chat_service.dart';
import 'package:socialmedia/components/chat_ui.dart';
import 'package:socialmedia/components/text_field.dart';

class ChatPage extends StatefulWidget {
  final String receiveUserEmail;
  final String receiveUserID;

  const ChatPage(
      {super.key, required this.receiveUserEmail, required this.receiveUserID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    //this is for sending messages
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiveUserID, _messageController.text);

      //clear the text controller
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(widget.receiveUserEmail),
        ),
        body: Column(
          children: [
            //messages
            Expanded(child: _buildMessageList()),

            //user message input
            _buildMessageInput(),

            const SizedBox(
              height: 25,
            )
          ],
        ));
  }

//build message list
  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.receiveUserID, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }

          return ListView(
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        });
  }

//build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //aligning messages on the right if its a sender is the current user else to the left
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            const SizedBox(
              height: 10,
            ),
            ChatUi(message: data['message'])
          ],
        ),
      ),
    );
  }

//build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        //textfield
        children: [
          Expanded(
            child: MyTextField(
                controller: _messageController,
                hintText: 'Enter message',
                obscureText: false),
          ),

          //send button
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_upward,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
