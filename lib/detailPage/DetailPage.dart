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
            if (snapshot.connectionState != ConnectionState.done)
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
                    _getMessageButtons()
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
      case "accept":
        return Text(
          "Вы ответили согласием на это уведомление.",
          style: TextStyle(
            fontSize: 15
          )
        );
      break;

      case "decline":
        return Text(
          "Вы ответили отказом на это уведомление.",
          style: TextStyle(
            fontSize: 15
          )
        );
      break;


      default:
        return Text(
          "Вы ещё не дали ответ на это уведомление.",
          style: TextStyle(
            fontSize: 15
          )
        );
    }
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