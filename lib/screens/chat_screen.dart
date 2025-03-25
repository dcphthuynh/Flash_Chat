import 'package:flast_chat/blocs/auth/auth_state.dart';
import 'package:flutter/material.dart';
import '/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/components/message_bubble.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/chat/chat_bloc.dart';
import '../blocs/chat/chat_event.dart';
import '../blocs/chat/chat_state.dart';

class ChatScreen extends StatelessWidget {
  static const String id = 'chat_screen';

  final messageTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Trigger loading messages when the screen builds
    context.read<ChatBloc>().add(LoadMessagesEvent());

    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              context.read<AuthBloc>().add(SignOutEvent());
              Navigator.pop(context);
            },
          ),
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
            BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return Flexible(
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.black,
                        color: Colors.grey,
                      ),
                    ),
                  );
                } else if (state is ChatLoaded) {
                  final messages = state.messages.reversed.toList();
                  return Expanded(
                    child: Container(
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      child: ListView(
                        reverse: true,
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        children: messages.map((message) {
                          final currentUser = context.read<AuthBloc>().state
                                  is AuthSuccess
                              ? (context.read<AuthBloc>().state as AuthSuccess)
                                  .user
                                  .email
                              : '';
                          return MessageBubble(
                            messageSender: message['sender'],
                            messageText: message['text'],
                            isMe: currentUser == message['sender'],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                } else if (state is ChatError) {
                  return Center(child: Text(state.error));
                }
                return Container();
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      style: TextStyle(color: Colors.black),
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextButton(
                      onPressed: () {
                        if (messageTextController.text.isNotEmpty) {
                          context.read<ChatBloc>().add(
                              SendMessageEvent(messageTextController.text));
                          messageTextController.clear();
                        }
                      },
                      child: Text('Send', style: kSendButtonTextStyle),
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
