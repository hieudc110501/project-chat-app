// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class UserStatusActivity extends StatelessWidget {
  final String imageUrl;
  final bool isOnline;
  const UserStatusActivity({
    Key? key,
    required this.imageUrl,
    required this.isOnline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
            imageUrl,
          ),
          radius: 30,
        ),
        isOnline
            ? Positioned(
                bottom: 0,
                left: 40,
                child: Container(
                  width: 15,
                  height: 15,
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
  }
}
