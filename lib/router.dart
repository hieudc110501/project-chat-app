import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/widgets/error.dart';
import 'package:flutter_chat_app/features/auth/screens/login_screen.dart';
import 'package:flutter_chat_app/features/auth/screens/otp_screen.dart';
import 'package:flutter_chat_app/features/auth/screens/user_infomation_screen.dart';
import 'package:flutter_chat_app/features/group/screens/create_group_screen.dart';
import 'package:flutter_chat_app/features/select_contacts/screens/select_contact_screen.dart';
import 'package:flutter_chat_app/features/chat/screens/mobile_chat_screen.dart';
import 'package:flutter_chat_app/features/status/screens/confirm_status_screen.dart';
import 'package:flutter_chat_app/features/status/screens/status_screen.dart';
import 'package:flutter_chat_app/models/user_status.dart';
import 'package:flutter_chat_app/screens/search_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationId: verificationId,
        ),
      );
    case UserInfomationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInfomationScreen(),
      );
    case SelectContactScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactScreen(),
      );
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      final token = arguments['token'];
      final isGroupChat = arguments['isGroupChat'];
      final profilePic = arguments['profilePic'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
          token: token,
          isGroupChat: isGroupChat,
          profilePic: profilePic,
        ),
      );
    case ConfirmStatusScreen.routeName:
      final file = settings.arguments as File;
      return MaterialPageRoute(
        builder: (context) => ConfirmStatusScreen(
          file: file,
        ),
      );
    case StatusScreen.routeName:
      final userStatus = settings.arguments as UserStatus;
      return MaterialPageRoute(
        builder: (context) => StatusScreen(
          userStatus: userStatus,
        ),
      );
    case CreateGroupScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const CreateGroupScreen(),
      );
    case SearchScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SearchScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist'),
        ),
      );
  }
}
