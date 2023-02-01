import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/widgets/error.dart';
import 'package:flutter_chat_app/features/auth/screens/login_screen.dart';
import 'package:flutter_chat_app/features/auth/screens/otp_screen.dart';
import 'package:flutter_chat_app/features/auth/screens/user_infomation_screen.dart';
import 'package:flutter_chat_app/features/select_contacts/screens/select_contact_screen.dart';
import 'package:flutter_chat_app/features/chat/screens/mobile_chat_screen.dart';
import 'package:flutter_chat_app/features/status/screens/confirm_status_screen.dart';
import 'package:flutter_chat_app/features/status/screens/status_screen.dart';
import 'package:flutter_chat_app/models/status_model.dart';

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
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
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
      final status = settings.arguments as Status;    
      return MaterialPageRoute(
        builder: (context) => StatusScreen(
          status: status,
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist'),
        ),
      );
  }
}
