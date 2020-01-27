import 'package:flutter/material.dart';
import 'package:kb_notificator/appBar/AppBarType.dart';

class CustomAppBar{
  static getAppbar(
    BuildContext context, 
    AppBarType type,
    [
      bool settingsBtn,
      String title,
    ]
  ){
    return PreferredSize(
      preferredSize: Size.fromHeight(62.0),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0)
        ),
        child: AppBar(
          leading: Image(
            image: AssetImage("assets/appBar-logo.png"),
          ),
          actions: <Widget>[
            IconButton(
              icon: Image(
                image: AssetImage("assets/ico-settings.png"),
              ),
              onPressed: (){
                Navigator.pushNamed(context, "/settings/");
              },
            )
          ],
          backgroundColor: (type == AppBarType.white) ? Color(0XFFFFFFFF) : Colors.transparent,
          elevation: 0.0,
        ),
      ),
    );
  }
}