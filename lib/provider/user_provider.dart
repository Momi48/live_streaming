

import 'package:flutter/material.dart';


import 'package:twitch_clone/model/user.dart';


class UserProvider extends ChangeNotifier {
  User user = User(uuid: '', email: '', username: '', createdAt: '');
  
  setUser(User userData) {
    user = userData;
    notifyListeners();
  }
}
  
