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
    return true;
  }

  @override
  void initState() {
    super.initState();

    _fcm.getToken().then((String token){
      _fcmToken = token;
    });

    _fcm.configure(
      onBackgroundMessage: myBackgroundMessageHandler,
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        final notification = message["data"];

        await Notifications.addMessage(
          Message(
            title: notification["title"],
            body: notification["body"],
            status: "waiting",
            receiveTime: DateTime.now(),
            sendTime: DateTime.now()
          )
        );

        setState(() {
          _getMessages();
        });
        
      },
      // onLaunch: (Map<String, dynamic> message) async {
      //   print("onLaunch: $message");

      //   final notification = message["data"];
      //   await Notifications.addMessage(
      //     Message(
      //       title: notification["title"],
      //       body: notification["body"],
      //       status: "waiting",
      //       messageID: 1123,
      //       receiveTime: DateTime.now(),
      //       sendTime: DateTime.now()
      //     )
      //   );

      //   setState(() {
      //     _getMessages();
      //   });

      //   Navigator.pushNamed(context, "/listDetail/${messages[messages.length - 1].id}");
      // },
      // onResume: (Map<String, dynamic> message) async {
      //   print("onResume: $message");

      //   final notification = message["data"];
      //   await Notifications.addMessage(
      //     Message(
      //       title: notification["title"],
      //       body: notification["body"],
      //       status: "waiting",
      //       messageID: 1123,
      //       receiveTime: DateTime.now(),
      //       sendTime: DateTime.now()
      //     )
      //   );

      //   setState(() {
      //     _getMessages();
      //   });

      //   Navigator.pushNamed(context, "/listDetail/${messages[messages.length - 1].id}");
      // },
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

  Widget _getListPlaceholder(){
    return Container(
      height: double.infinity,
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.mail,
              color: Color(0XFFDBDBDB),
              size: 50.0,
            ),
            Container(
              width: 200.0,
              child: Text(
                "Вы ещё не получали уведомлений.",
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Color(0XFFDBDBDB),
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  @override 
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(
        title: Text("К&Б - оповещение водителей"),
      ),
      body: FutureBuilder(
        builder: (ctx, snapshot){
          if (snapshot.hasData == null || snapshot.connectionState == ConnectionState.waiting){
            return _getListPlaceholder();
          }

          if (snapshot.connectionState == ConnectionState.done && messages.length == 0){
            return _getListPlaceholder();
          }

          return ListView(
            children: messages.map(_getNotificationListItem).toList(),
          );
        },
        future: _getMessages(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CurstomTheme().getTheme().primaryColor,
        onPressed: (){
          showDialog(
            builder: (ctx){
              return AlertDialog(
                title: Text("Токен для FCM"),
                content: SelectableText(_fcmToken),
              );
            },
            context: context
          );
        },
      ),
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
      onLongPress: (){
        Notifications.removeMessageByID(message.id);

        setState(() {
          _getMessages();
        });
      },
    );
  }

  static Future myBackgroundMessageHandler(Map<String, dynamic> message) async {
    print("onBackground: $message");

    await Notifications.addMessage(
      Message(
        title: message["data"].title,
        body: message["data"].body,
        status: "waiting",
        receiveTime: DateTime.now(),
        sendTime: DateTime.now()
      )
    );
  }
}