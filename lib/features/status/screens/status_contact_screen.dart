import 'package:flutter/material.dart';
import 'package:flutter_chat_app/colors.dart';
import 'package:flutter_chat_app/common/widgets/loader.dart';
import 'package:flutter_chat_app/features/status/controller/status_controller.dart';
import 'package:flutter_chat_app/features/status/screens/status_screen.dart';
import 'package:flutter_chat_app/models/user_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatusContactScreen extends ConsumerWidget {
  const StatusContactScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<UserStatus>>(
      stream: ref.read(statusControllerProvider).getStatusContacts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var userStatus = snapshot.data![index];
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      StatusScreen.routeName,
                      arguments: userStatus,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text(
                        userStatus.name,
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          userStatus.profilePic,
                        ),
                        radius: 30,
                      ),
                    ),
                  ),
                ),
                const Divider(color: dividerColor, indent: 85),
              ],
            );
          },
        );
      },
    );
  }
}
