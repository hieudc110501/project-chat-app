import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/repositories/common_firebase_storage_repository.dart';
import 'package:flutter_chat_app/common/utils/utils.dart';
import 'package:flutter_chat_app/features/auth/screens/login_screen.dart';
import 'package:flutter_chat_app/features/auth/screens/otp_screen.dart';
import 'package:flutter_chat_app/features/auth/screens/user_infomation_screen.dart';
import 'package:flutter_chat_app/features/landing/screens/landing_screen.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/screens/mobile_layout_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  //get current user
  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();

    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  //login with phone number
  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          throw Exception(e.message);
        },
        codeSent: ((String verificationId, int? resendToken) async {
          Navigator.pushNamed(
            context,
            OTPScreen.routeName,
            arguments: verificationId,
          );
        }),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  //log out
  void logout(BuildContext context) async {
    await auth.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);
  }

  //comparison OTP
  void verifiOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await auth.signInWithCredential(credential);
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(
        context,
        UserInfomationScreen.routeName,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  //save user's information to firebase
  void saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

      //if user chosen image, save image to firebase storage
      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(
              'profilePic/$uid',
              profilePic,
            );
      }

      //get token
      String? tokenUser;
      await FirebaseMessaging.instance.getToken().then((token) => tokenUser = token);

      var user = UserModel(
        name: name,
        uid: uid,
        profilePic: photoUrl,
        isOnline: true,
        phoneNumber: auth.currentUser!.phoneNumber!,
        token: tokenUser!,
        groupId: [],
      );

      //save user
      await firestore.collection('users').doc(uid).set(user.toMap());

      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MobileLayoutScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  //get user by id
  Stream<UserModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  //change user status
  void setUserState(bool isOnline) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update(
      {
        'isOnline': isOnline,
      },
    );
  }

  //search user
  Stream<List<UserModel>> searchUser(String name) {
    return firestore
        .collection('users')
        .snapshots()
        .asyncMap(
      (event) {
        List<UserModel> users = [];
        for (var data in event.docs) {
          var user = UserModel.fromMap(data.data());
          if (user.name.toLowerCase().contains(name.toLowerCase())) {
             users.add(user);
          }
        }
        return users;
      },
    );
  }
}
