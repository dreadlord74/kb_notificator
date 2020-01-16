import 'package:flutter/material.dart';
import 'package:kb_notificator/settings/SettingsForm.dart';
import 'package:kb_notificator/user/user.dart';

class Settings extends StatefulWidget{
  @override
  State<Settings> createState(){
    return _Settings();
  }
}

class _Settings extends State<Settings>{
  User curUser;

  @override
  void initState() {
    super.initState();
  }

  Future _setCurUser() async{
    curUser = await User.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Настройки"),
      ),
      body: FutureBuilder(
        builder: (ctx, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting)
            return Placeholder();

          return SettingsForm();
        },
        future: _setCurUser(),
      ),
    );
  }
}