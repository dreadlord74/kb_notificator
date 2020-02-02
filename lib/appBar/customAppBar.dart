import 'package:flutter/material.dart';
import 'package:kb_notificator/appBar/AppBarType.dart';

class CustomAppBar{
  static getAppbar(
    BuildContext context, 
    AppBarType type,
    [
      bool backArrow,
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
          leading: (
            backArrow == true
              ? IconButton(
                  icon: Image.asset(
                    "assets/ico-back-arrow.png",
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : Container(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "assets/appBar-logo.png",
                          width: 26.0,
                          height: 26.0,
                          fit: BoxFit.contain,
                        )
                      ],
                    ),
                  ),
                )
          ),
          title: (title != null
            ? Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black
                ),
              )
            : Container()
          ),
          actions: <Widget>[
            (settingsBtn == true
              ? IconButton(
                icon: Image.asset(
                  "assets/ico-settings.png",
                  fit: BoxFit.contain,
                  width: 16.0,
                  height: 16.0,
                ),
                onPressed: (){
                  Navigator.pushNamed(context, "/settings/");
                },
              )
              : Container()
            )
          ],
          backgroundColor: (type == AppBarType.white) ? Color(0XFFFFFFFF) : Colors.transparent,
          elevation: 0.0,
        ),
      ),
    );
  }
}