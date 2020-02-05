import 'package:flutter/material.dart';
// import 'package:kb_notificator/CustomTheme.dart';
import 'package:kb_notificator/detailPage/DetailPage.dart';
import 'package:kb_notificator/detailPage/decline.dart';
import 'package:kb_notificator/home/HomePage.dart';
import 'package:kb_notificator/settings/Settings.dart';

class Notificator extends StatelessWidget{
	@override
	Widget build(ctx){
		return MaterialApp(
			title: "К&Б - оповещение водителей",
			// theme: CurstomTheme().getTheme(),
      initialRoute: '/',
			routes: {
        "/": (ctx) => HomePage(),
        "settings": (ctx) => Settings(),
        "decline": (ctx) => Settings(),
			},
			onGenerateRoute: (routeSettings){
				final List<String> _path = routeSettings.name.split("/");

				switch (_path[1]){
					case "listDetail":
            return MaterialPageRoute(
              builder: (BuildContext context) => DetailPage(int.parse(_path[2])),
              settings: routeSettings
            );

					break;

				  case "settings":
            return MaterialPageRoute(
              builder: (BuildContext ctx) => Settings(),
              settings: routeSettings
            );

          break;

          case "decline":
            return MaterialPageRoute(
              builder: (BuildContext context) => Decline(int.parse(_path[2])),
              settings: routeSettings
            );
				}

				return null;
			},
		);
	}
}