import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_chat_app/common/enum/message_enum.dart';
import 'package:flutter_chat_app/common/providers/message_reply_provider.dart';
import 'package:flutter_chat_app/common/widgets/loader.dart';
import 'package:flutter_chat_app/features/chat/controller/chat_controller.dart';
import 'package:flutter_chat_app/models/message.dart';
import 'package:flutter_chat_app/features/chat/widgets/my_message_card.dart';
import 'package:flutter_chat_app/features/chat/widgets/sender_message_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverUserId;
  const ChatList({
    Key? key,
    required this.receiverUserId,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();
  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  //if swipe message set state is not null
  void onMessageSwipe(
    String message,
    bool isMe,
    MessageEnum messageEnum,
  ) {
    ref.read(messageReplyProvider.notifier).update(
          (state) => MessageReply(
            message,
            isMe,
            messageEnum,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream:
          ref.read(chatControllerProvider).chatStream(widget.receiverUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        //always show newest message
        SchedulerBinding.instance.addPostFrameCallback((_) {
          messageController.jumpTo(messageController.position.maxScrollExtent);
        });

        return ListView.builder(
          controller: messageController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final messageData = snapshot.data![index];
            final timeSent = DateFormat.Hm().format(messageData.timeSent);

            // if haven't seen and receiver is current user is set seen
            if (!messageData.isSeen &&
                messageData.recieverId ==
                    FirebaseAuth.instance.currentUser!.uid) {
              ref.read(chatControllerProvider).setChatMessageSeen(
                  context, widget.receiverUserId, messageData.messageId);
            }
            // if sender id == current id is show below
            if (messageData.senderId ==
                FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: messageData.text,
                date: timeSent,
                type: messageData.type,
                repliedText: messageData.repliedMessage,
                username: messageData.repliedTo,
                repliedMessageType: messageData.repliedMessageType,
                onLeftSwipe: () => onMessageSwipe(
                  messageData.text,
                  true,
                  messageData.type,
                ),
                isSeen: messageData.isSeen,
              );
            }
            return SenderMessageCard(
              message: messageData.text,
              date: timeSent,
              type: messageData.type,
              repliedText: messageData.repliedMessage,
              username: messageData.repliedTo,
              repliedMessageType: messageData.repliedMessageType,
              onRightSwipe: () => onMessageSwipe(
                messageData.text,
                false,
                messageData.type,
              ),
            );
          },
        );
      },
    );
  }
}
