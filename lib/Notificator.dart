import 'package:flutter/material.dart';
import 'package:kb_notificator/CustomTheme.dart';
import 'package:kb_notificator/detailPage/DetailPage.dart';
import 'package:kb_notificator/home/HomePage.dart';

class Notificator extends StatelessWidget{
  @override
  Widget build(ctx){
    return MaterialApp(
      title: "К&Б - оповещение водителей",
      theme: CurstomTheme().getTheme(),
      routes: {
        "/": (ctx) => HomePage(),
      },
      onGenerateRoute: (routeSettings){
        final List<String> _path = routeSettings.name.split("/");

        switch (_path[1]){
          case "listDetail":
            return MaterialPageRoute(
              builder: (BuildContext context) => DetailPage(_path[2], _path[3]),
              settings: routeSettings
            );
        }

        return null;
      },
    );
  }
}