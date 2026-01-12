import 'dart:async';

import 'package:bootstrap/firestore/user.dart' as firestore;
import 'package:bootstrap/models/user_model.dart';
import 'package:flutter/material.dart';

class UserService {
  ValueNotifier<UserModel?> user = ValueNotifier(null);
  StreamSubscription? _userSubscription;
  Future<void> setUser(String uid) async {
    try {
      _userSubscription = await firestore.getUserById(
        onNewSnapshot: (user) {
          this.user.value = user;
        },
        userId: uid,
      );
    } catch (e) {
      //_log.e(e);
      rethrow;
    }
  }

  void unSetUser() {
    _userSubscription?.cancel();
    user.value = null;
  }
}
