import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
	final localNotifications = FlutterLocalNotificationsPlugin();

	List<NotificationMessage> messages = [];

	String _fcmToken;

	_getMessages() async{
		messages = await Notifications.getMessages();
		return true;
	}

	static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {

		// await Notifications.addMessage(
		// 	Message(
		// 		title: "background",
		// 		body: "bgвыполнилось $message",
		// 		status: "waiting",
		// 		messageID: 1123,
		// 		receiveTime: DateTime.now(),
		// 		sendTime: DateTime.now()
		// 	)
		// );

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


		final settingsAndroid = AndroidInitializationSettings('app_icon.png');
		final settingsIOS = IOSInitializationSettings(
			onDidReceiveLocalNotification: (id, title, body, payload) =>
				onSelectNotification(payload));

		localNotifications.initialize(
			InitializationSettings(settingsAndroid, settingsIOS),
			onSelectNotification: onSelectNotification);
	}

	Future onSelectNotification(String payload) async {
		if (payload != null) {
			debugPrint('notification payload: ' + payload);
		}
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
						children: messages.reversed.map(_getNotificationListItem).toList(),
					);
				},
				future: _getMessages(),
			),
			floatingActionButton: FloatingActionButton(
				backgroundColor: CurstomTheme().getTheme().primaryColor,
				onPressed: () async {
					// showDialog(
					// 	builder: (ctx){
					// 		return AlertDialog(
					// 			title: Text("Токен для FCM"),
					// 			content: SelectableText(_fcmToken),
					// 		);
					// 	},
					// 	context: context
					// );

					var androidPlatformChannelSpecifics = AndroidNotificationDetails(
						'your channel id', 'your channel name', 'your channel description',
						importance: Importance.Max, priority: Priority.Max, ticker: 'ticker');
					var iOSPlatformChannelSpecifics = IOSNotificationDetails();
					var platformChannelSpecifics = NotificationDetails(
						androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
					await localNotifications.show(
						0, 'plain title', 'plain body', platformChannelSpecifics,
						payload: 'item x');
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

	ListTile _getNotificationListItem(NotificationMessage message){
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