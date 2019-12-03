import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kb_notificator/notofications/notification.dart';
import 'package:kb_notificator/notofications/notifications.dart';

class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage>{
  final FirebaseMessaging _fcm = FirebaseMessaging();

  final List<Message> messages = [];

  String _fcmToken;

  @override
  void initState() {
    super.initState();

    _fcm.getToken().then((String token){
      _fcmToken = token;

      print(_fcmToken);

      Notifications();
    });

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        final notification = message["data"];
        setState(() {
          messages.add(Message(
            title: notification["title"],
            body: notification["body"]
          ));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        final notification = message["data"];
        setState(() {
          messages.add(Message(
            title: notification["title"],
            body: notification["body"]
          ));
        });

        Navigator.pushNamed(context, "/listDetail/${notification["title"]}/${notification["body"]}");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");

        final notification = message["data"];
        setState(() {
          messages.add(Message(
            title: notification["title"],
            body: notification["body"]
          ));
        });

        Navigator.pushNamed(context, "/listDetail/${notification["title"]}/${notification["body"]}");
      },
    );

    // Запрос разрешения для IOS
    _fcm.requestNotificationPermissions(
      const IosNotificationSettings(
        alert: true,
        badge: true,
        sound: true,
      )
    );
  }

  @override 
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(
        title: Text("К&Б - оповещение водителей"),
      ),
      body: ListView(
        children: messages.map(_getNotificationListItem).toList(),
      )
    );
  }

  ListTile _getNotificationListItem(Message message){
    return ListTile(
      title: Text(message.title),
      subtitle: Text(
        message.body,
        softWrap: true,
        // overflow: TextOverflow.ellipsis,
      ),
      onTap: (){
        print(message.title);
        print(message.body);
        print("/${message.title}/${message.body}");

        Navigator.pushNamed(context, "/listDetail/${message.title}/${message.body}");
      },
    );
  }
}