import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kb_notificator/appBar/AppBarType.dart';
import 'package:kb_notificator/appBar/customAppBar.dart';
import 'package:kb_notificator/firstLaunchPlaceholder/fsPlaceholder.dart';
import 'package:kb_notificator/mainPlaceholder/mainPlaceholder.dart';
import 'package:kb_notificator/notofications/notification.dart';
import 'package:kb_notificator/notofications/notifications.dart';
import 'package:kb_notificator/user/user.dart';

enum MainBGType{
  image,
  gradient
}

class HomePage extends StatefulWidget{
	@override
	State<HomePage> createState() {
		return _HomePage();
	}
}

class _HomePage extends State<HomePage>{
	final FirebaseMessaging _fcm = FirebaseMessaging();
	final localNotifications = FlutterLocalNotificationsPlugin();

  MainBGType bgType = MainBGType.gradient;

  AppBarType appBarType = AppBarType.transparent;

  User _user;

	List<NotificationMessage> messages = [];

	String _fcmToken;

  // _setMainBG(MainBGType type){
  //   setState(() {
  //     bgType = type;
  //   });
  // }

	void _getMessages(){
    List<NotificationMessage> _messages;

    Notifications.getMessages().then((value){
      if (value.length == 0) {
        appBarType = AppBarType.transparent;
        return;
      }

      _messages = value;

      setState(() {
        messages = _messages;
        appBarType = AppBarType.white;
      });
    });
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

    User.getUser().then((User user){
      setState(() {
        _user = user;

        if (_user != null)
          if (_user.token != _fcmToken)
            _user.updateToken(_fcmToken);
      });
    });

    Notifications.getMessages().then((value){
      if (value.length == 0){
        appBarType = AppBarType.transparent;
        return;
      }

      setState(() {
        messages = value;
        appBarType = AppBarType.white;
      });
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

				
				_getMessages();
				
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
		_getMessages();
		
		await Navigator.pushNamed(context, "/listDetail/$payload");
	}

	@override 
	Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        (
          bgType == MainBGType.image
            ?
              Image.asset(
                "assets/main-bg.jpg",
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              )
            :
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
          appBar: CustomAppBar.getAppbar(context, appBarType, false, true),
          // body: FutureBuilder(
          //   builder: (ctx, snapshot){
          //     if (snapshot.hasData == null || snapshot.connectionState == ConnectionState.waiting){
          //       return MainPlaceholder();
          //     }

          //     if (snapshot.connectionState == ConnectionState.done && _user == null){
          //       return FSPlaceholder();
          //     }

          //     if (snapshot.connectionState == ConnectionState.done && messages.length == 0){
          //       return MainPlaceholder();
          //     }

          //     return ListView(
          //       children: messages.reversed.map(_getNotificationListItem).toList(),
          //     );
          //   },
          //   future: _getMessages(),
          // ),
          body: _user == null
                ? FSPlaceholder()
                : messages.length == 0
                  ? MainPlaceholder()
                  : _getMessagesContainer()
          // floatingActionButton: FloatingActionButton(
          //   backgroundColor: CurstomTheme().getTheme().primaryColor,
          //   onPressed: () async {
          //     showDialog(
          //       builder: (ctx){
          //         return AlertDialog(
          //           title: Text("Токен для FCM"),
          //           content: SelectableText(_fcmToken),
          //         );
          //       },
          //       context: context
          //     );
          //   },
          // ),
        )
      ],
    );
	}

  ListView _getMessagesContainer(){
    print(messages[0].status);
    print("${messages[0].receiveTime.hour}:${messages[0].receiveTime.minute}");

    List<ListTile> _ltArray = [];

    if (messages[0].status == "waiting")
      _ltArray.add(ListTile(
        contentPadding: EdgeInsets.all(22),
        leading: Image.asset(
          "assets/ico-new-message.png",
          width: 32.0,
          height: 36.0,
        ),
        title: Text(
          "У вас новое сообщение",
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold
          ),
        ),
        trailing: Image.asset(
          "assets/ico-arrow.png",
          width: 12.0,
          height: 8.0,
        ),
        onTap: (){
          Navigator.pushNamed(context, "/listDetail/${messages[0].id}");
        },
        
      ));

    _ltArray.add(ListTile(
      contentPadding: EdgeInsets.all(22),
      leading: Image.asset(
        "assets/ico-message.png",
        width: 32.0,
        height: 36.0,
      ),
      title: Text(
        "Все заявки",
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400
        ),
      ),
      trailing: Image.asset(
        "assets/ico-arrow.png",
        width: 12.0,
        height: 8.0,
      ),
      onTap: (){
        Navigator.pushNamed(context, "/allMessages/");
      },
    ));

    return ListView(
      padding: EdgeInsets.symmetric(vertical: 9, horizontal: 0),
      children: ListTile.divideTiles(
        context: context,
        tiles: _ltArray
      ).toList()
    );
  }

	// Icon _getNotificationIconByStatus(String status){
  //   print(status);
	// 	switch (status){
  //     case "accept":
  //       return Icon(
	// 				Icons.check,
	// 				color: Colors.white,
	// 			);

  //     break;

  //     case "decline":
  //       return Icon(
	// 				Icons.cancel,
	// 				color: Colors.white,
	// 			);
      
  //     break;

	// 		default:
  //       return Icon(
	// 				Icons.message,
	// 				color: Colors.white,
	// 			);
	// 	}
	// }

	// ListTile _getNotificationListItem(NotificationMessage message){
	// 	return ListTile(
	// 		leading: CircleAvatar(
	// 			backgroundColor: CurstomTheme().getTheme().primaryColor,
	// 			child: _getNotificationIconByStatus(message.status),
	// 		),
	// 		title: Text(message.title),
	// 		subtitle: Text(
	// 			message.body,
	// 			maxLines: 1,
	// 			softWrap: true,
	// 			overflow: TextOverflow.ellipsis,
	// 		),
	// 		onTap: (){
	// 			Navigator.pushNamed(context, "/listDetail/${message.id}");
	// 		},
	// 		onLongPress: () async{
	// 			var res = await Notifications.removeMessageByID(message.id);

	// 			if (res == 1)
	// 				_getMessages();
				
	// 		},
	// 	);
	// }
}