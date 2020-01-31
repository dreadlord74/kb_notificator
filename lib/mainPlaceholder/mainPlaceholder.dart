import 'package:flutter/material.dart';

class MainPlaceholder extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0)
        ),
        color: Color(0XFFFFFFFF)
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/placeholder-img.png"),
            Padding(
              padding: EdgeInsets.only(
                top: 39.0,
              ),
              child: Container(
                width: 220.0,
                child: Text(
                  "Вы ещё не получали уведомлений.",
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF000000), 
                    height: 22 / 18 
                  ),
                ),
              ),
            ),
          ],
        ),
      )
		);
  }
}