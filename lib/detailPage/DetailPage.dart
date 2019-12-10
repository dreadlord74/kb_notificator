// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kb_notificator/CustomTheme.dart';
import 'package:kb_notificator/notofications/notification.dart';
import 'package:kb_notificator/notofications/notifications.dart';

class DetailPage extends StatefulWidget{
  final int _msgID;

  DetailPage(this._msgID);

  @override
  State<DetailPage> createState(){
    return _DetailPage(_msgID);
  }
}

class _DetailPage extends State<DetailPage>{
  int _msgID;
  Message _currentMessage;
  String _pageTitle = "Просмотр уведомления";

  _DetailPage(this._msgID);

  _setCurMessage()async {
    _currentMessage = await Notifications.getMessageByID(_msgID);

    setState(() {
      _pageTitle = _currentMessage.title;
    });

    return true;
  }

  @override
  Widget build(ctx){
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitle),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0XFFFFFFFF)
        ),
        child: FutureBuilder(
          builder: (ctx, snapshot) {
            if (snapshot.hasData == null)
              return Container();

            return Padding(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: SelectableText(
                        _currentMessage.body,
                        style: TextStyle(
                          fontSize: 18.0,
                          height: 1.4
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0XFFDBDBDB),

                        ),
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: _getTextByStatus(_currentMessage.status),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: FlatButton(
                            child: Text(
                              "Принять",
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                            onPressed: (){},
                            color: CurstomTheme().getTheme().primaryColor,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Flexible(
                          flex: 1,
                          child: FlatButton(
                            child: Text(
                              "Отказаться",
                              style: TextStyle(
                                color: Colors.black
                              ),
                            ),
                            onPressed: (){},
                            color: Color(0XFFDBDBDB),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            );
          },
          future: _setCurMessage(),
        )
      )
    );
  }

  Text _getTextByStatus(String messageStatus){
    switch (messageStatus){
      default:
        return Text(
          "Вы ещё не дали ответ на это уведомление.",
          style: TextStyle(
            fontSize: 15
          )
        );
    }
  }
}