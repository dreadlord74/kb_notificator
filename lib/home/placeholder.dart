import 'package:flutter/material.dart';

class ListPlaceholder extends StatelessWidget{
	@override
	Widget build(ctx){
		return Container(
				height: double.infinity,
				padding: EdgeInsets.all(20.0),
				child: Center(
						child: Column(
								crossAxisAlignment: CrossAxisAlignment.center,
								mainAxisAlignment: MainAxisAlignment.center,
								children: <Widget>[
										Icon(
												Icons.mail,
												color: Color(0XFFDBDBDB),
												size: 50.0,
										),
										Container(
												width: 200.0,
												child: Text(
														"Вы ещё не получали уведомлений.",
														softWrap: true,
														textAlign: TextAlign.center,
														style: TextStyle(
																fontSize: 16.0,
																color: Color(0XFF000000),
														),
												),
										)
								],
						),
				)
		);
	}
}