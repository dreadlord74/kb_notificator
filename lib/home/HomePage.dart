import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kb_notificator/CustomTheme.dart';
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

  List<Message> messages = [];

  String _fcmToken;

  _getMessages() async{
    messages = await Notifications.getMessages();

    // setState(() {
    //   mess
    // });

    return true;
  }

  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {

    await Notifications.addMessage(
      Message(
        title: "background",
        body: "bgвыполнилось $message",
        status: "waiting",
        messageID: 1123,
        receiveTime: DateTime.now(),
        sendTime: DateTime.now()
      )
    );

   if (message.containsKey('data')) {
     // Handle data message
     final dynamic data = message['data'];

    await Notifications.addMessage(
      Message(
        title: data["title"],
        body: data["body"],
        status: "waiting",
        messageID: 1123,
        receiveTime: DateTime.now(),
        sendTime: DateTime.now()
      )
    );
   }

   if (message.containsKey('notification')) {
     // Handle notification message
     final dynamic notification = message['notification'];
   }

   print("background: $message");

   // Or do other work.
 }

  @override
  void initState() {
    super.initState();

    _fcm.getToken().then((String token){
      _fcmToken = token;

      print(_fcmToken);
    });

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        final notification = message["data"];

        await Notifications.addMessage(
          Message(
            title: notification["title"],
            body: notification["body"],
            status: "waiting",
            messageID: 1123,
            receiveTime: DateTime.now(),
            sendTime: DateTime.now()
          )
        );

        setState(() {
          _getMessages();
        });
        
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        final notification = message["data"];
        await Notifications.addMessage(
          Message(
            title: notification["title"],
            body: notification["body"],
            status: "waiting",
            messageID: 1123,
            receiveTime: DateTime.now(),
            sendTime: DateTime.now()
          )
        );

        setState(() {
          _getMessages();
        });

        Navigator.pushNamed(context, "/listDetail/${notification["title"]}/${notification["body"]}");
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");

        final notification = message["data"];
        await Notifications.addMessage(
          Message(
            title: notification["title"],
            body: notification["body"],
            status: "waiting",
            messageID: 1123,
            receiveTime: DateTime.now(),
            sendTime: DateTime.now()
          )
        );

        setState(() {
          _getMessages();
        });

        Navigator.pushNamed(context, "/listDetail/${notification["title"]}/${notification["body"]}");
      },
    );

    // Запрос разрешения для IOS
    // _fcm.requestNotificationPermissions(
    //   const IosNotificationSettings(
    //     alert: true,
    //     badge: true,
    //     sound: true,
    //   )
    // );
  }

  @override 
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(
        title: Text("К&Б - оповещение водителей"),
      ),
      body: FutureBuilder(
        builder: (ctx, snapshot){
          if (snapshot.hasData == null)
            return ListView();

          return ListView(
            children: messages.map(_getNotificationListItem).toList(),
          );
        },
        future: _getMessages(),
      )
    );
  }

  IconData _getNotificationIconByStatus(String status){
    switch (status){
      default:
        return Icons.message;
    }
  }

  ListTile _getNotificationListItem(Message message){
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: CurstomTheme().getTheme().primaryColor,
        child: Icon(
          _getNotificationIconByStatus(message.status),
          color: Colors.white,
        ),
      ),
      title: Text(message.title),
      subtitle: Text(
        message.body,
        maxLines: 1,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: (){
        Navigator.pushNamed(context, "/listDetail/${message.id}");
      },
    );
  }
}