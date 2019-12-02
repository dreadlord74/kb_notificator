import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage>{
  List<ListTile> _notificationsList = [];
  final FirebaseMessaging _fcm = FirebaseMessaging();

  String _fcmToken;

  final List<String> _dates = [
    "02.12.2019",
    "01.12.2019",
    "30.11.2019",
    "29.11.2019",
    "28.11.2019",
    "27.11.2019",
    "26.11.2019",
    "25.11.2019",
    "24.11.2019",
    "23.11.2019",
    "22.11.2019",
    "21.11.2019",
    "20.11.2019",
    "19.11.2019",
  ];

  @override
  _HomePage() {
    _notificationsList = _getNotificationList();

    _fcm.getToken().then((String token){
      _fcmToken = token;

      print(_fcmToken);
    });

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            // actions: <Widget>[
            // FlatButton(
            //     child: Text('Ok'),
            //     // onPressed: () => Navigator.of(context).pop(),
            // ),
            // ],
          ),
        );
       },
       onLaunch: (Map<String, dynamic> message) async {
         print("onLaunch: $message");
       },
       onResume: (Map<String, dynamic> message) async {
         print("onResume: $message");
       },
    );
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("К&Б - оповещение водителей"),
      ),
      body: ListView.builder(
        itemCount:  _dates.length,
        itemBuilder: (context, index){
          return _notificationsList[index];
        },
      )
    );
  }

  List<ListTile> _getNotificationList(){
    _dates.forEach((String date){
      _notificationsList.add(_getNotificationListByDate(date));
    });

    return _notificationsList;
  }

  ListTile _getNotificationListByDate(String date){
    final _text = "Текст оповещеия за ${date.toString()}. Текст оповещеия за 02.12.2019. Текст оповещеия за ${date.toString()}. Текст оповещеия за ${date.toString()}";

    return ListTile(
      title: Text(date),
      subtitle: Text(
        _text,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: (){
        Navigator.pushNamed(context, "/listDetail/$date/$_text");
      },
    );
  }
}