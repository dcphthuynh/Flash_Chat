import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ChatBloc() : super(ChatInitial()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onLoadMessages(
      LoadMessagesEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final snapshot = await _firestore
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .get();
      final messages = snapshot.docs.map((doc) => doc.data()).toList();
      emit(ChatLoaded(messages));
    } catch (e) {
      emit(ChatError('Failed to load messages: $e'));
    }
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    try {
      final user = _auth.currentUser;
      await _firestore.collection('messages').add({
        'sender': user?.displayName ?? user?.email,
        'text': event.message,
        'timestamp': FieldValue.serverTimestamp(),
      });
      add(LoadMessagesEvent()); // Reload messages after sending
    } catch (e) {
      emit(ChatError('Failed to send message: $e'));
    }
  }
}
