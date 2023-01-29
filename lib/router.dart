import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/widgets/error.dart';
import 'package:flutter_chat_app/features/auth/screens/login_screen.dart';
import 'package:flutter_chat_app/features/auth/screens/otp_screen.dart';
import 'package:flutter_chat_app/features/auth/screens/user_infomation_screen.dart';

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
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist'),
        ),
      );
  }
}
