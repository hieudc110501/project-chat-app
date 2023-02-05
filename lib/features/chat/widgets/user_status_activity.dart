// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_chat_app/common/widgets/loader.dart';
import 'package:flutter_chat_app/features/auth/controller/auth_controller.dart';
import 'package:flutter_chat_app/features/chat/controller/chat_controller.dart';
import 'package:flutter_chat_app/models/group.dart';
import 'package:flutter_chat_app/models/user_model.dart';

class UserStatusActivity extends ConsumerStatefulWidget {
  final String uid;
  final bool isGroup;
  final double size;
  const UserStatusActivity({
    required this.uid,
    required this.isGroup,
    required this.size,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserStatusActivityState();
}

class _UserStatusActivityState extends ConsumerState<UserStatusActivity> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: widget.isGroup
          ? StreamBuilder<GroupContact>(
              stream:
                  ref.watch(chatControllerProvider).getChatGroupById(widget.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }
                final groupData = snapshot.data;
                return Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        groupData!.groupPic,
                      ),
                      radius: 30,
                    ),
                    const SizedBox(),
                  ],
                );
              },
            )
          : StreamBuilder<UserModel>(
              stream: ref.watch(authControllerProvider).userDataById(widget.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }
                final userData = snapshot.data;
                return Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        userData!.profilePic,
                      ),
                      radius: 30,
                    ),
                    userData.isOnline
                        ? Positioned(
                            bottom: 0,
                            left: widget.size - widget.size * 1/3,
                            child: Container(
                              width: 1/3 * widget.size,
                              height: 1/3 * widget.size,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  )),
                            ),
                          )
                        : const SizedBox(),
                  ],
                );
              },
            ),
    );
  }
}
