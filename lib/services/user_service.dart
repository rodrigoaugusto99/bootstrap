import 'dart:async';

import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/firestore/user.dart' as firestore;
import 'package:bootstrap/models/user_model.dart';
import 'package:bootstrap/schemas/user_registration_schema.dart';
import 'package:bootstrap/utils/enums.dart';
import 'package:flutter/material.dart';

class UserService {
  ValueNotifier<UserModel?> user = ValueNotifier(null);
  StreamSubscription? _userSubscription;
  final _log = getLogger('UserService');
  Future<void> setUser(String uid) async {
    unSetUser();
    try {
      _userSubscription = await firestore.getAndListenUserById(
        onNewSnapshot: (user) {
          _log.i('new user snapshot');
          this.user.value = user;
        },
        userId: uid,
      );
    } catch (e) {
      //_log.e(e);
      rethrow;
    }
  }

  Future<void> updateUserRegistration(
    UserRegistrationSchema userRegistrationSchema,
  ) async {
    try {
      await firestore.updateUser(
        map: userRegistrationSchema.toMap(),
        userId: user.value!.id,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserSex(SexEnum sex) async {
    try {
      await firestore.updateUser(
        map: {
          'sex': sex.name,
        },
        userId: user.value!.id,
      );
    } catch (e) {
      rethrow;
    }
  }

  void unSetUser() {
    _userSubscription?.cancel();
    user.value = null;
  }
}
