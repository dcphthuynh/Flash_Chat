import 'package:flutter/material.dart';
import '/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flast_chat/components/message_bubble.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();

  String textMessage;

  void getCurrentUser() async {
    final user = await _auth.currentUser;
    print(user);
    try {
      if (user != null) {
        loggedInUser = user;
        // print(loggedInUser);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getMessagesStreams() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        // print(message.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text(
          'Chat Room',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              // color: Colors.black,
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      style: TextStyle(color: Colors.black),
                      onChanged: (value) {
                        textMessage = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextButton(
                      onPressed: () {
                        messageTextController.clear();
                        _firestore.collection('messages').add({
                          'sender': loggedInUser.displayName != null
                              ? loggedInUser.displayName
                              : loggedInUser.email,
                          'text': textMessage,
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                        getMessagesStreams();
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        // print(snapshot.hasData);
        if (!snapshot.hasData) {
          return Flexible(
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
                color: Colors.grey,
              ),
            ),
          );
        }
        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageData = message.data() as Map;
          // print(messageData);
          var messageText = messageData['text'];
          var messageSender = messageData['sender'];
          // print(messageSender);

          final currentUser = loggedInUser.displayName != null
              ? loggedInUser.displayName
              : loggedInUser.email;

          final messageBubble = MessageBubble(
            messageSender: messageSender,
            messageText: messageText,
            isMe: currentUser == messageSender,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: Container(
            decoration: BoxDecoration(color: Colors.grey[300]),
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              children: messageBubbles,
            ),
          ),
        );
      },
    );
  }
}
