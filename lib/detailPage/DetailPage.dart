// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget{
  final String _title;
  final String _text;

  DetailPage(this._title, this._text);

  @override
  Widget build(ctx){
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0XFFFFFFFF)
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Container(
            child: SelectableText(
              _text,
              style: TextStyle(
                fontSize: 18.0,
                height: 1.4
              ),
            ),
          ),
        )
      )
    );
  }
}