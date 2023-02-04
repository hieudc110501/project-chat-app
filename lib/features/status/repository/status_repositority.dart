// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/repositories/common_firebase_storage_repository.dart';
import 'package:flutter_chat_app/common/utils/utils.dart';
import 'package:flutter_chat_app/models/status_model.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/models/user_status.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final statusRepositoryProvider = Provider(
  (ref) => StatusRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;
  StatusRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  //save user in status
  void saveUserToStatus() {}

  //upload status
  void uploadStatus({
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required BuildContext context,
  }) async {
    try {
      var statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;

      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            '/status/$statusId$uid',
            statusImage,
          );

      //get all contacts in device
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      //check contacts in device equals in firebase
      List<String> uidWhoCanSee = [];
      for (int i = 0; i < contacts.length; i++) {
        var userDataFirebase = await firestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''),
            )
            .get();
        //showSnackBar(context: context, content: userDataFirebase.size.toString());
        if (userDataFirebase.docs.isNotEmpty) {
          var userData = UserModel.fromMap(userDataFirebase.docs[0].data());
          uidWhoCanSee.add(userData.uid);
        }
      }

      List<String> statusImageUrls = [];
      statusImageUrls = [imageUrl];
      Status status = Status(
        uid: uid,
        username: username,
        phoneNumber: phoneNumber,
        photoUrl: statusImageUrls,
        createdAt: DateTime.now(),
        profilePic: profilePic,
        statusId: statusId,
        whoCanSee: uidWhoCanSee,
      );

      UserStatus userStatus = UserStatus(
        name: username,
        uid: uid,
        profilePic: profilePic,
        phoneNumber: phoneNumber,
        lastTimeStatus: DateTime.now(),
      );

      //add status to firebase
      await firestore.collection('status').doc(uid).set(userStatus.toMap());

      //add status to firebase
      await firestore
          .collection('status')
          .doc(uid)
          .collection('statuses')
          .doc(statusId)
          .set(status.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  //get all contacts have status in 24 hours
  Stream<List<UserStatus>> getStatusContacts() {
    return firestore
        .collection('status')
        .where(
          'lastTimeStatus',
          isGreaterThan: DateTime.now()
              .subtract(const Duration(hours: 24))
              .millisecondsSinceEpoch,
        )
        .snapshots()
        .asyncMap((event) async {
      List<UserStatus> contacts = [];
      for (var document in event.docs) {
        var userStatus = UserStatus.fromMap(document.data());
        contacts.add(userStatus);
      }
      return contacts;
    });
  }

  //get status by id
  Future<List<Status>> getStatusByUid(
    BuildContext context,
    String uid,
  ) async {
    List<Status> statusData = [];
    try {
      var statusesSnapshot = await firestore
          .collection('status')
          .doc(uid)
          .collection('statuses')
          .where(
            'createdAt',
            isGreaterThan: DateTime.now()
                .subtract(const Duration(hours: 24))
                .millisecondsSinceEpoch,
          )
          .get();

      for (var tempData in statusesSnapshot.docs) {
        Status tempStatus = Status.fromMap(tempData.data());
        statusData.add(tempStatus);
      }
    } catch (e) {
      if (kDebugMode) print(e);
      showSnackBar(context: context, content: e.toString());
    }
    return statusData;
  }
}
