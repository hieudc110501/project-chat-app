// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/widgets/loader.dart';
import 'package:flutter_chat_app/features/status/controller/status_controller.dart';
import 'package:flutter_chat_app/models/status_model.dart';
import 'package:flutter_chat_app/models/user_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:story_view/story_view.dart';

class StatusScreen extends ConsumerStatefulWidget {
  static const String routeName = '/status-screen';
  final UserStatus userStatus;
  const StatusScreen({
    Key? key,
    required this.userStatus,
  }) : super(key: key);

  @override
  ConsumerState<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends ConsumerState<StatusScreen> {
  StoryController controller = StoryController();
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Status>>(
      future: ref
          .read(statusControllerProvider)
          .getStatusByUid(context, widget.userStatus.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        for (var status in snapshot.data!) {
          storyItems.add(
            StoryItem.pageImage(
              url: status.photoUrl.first,
              controller: controller,
            ),
          );
        }
        return Stack(
          children: [
            const Positioned(
              height: 50,
              width: 100,
              child: Text('hsadsadsadsa'),
            ),
            StoryView(
              storyItems: storyItems,
              controller: controller,
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
