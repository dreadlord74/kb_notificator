import 'package:kb_notificator/database/database.dart';
import 'package:kb_notificator/notofications/notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kb_notificator/user/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class Notifications{
  static addMessage(NotificationMessage msg) async {
    final Database _db = await DBProvider.db.database;

    var result = await _db.rawInsert(
      "INSERT INTO Messages (title, body, messageSendTime, messageReceiveTime, status)"
      " VALUES ('${msg.title}', '${msg.body}', '${msg.sendTime}', '${msg.receiveTime}', '${msg.status}')"
    );

	var androidPlatformChannelSpecifics = AndroidNotificationDetails(
			'Channel ID', 'Получение оповещений', 'Оповещение для водителей',
		importance: Importance.Max, priority: Priority.Max, ticker: 'ticker');
	var iOSPlatformChannelSpecifics = IOSNotificationDetails();
	var platformChannelSpecifics = NotificationDetails(
		androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

	final localNotifications = FlutterLocalNotificationsPlugin();

	var lastMessage = await Notifications.getLastMessage();

	await localNotifications.show(
		0, lastMessage.title, lastMessage.body, platformChannelSpecifics,
			payload: '${lastMessage.id}');

    return result;
  }

  static Future<bool> setMessageStatusByID(int messageID, String newStatus, [String comment]) async{
    final url = "http://gradus-nik.ru/api/?command=driversAppMessageSetStatus";
    final _curUser = await User.getUser();

    http.Response res;

    switch (newStatus){
      case "accept":
        res = await http.post(
          url,
          body: {
            "phone": _curUser.phone,
            "status": "accept"
          }
        );
      break;

      case "decline":
        res = await http.post(
          url,
          body: {
            "phone": _curUser.phone,
            "status": "decline",
            "comment": comment
          }
        );
      break;
    }

    print(res.body);

    var changeRes = await changeMessageStatusByID(messageID, newStatus);

    return changeRes == 1;
  }

  static changeMessageStatusByID(int messageID, String newStatus) async{
    final Database _db = await DBProvider.db.database;

    return await _db.rawUpdate(
      "UPDATE Messages "
      "SET status='$newStatus' "
      "WHERE id='$messageID'"
    );
  }

  static Future<List<NotificationMessage>> getMessages() async {
    final Database _db = await DBProvider.db.database;

    var result = await _db.query(
      "Messages"
    );

    return result.isNotEmpty 
      ? result.map(
          (item) => NotificationMessage.fromJson(item)
        ).toList()
      : [];
  }

  static removeMessageByID(int msgID) async {
    final _db = await DBProvider.db.database;

    var result = await _db.delete(
      "Messages",
      where: "id = ?",
      whereArgs: [msgID]
    );

    return result;
  }

  static Future<NotificationMessage> getMessageByID(int msgID) async{
    final Database _db = await DBProvider.db.database;

    var result = await _db.query(
      "Messages",
      where: "id = ?",
      whereArgs: [msgID]
    );
    
    return result.isNotEmpty
      ? result.map(
        (item) => NotificationMessage.fromJson(item)
      ).toList()[0]
      : null;
  }

  static Future<NotificationMessage> getLastMessage() async {
	final Database _db = await DBProvider.db.database;

	var result = await _db.query(
		"Messages",
	);

	return result.isNotEmpty
		? result.map(
			(item) => NotificationMessage.fromJson(item)
		).toList()[result.length - 1]
		: null;
  }
}