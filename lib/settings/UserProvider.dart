import 'package:flutter/material.dart';
import 'package:kb_notificator/user/user.dart';

class UserProvider extends ChangeNotifier{
  User _user;

  UserProvider(){
    _setUser();
  }

  _setUser() async{
    _user = await User.getUser();
  }

  User get user => _user;
  
}