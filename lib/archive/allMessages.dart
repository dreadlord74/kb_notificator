import 'package:flutter/material.dart';
import 'package:kb_notificator/appBar/AppBarType.dart';
import 'package:kb_notificator/appBar/customAppBar.dart';
import 'package:kb_notificator/notofications/notification.dart';
import 'package:kb_notificator/notofications/notifications.dart';

class AllMessages extends StatefulWidget{
  @override
  State<AllMessages> createState() {
    return _AllMessages();
  }
}

class _AllMessages extends State<AllMessages>{

  List<NotificationMessage> _messages = [];

  @override
  void initState() {
    super.initState();

    Notifications.getMessages().then((value){
      setState(() {
        _messages = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        (
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
            ),
          )
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar.getAppbar(context, AppBarType.white, true, true, "Все заявки"),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 22),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0x0D000000),
                    width: 1,
                    style: BorderStyle.solid
                  )
                )
              ),  
              width: double.infinity,
              child: Column(
                children: _getContent(),
              )
            ),
          ),
        )
      ]
    );
  }

  List<Widget> _getContent(){
    List<Widget> _content = [];
    
    _content.add(Container(
      width: double.infinity,
      child: Text(
        "Все заявки",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      )
    ));

    _content.add(SizedBox(
      height: 20,
    ));

    if (_messages.length > 0)
      _content.addAll(_getMessagesList());

    return _content;
  }

  List<Container> _getMessagesList(){
    List<Container> _list = [];

    _messages.forEach((msg){
      if (msg.status != "waiting")
        _list.add(_getMessage(msg));
    });

    return _list;
  }

  Container _getMessage(NotificationMessage msg){
    print(msg.status);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0x0D000000),
            width: 1,
            style: BorderStyle.solid
          )
        )
      ),
      padding: EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 0,
      ),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Image.asset(
                msg.status == "accept"
                  ? "assets/ico-accept.png"
                  : "assets/ico-decline.png",
                width: 9,
                height: 9,
                fit: BoxFit.contain,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                msg.status == "accept"
                  ? "Принято"
                  : "Отказ",
                style: TextStyle(
                  color: msg.status == "accept"
                          ? Color(0xFF4DB169)
                          : Color(0xFFE42313)
                ),
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right: 16
                  ),
                  child: Text(
                    msg.body,
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
                    (msg.receiveTime.day.toString().length == 1
                      ? "0${msg.receiveTime.day}"
                      : msg.receiveTime.day.toString())
                    +"."+
                    (msg.receiveTime.month.toString().length == 1
                      ? "0${msg.receiveTime.month}"
                      : msg.receiveTime.month.toString())
                    +" "+
                    "${msg.receiveTime.hour}:${msg.receiveTime.minute}",
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
          )
        ]
      ),
    );
  }
}