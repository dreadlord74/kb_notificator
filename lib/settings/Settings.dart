import 'package:flutter/material.dart';
import 'package:kb_notificator/appBar/AppBarType.dart';
import 'package:kb_notificator/appBar/customAppBar.dart';
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
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFE4DAD9),
                const Color(0xFFE5E4EE),
              ],
              stops: [
                0.0, 1.0
              ],
              tileMode: TileMode.clamp
            ),
            // color: Color(0xFFE4DAD9)
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar.getAppbar(
            context, 
            AppBarType.white,
            true,
            false,
            "Настройки"
          ),
          body: FutureBuilder(
            builder: (ctx, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting)
                return Placeholder();

              return SettingsForm();
            },
            future: _setCurUser(),
          ),
        )
      ],
    );
  }
}