import 'package:flutter/material.dart';
import 'package:flutter_chat_app/colors.dart';
import 'package:flutter_chat_app/common/widgets/loader.dart';
import 'package:flutter_chat_app/features/auth/controller/auth_controller.dart';
import 'package:flutter_chat_app/features/chat/screens/mobile_chat_screen.dart';
import 'package:flutter_chat_app/features/chat/widgets/user_status_activity.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowSearchView extends ConsumerWidget {
  final String name;
  const ShowSearchView({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SingleChildScrollView(
        child: StreamBuilder<List<UserModel>>(
          stream: ref.watch(authControllerProvider).searchUser(name),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var userData = snapshot.data![index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, MobileChatScreen.routeName,
                            arguments: {
                              'name': userData.name,
                              'uid': userData.uid,
                              'isGroupChat': false,
                              'profilePic': userData.profilePic,
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text(
                            userData.name,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          leading: UserStatusActivity(
                            uid: userData.uid,
                            isGroup: false,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
