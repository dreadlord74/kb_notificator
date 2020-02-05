
import 'package:flutter/material.dart';
import 'package:kb_notificator/appBar/AppBarType.dart';
import 'package:kb_notificator/appBar/customAppBar.dart';
import 'package:kb_notificator/btns.dart';
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
  void initState() {
    super.initState();

    Notifications.getMessageByID(_msgID).then((msg){
      setState(() {
        _currentMessage = msg;
        _pageTitle = _currentMessage.title;
      });
    });
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
          true,
          _pageTitle
        ),
        body: _currentMessage != null
              ? Container(
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 22),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      child: Text(
                        _currentMessage.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      )
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Color(0x0D000000)
                          ),
                          bottom: BorderSide(
                            color: Color(0x0D000000)
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
                            flex: 0,
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
                                (_currentMessage.receiveTime.day.toString().length == 1
                                  ? "0${_currentMessage.receiveTime.day}"
                                  : _currentMessage.receiveTime.day.toString())
                                +"."+
                                (_currentMessage.receiveTime.month.toString().length == 1
                                  ? "0${_currentMessage.receiveTime.month}"
                                  : _currentMessage.receiveTime.month.toString())
                                +" "+
                                "${_currentMessage.receiveTime.hour}:${_currentMessage.receiveTime.minute}",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFAEAEAE)
                                ),
                                textAlign: TextAlign.right,
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
                ),
              )
            : Container()
        )
      ]
    );
  }

  _getMessageButtons(){
    if (_currentMessage.status == "waiting")
      return 
        Row(
          children: <Widget>[
            BorderedBtn("Принять", () async {
              await Notifications.setMessageStatusByID(
                _msgID,
                "accept"
              );

              setState(() {
                _setCurMessage();
              });
            }),
            SizedBox(
              width: 15,
            ),
            WhiteBtn("Отказаться", (){
              Navigator.pushNamed(context, "/decline/${_currentMessage.id}");
            })
            /*Flexible(
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
            ),*/
          ],
        );

      return Row();
  }
}