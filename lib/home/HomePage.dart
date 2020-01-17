import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kb_notificator/CustomTheme.dart';
import 'package:kb_notificator/notofications/notification.dart';
import 'package:kb_notificator/notofications/notifications.dart';
import 'package:kb_notificator/user/user.dart';

class HomePage extends StatefulWidget{
	@override
	State<HomePage> createState() {
		return _HomePage();
	}
}

class _HomePage extends State<HomePage>{
	final FirebaseMessaging _fcm = FirebaseMessaging();
	final localNotifications = FlutterLocalNotificationsPlugin();

  User _user;

	List<NotificationMessage> messages = [];

	String _fcmToken;

	Future _getMessages() async{
    _user = await User.getUser();

    if (_user.token != _fcmToken)
      _user.updateToken(_fcmToken);

		messages = await Notifications.getMessages();
	}

	static Future myBackgroundMessageHandler(Map<String, dynamic> message) async {
	 	if (message.containsKey('data')) {
			// Handle data message
			final dynamic data = message['data'];

			await Notifications.addMessage(
				NotificationMessage(
					title: data["title"],
					body: data["body"],
					status: "waiting",
					receiveTime: DateTime.now(),
					sendTime: DateTime.now()
				)
			);
	 	}

		print("background: $message");
 	}

	@override
	void initState() {
		super.initState();

		_fcm.getToken().then((String token){
			_fcmToken = token;
		});

		_fcm.configure(
			onMessage: (Map<String, dynamic> message) async {
				print("onMessage: $message");

				final notification = message["data"];

				await Notifications.addMessage(
					NotificationMessage(
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
			onLaunch: (Map<String, dynamic> message) async {
				print("onLaunch: $message");
			},
			onBackgroundMessage: myBackgroundMessageHandler,
			onResume: (Map<String, dynamic> message) async {
				print("onResume: $message");
			},
		);
	
		// Запрос разрешения для IOS
		// _fcm.requestNotificationPermissions(
		//	 const IosNotificationSettings(
		//		 alert: true,
		//		 badge: true,
		//		 sound: true,
		//	 )
		// );


		final settingsAndroid = AndroidInitializationSettings('app_icon');
		final settingsIOS = IOSInitializationSettings(
			onDidReceiveLocalNotification: (id, title, body, payload) =>
				onSelectNotification(payload));

		localNotifications.initialize(
			InitializationSettings(settingsAndroid, settingsIOS),
			onSelectNotification: onSelectNotification
    );
	}

	Future onSelectNotification(String payload) async {
		setState(() {
		  _getMessages();
		});

    print(payload);
		
		await Navigator.pushNamed(context, "/listDetail/$payload");
	}

  Widget _getPlaceholder(){
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
                  color: Color(0XFF000000),  
                ),
              ),
            )
          ],
        ),
      )
		);
  }

  Widget _getToSettingsBtn(){
    return Container(
      height: double.infinity,
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Для получения оповещений вы должны указать номер своего телефона.",
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
              child: Text("Указать телефон"),
              onPressed: (){
                Navigator.pushNamed(context, "/settings/");
              },
            ),
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
					actions: <Widget>[
						IconButton(
							icon: Icon(Icons.settings),
							onPressed: (){
								Navigator.pushNamed(context, "/settings/");
							},
						)
					],
			),
			body: FutureBuilder(
        builder: (ctx, snapshot){
          if (snapshot.hasData == null || snapshot.connectionState == ConnectionState.waiting){
            return _getPlaceholder();
          }

          if (snapshot.connectionState == ConnectionState.done && _user == null){
            return _getToSettingsBtn();
          }

          if (snapshot.connectionState == ConnectionState.done && messages.length == 0){
            return _getPlaceholder();
          }

          return ListView(
            children: messages.reversed.map(_getNotificationListItem).toList(),
          );
        },
        future: _getMessages(),
			),
			floatingActionButton: FloatingActionButton(
				backgroundColor: CurstomTheme().getTheme().primaryColor,
				onPressed: () async {
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

	Icon _getNotificationIconByStatus(String status){
    print(status);
		switch (status){
      case "accept":
        return Icon(
					Icons.check,
					color: Colors.white,
				);

      break;

      case "decline":
        return Icon(
					Icons.cancel,
					color: Colors.white,
				);
      
      break;

			default:
        return Icon(
					Icons.message,
					color: Colors.white,
				);
		}
	}

	ListTile _getNotificationListItem(NotificationMessage message){
		return ListTile(
			leading: CircleAvatar(
				backgroundColor: CurstomTheme().getTheme().primaryColor,
				child: _getNotificationIconByStatus(message.status),
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
			onLongPress: () async{
				var res = await Notifications.removeMessageByID(message.id);

				if (res == 1)
					setState(() {
						_getMessages();
					});
				
			},
		);
	}
}