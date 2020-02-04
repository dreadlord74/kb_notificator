// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kb_notificator/CustomTheme.dart';
import 'package:kb_notificator/appBar/AppBarType.dart';
import 'package:kb_notificator/appBar/customAppBar.dart';
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
  NotificationMessage _currentMessage;
  String _pageTitle = "Просмотр уведомления";

  _DetailPage(this._msgID);

  Future<NotificationMessage> _setCurMessage()async {
    _currentMessage = await Notifications.getMessageByID(_msgID);
    _pageTitle = _currentMessage.title;

    return _currentMessage;
  }

  @override
  Widget build(ctx){
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
        appBar: CustomAppBar.getAppbar(
          context, 
          AppBarType.white,
          true,
          false,
          _pageTitle
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 22),
          child: FutureBuilder(
            builder: (ctx, snapshot) {
              if (snapshot.connectionState != ConnectionState.done)
                return Container();

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _currentMessage.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Color(0xFF0000000d)
                        ),
                        bottom: BorderSide(
                          color: Color(0xFF0000000d)
                        ),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                              right: 16
                            ),
                            child: Image.asset(
                              "assets/ico-location.png",
                              width: 10,
                              height: 14,
                            ),
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                              right: 16
                            ),
                            child: Text(
                              _currentMessage.body,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                height: 16 / 12
                              ),
                            ),
                          ),
                          flex: 2
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Text(
                              "${_currentMessage.receiveTime.hour}:${_currentMessage.receiveTime.minute}"
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 27,
                  ),
                  _getMessageButtons()
                ],
              );
            },
            future: _setCurMessage(),
          )
        )
      )
      ]
    );
  }

  _getMessageButtons(){
    if (_currentMessage.status == "waiting")
      return 
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
                onPressed: () async {

                  await Notifications.setMessageStatusByID(
                    _msgID,
                    "accept"
                  );

                  setState(() {
                    _setCurMessage();
                  });
                },
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
                onPressed: (){
                  String _comment = "";

                  showDialog(
                    builder: (ctx){
                      return AlertDialog(
                        title: Text("Причина отказа"),
                        content: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextField(
                                autofocus: true,
                                decoration: InputDecoration(
                                  labelText: "Причина отказа",
                                  hintText: "Что-то приуныл..."
                                ),
                                onChanged: (val){

                                  if (val.isNotEmpty)
                                    _comment = val;
                                },
                              ),
                            ),
                          ]
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Отмена"),
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text("Отправить"),
                            onPressed: (){
                              Navigator.of(context).pop();
                              Notifications.setMessageStatusByID(
                                _msgID,
                                "decline",
                                _comment
                              );

                              setState(() {
                                _setCurMessage();
                              });
                            },
                          )
                        ],
                      );
                    },
                    context: context
                  );
                },
                color: Color(0XFFDBDBDB),
              ),
            ),
          ],
        );

      return Row();
  }
}