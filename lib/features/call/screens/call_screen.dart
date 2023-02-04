import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/call.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String channelId;
  final Call call;
  final bool isGroupChat;
  const CallScreen({
    super.key,
    required this.channelId,
    required this.call,
    required this.isGroupChat,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
