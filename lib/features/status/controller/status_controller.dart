// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/features/auth/controller/auth_controller.dart';
import 'package:flutter_chat_app/models/status_model.dart';
import 'package:flutter_chat_app/models/user_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_chat_app/features/status/repository/status_repositority.dart';

final statusControllerProvider = Provider((ref) {
  final statusRepository = ref.read(statusRepositoryProvider);
  return StatusController(
    statusRepository: statusRepository,
    ref: ref,
  );
});

class StatusController {
  final StatusRepository statusRepository;
  final ProviderRef ref;
  StatusController({
    required this.statusRepository,
    required this.ref,
  });

  void addStatus(File file, BuildContext context) {
    ref.watch(userDataAuthProvider).whenData((value) {
      statusRepository.uploadStatus(
        username: value!.name,
        profilePic: value.profilePic,
        phoneNumber: value.phoneNumber,
        statusImage: file,
        context: context,
      );
    });
  }

  //get status by id
  Future<List<Status>> getStatusByUid(BuildContext context, String uid) async {
    List<Status> statuses = await statusRepository.getStatusByUid(context, uid);
    return statuses;
  }

  //get all users have status in 24 hours
  Stream<List<UserStatus>> getStatusContacts() {
    return statusRepository.getStatusContacts();
  }

}
