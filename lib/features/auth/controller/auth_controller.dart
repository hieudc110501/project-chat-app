import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/features/auth/repository/auth_repository.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//call repository
final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(
    authRepository: authRepository,
    ref: ref,
  );
});

//call controller to always get current user
final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({
    required this.authRepository,
    required this.ref,
  });

  //get current user
  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  //sign in
  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  //comparsion OTP
  void verifyOTP(BuildContext context, String verificationId, String userOTP) {
    authRepository.verifiOTP(
      context: context,
      verificationId: verificationId,
      userOTP: userOTP,
    );
  }

  //save user 
  void saveUserDataToFirebase(
      BuildContext context, String name, File? profilePic) {
    authRepository.saveUserDataToFirebase(
      name: name,
      profilePic: profilePic,
      ref: ref,
      context: context,
    );
  }

  //get user by id
  Stream<UserModel> userDataById(String userId) {
    return authRepository.userData(userId);
  }

  //change user status
  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }
}
