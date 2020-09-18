import 'package:flutter/material.dart';

import 'models/user.dart';

class ProviderUser extends ChangeNotifier {
  User _user;

  User get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}