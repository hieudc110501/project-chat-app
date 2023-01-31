// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/features/auth/controller/auth_controller.dart';
import 'package:flutter_chat_app/models/chat_contact.dart';
import 'package:flutter_chat_app/models/message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_chat_app/features/chat/repositories/chat_repository.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  // get all chat contacts controller
  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  //get all messages
   Stream<List<Message>> chatStream(String receiverUserId) {
    return chatRepository.getChatStream(receiverUserId);
  }

  //send message controller
  void sendTextMessage(
      BuildContext context, String text, String recieverUserId) {
    ref.watch(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
            context: context,
            text: text,
            recieverUserId: recieverUserId,
            senderUser: value!,
          ),
        );
  }
}
